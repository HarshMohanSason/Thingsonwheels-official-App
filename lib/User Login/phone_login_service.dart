import 'dart:async';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:thingsonwheels/User%20Login/login_state.dart';
import '../Reusable Widgets/toast_widget.dart';

class PhoneLoginService extends ChangeNotifier {

  LoginState _state = const LoginState(state: LoginStateEnum.idle);
  LoginState get state => _state;

  set setLoginState(LoginState state) {
    _state = state;
    notifyListeners();
  }

  int? _resendToken;
  int? get resendToken => _resendToken;

  set setResendToken(int? val) {
    _resendToken = val;
    notifyListeners();
  }

  String _verificationID = "";
  String get verificationID => _verificationID;

  set setVerificationID(String val) {
    _verificationID = val;
    notifyListeners();
  }

  Future<void> sendOTP(String number, {bool forceResend = false}) async {
    setLoginState = const LoginState(state: LoginStateEnum.loading);
    Completer<String> completer = Completer<String>();
    try {
      await FirebaseAuth.instance.verifyPhoneNumber(
          phoneNumber: '+1$number',
          forceResendingToken: forceResend ? _resendToken : null,
          verificationCompleted: (PhoneAuthCredential credential) async {
            //if verification is completed, sign in
            await FirebaseAuth.instance.signInWithCredential(credential);
          },
          verificationFailed: (FirebaseAuthException e) async {
            switch (e.code) {
              case 'invalid-phone-number':
                setLoginState = const LoginState(
                  state: LoginStateEnum.error,
                  errorMessage:
                      'Invalid phone number format. Please try again.',
                );
                break;
              case 'too-many-requests':
                setLoginState = const LoginState(
                  state: LoginStateEnum.error,
                  errorMessage: 'Too many requests. Please try again later.',
                );
                break;
              case 'quota-exceeded':
                setLoginState = const LoginState(
                  state: LoginStateEnum.error,
                  errorMessage: 'Quota exceeded. Please try again later.',
                );
                break;
              case 'network-request-failed':
                setLoginState = const LoginState(
                  state: LoginStateEnum.error,
                  errorMessage:
                      'Network error. Check your connection and try again.',
                );
                break;
              case 'app-not-authorized':
                setLoginState = const LoginState(
                  state: LoginStateEnum.error,
                  errorMessage: 'App not authorized. Contact support.',
                );
                break;
              default:
                setLoginState = LoginState(
                  state: LoginStateEnum.error,
                  errorMessage: e.message ??
                      'An unknown error occurred. Please try again.',
                );
                break;
            }
          },
          codeSent: (String verificationId, int? resendToken) async {
            setVerificationID = verificationId;
            setResendToken = resendToken; //save the resendToken
            completer.complete(verificationId);
          },
          codeAutoRetrievalTimeout: (String verificationId) {});
    } on SocketException {
      setLoginState = const LoginState(
          state: LoginStateEnum.error,
          errorMessage:
              "Connection lost, please check your internet connection");
    } catch (e) {
      setLoginState =
          LoginState(state: LoginStateEnum.error, errorMessage: e.toString());
    }
    setVerificationID = await completer.future;
  }

  Future<bool> verifyOTP(String pinCode) async {
    setLoginState = const LoginState(state: LoginStateEnum.loading);

    try {
      PhoneAuthCredential credential = PhoneAuthProvider.credential(
          verificationId: verificationID, smsCode: pinCode);
      User? user =
          (await FirebaseAuth.instance.signInWithCredential(credential))
              .user!; //sign in the user with credential

      if (!await checkIfUserExistsFirestore(user.phoneNumber!)) {
        writeUserInfo(user.phoneNumber!,
            user.uid); //write the userInfo if does not exist in firestore.
      }
      //User is finally logged in
      setLoginState = const LoginState(state: LoginStateEnum.loggedIn);
      return true;
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case 'invalid-verification-code':
          setLoginState = const LoginState(
            state: LoginStateEnum.error,
            errorMessage:
                'Invalid verification code. Please check and try again.',
          );
          break;
        case 'session-expired':
          setLoginState = const LoginState(
            state: LoginStateEnum.error,
            errorMessage: 'Session expired. Please request a new OTP.',
          );
          break;
        case 'quota-exceeded':
          setLoginState = const LoginState(
            state: LoginStateEnum.error,
            errorMessage: 'Quota exceeded. Please try again later.',
          );
          break;
        case 'too-many-requests':
          setLoginState = const LoginState(
            state: LoginStateEnum.error,
            errorMessage: 'Too many requests. Please wait and try again.',
          );
          break;
        default:
          setLoginState = const LoginState(
            state: LoginStateEnum.error,
            errorMessage: 'An unknown error occurred. Please try again.',
          );
          break;
      }
      return false;
    } on SocketException{
      setLoginState = const LoginState(
          state: LoginStateEnum.error,
          errorMessage:
              "Connection lost, please check your internet connection");
      return false;
    } catch (e) {
      setLoginState = LoginState(state: LoginStateEnum.error, errorMessage: e.toString());
      return false;
    }
  }

  Future<bool> checkIfUserExistsFirestore(String phoneNo) async {
    try {
      var snapshot = await FirebaseFirestore.instance
          .collection('userInfo')
          .where('PhoneNo',
              isEqualTo:
                  phoneNo) //snapshot where that phoneNo exists in the userBase
          .get();

      if (snapshot.docs.isEmpty) {
        return false;
      }
      return true;
    } catch (e) {
      showToast('An error occurred, please try again', Colors.red,
          Colors.white, 'SHORT');
      return false;
    }
  }

  Future<void> writeUserInfo(String phoneNo, String uid) async {
    try {
      final docSnapshot =
          FirebaseFirestore.instance.collection('userInfo').doc(uid);
      docSnapshot.set({'PhoneNo': phoneNo, 'uid': uid, 'Provider': "PHONE"});
    } catch (e) {
      showToast('An error occurred, please try again', Colors.red,
          Colors.white, 'SHORT');
    }
  }
}
