
import 'dart:async';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:thingsonwheels/ResuableWidgets/toast_widget.dart';
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
      if (FirebaseAuth.instance.currentUser != null) {
        var snapshot = await FirebaseFirestore.instance
            .collection('Merchants')
            .where('uid', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
            .get();

        if (snapshot.docs.isNotEmpty) {
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
      showToast('An error occurred, please try again'.tr(), Colors.red, Colors.white, 'SHORT');
      return false;
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
              showToast('Too many requests. Please try again later'.tr(), Colors.red, Colors.white, 'SHORT');
            }
            else {
              showToast(e.message ?? 'An error occurred', Colors.red, Colors.white, 'SHORT');
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
      await FirebaseFirestore.instance.collection('userInfo').doc(FirebaseAuth.instance.currentUser!.uid).delete();
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.clear();
      await storage.deleteAll();
      FirebaseAuth.instance.signOut();
      showToast('Your account and data have been deleted.'.tr(), Colors.green, Colors.white, 'LONG');
    } catch (e) {
      showToast('An error occurred, please try again'.tr(), Colors.red, Colors.white, 'SHORT');
    }
  }

  Future signOutViaPhone() async{
    try{
     await FirebaseAuth.instance.signOut();
     SharedPreferences prefs = await SharedPreferences.getInstance();
     await prefs.clear();
     await storage.deleteAll();
    }
    on SocketException{
      showToast("Check your Internet Connection".tr(), Colors.red, Colors.white,"SHORT");
    }
    catch (e){
      showToast("Could not sign out, please try again".tr(),Colors.red, Colors.white, "SHORT");
    }
  }

}
