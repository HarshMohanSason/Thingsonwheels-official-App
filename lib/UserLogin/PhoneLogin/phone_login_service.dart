
import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../main.dart';


class PhoneLoginService extends ChangeNotifier {

  bool _isLoading = false; //To display the circular progress indicator when completing a particular function
  bool get isLoading => _isLoading;
  set setIsLoading(bool val) {
    _isLoading = val;
    notifyListeners();
  }

  int? _resendToken;
  int? get resendToken => _resendToken;
  set setResendToken(int? val) {
    _resendToken = val;
    notifyListeners();
  }

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  bool _loggedInWithPhone = false;
  bool get loggedInWithPhone => _loggedInWithPhone;
  setLoggedInWithPhone(bool val) async {
    _loggedInWithPhone = val;
    notifyListeners();

    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('loggedInWithPhone', val);
  }

  PhoneLoginService() {
    _loadLoggedInWithPhone();
  }

  Future<void> _loadLoggedInWithPhone() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _loggedInWithPhone = prefs.getBool('loggedInWithPhone') ?? false;
    notifyListeners();
  }

  Future<bool> checkMerchantExistsWithSameNumber() async
  {
    try {
      if (loggedInWithPhone && FirebaseAuth.instance.currentUser != null) {
        var snapshot = await FirebaseFirestore.instance
            .collection('Merchants')
            .where('uid', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
            .get();

        if (snapshot.docs.isNotEmpty) {
          FirebaseAuth.instance.signOut();
          return true;
        }
      }
    } catch (e) {
     rethrow;
    }
    return false;
  }

  Future<bool> checkIfUserExistsFirestore(String phoneNo) async
  {
    try {
      var snapshot = await FirebaseFirestore.instance.collection('userInfo')
          .where('phoneNo',
          isEqualTo: phoneNo) //snapshot where that phoneNo exists in the userBase
          .get();

      if (snapshot.docs.isEmpty) {
        return false;
      }
      return true;
    }
    catch (e) {
      rethrow;
    }
  }


  Future<void> writeUserInfo(String phoneNo, String uid) async
  {
    try {
      final docSnapshot = FirebaseFirestore.instance.collection('userInfo').doc(
          uid);
      docSnapshot.set(
          {'phoneNo': phoneNo, 'uid': uid, 'provider': "PHONE"});
    }
    catch (e) {
      Center(child: Text("$e")); //display the error;
    }
  }


  Future<String> sendOTP(String phoneNo, {bool forceResend = false}) async {

    _isLoading = true;
    notifyListeners();

    Completer<String> completer = Completer<String>();

    try {

      await FirebaseAuth.instance.verifyPhoneNumber(

          phoneNumber: '+1$phoneNo',
          forceResendingToken: forceResend ? _resendToken : null,
          verificationCompleted: (
              PhoneAuthCredential credential) async { //if verification is completed, sign in
            await FirebaseAuth.instance.signInWithCredential(credential);
          },

          verificationFailed: (FirebaseAuthException e) async {
            if (e.code == 'too-many-requests') {
              Fluttertoast.showToast(
                msg: 'Too many requests. Please try again later.'.tr(),
                toastLength: Toast.LENGTH_LONG,
                gravity: ToastGravity.CENTER,
                backgroundColor: Colors.red,
                textColor: Colors.white,
                fontSize: 16.0,
              );
            }
            else {
              Fluttertoast.showToast(
                msg: e.message ?? 'An error occurred',
                toastLength: Toast.LENGTH_LONG,
                gravity: ToastGravity.CENTER,
                backgroundColor: Colors.red,
                textColor: Colors.white,
                fontSize: 16.0,
              );
            }
            _isLoading = false;
            notifyListeners();
            throw Exception(e.message);
          },

          codeSent: (String verificationId, int? resendToken) async {
            setResendToken = resendToken;
            completer.complete(verificationId);
          },
          codeAutoRetrievalTimeout: (String verificationId) {}
      );

      _isLoading = false;
      notifyListeners();
      return completer.future; //return the verification ID
    }
    catch (e) {
     _isLoading = false;
     notifyListeners();
     rethrow;
    }
  }

  //function to check the OTP
  Future<bool> checkOTP(String verificationID, String otpNo) async {

    _isLoading = true;
    notifyListeners();

    try {
      PhoneAuthCredential credential = PhoneAuthProvider.credential(verificationId: verificationID, smsCode: otpNo); //get the credentials from the verificationID of the sent text and the entered OTP
      User? user = (await FirebaseAuth.instance.signInWithCredential(credential)).user!; //sign in the user with credential

      if (!await checkIfUserExistsFirestore(user.phoneNumber!)) {
        writeUserInfo(user.phoneNumber!,
            user.uid); //write the userInfo if does not exist in firestore.
      }

      _isLoading = false; //Marking thew loading true because at this point the OTP number should be verified.
      notifyListeners();
      return true; //return true since the OTP matched
    }

    catch (e) {
      return false; //any errors caught, just return false for safety
    }
  }

  Future deletePhoneRelatedAccount() async {
    try {
      // Update Firestore document to mark account for deletion
      await FirebaseFirestore.instance.collection('userInfo').doc(
          FirebaseAuth.instance.currentUser!.uid).update({
        'toBeDeleted': true,
      });
      // Clear local storage or perform other cleanup as needed
      await storage.delete(key: 'LoggedIn');

      Fluttertoast.showToast(
        msg: 'Your account will be deleted within 30 days of inactivity. You can still login'.tr(),
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        backgroundColor: Colors.green,
        textColor: Colors.white,
      );
    } catch (e) {
      Fluttertoast.showToast(
        msg: 'An error occured, try again later'.tr(),
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        backgroundColor: Colors.red,
        textColor: Colors.white,
      );
    }
  }



}
