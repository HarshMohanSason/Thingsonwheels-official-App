import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../../Reusable Widgets/toast_widget.dart';
import '../login_state.dart';

class EmailService extends ChangeNotifier {
  LoginState _state = const LoginState(state: LoginStateEnum.idle);

  String _fullName = "";
  String _phoneNumber = "";

  String get fullName => _fullName;

  String get phoneNumber => _phoneNumber;

  LoginState get state => _state;

  set fullName(String val) {
    _fullName = val;
    notifyListeners();
  }

  set phoneNumber(String val) {
    _phoneNumber = val;
    notifyListeners();
  }

  Future<void> startSigningUpProcess(String email, String password) async {
    _state = const LoginState(state: LoginStateEnum.loading);
    notifyListeners();

    try {
      //create the user and sign in using firebase
      UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);

      Map<String, dynamic> userData = {
        'FullName': _fullName,
        'Provider': 'Email',
        'uid': userCredential.user!.uid
      };
      //upload the user information to firebase
      await FirebaseFirestore.instance
          .collection('userInfo')
          .doc(userCredential.user!.uid)
          .set(userData);
      _state = const LoginState(state: LoginStateEnum.loggedIn);
      notifyListeners();
    } on SocketException catch (e) {
      _state = LoginState(state: LoginStateEnum.error, errorMessage: e.message);
      notifyListeners();
    } catch (e) {
      if (e is FirebaseAuthException) {
        switch (e.code) {
          case 'invalid-email':
            _state = const LoginState(
              state: LoginStateEnum.error,
              errorMessage: 'The email address is not valid.',
            );
            break;

          case 'user-disabled':
            _state = const LoginState(
              state: LoginStateEnum.error,
              errorMessage:
                  'This user has been disabled. Please contact support.',
            );
            break;

          case 'user-not-found':
            _state = const LoginState(
              state: LoginStateEnum.error,
              errorMessage: 'No user found with this email.',
            );
            break;

          case 'wrong-password':
          case 'invalid-credential':
          case 'INVALID_LOGIN_CREDENTIALS':
            _state = const LoginState(
              state: LoginStateEnum.error,
              errorMessage: 'Incorrect password or credentials.',
            );
            break;

          case 'too-many-requests':
            _state = const LoginState(
              state: LoginStateEnum.error,
              errorMessage: 'Too many attempts. Please try again later.',
            );
            break;

          case 'user-token-expired':
            _state = const LoginState(
              state: LoginStateEnum.error,
              errorMessage: 'Session expired. Please log in again.',
            );
            break;

          case 'network-request-failed':
            _state = const LoginState(
              state: LoginStateEnum.error,
              errorMessage: 'Network error. Check your internet connection.',
            );
            break;

          case 'operation-not-allowed':
            _state = const LoginState(
              state: LoginStateEnum.error,
              errorMessage: 'Sign-in with email/password is not enabled.',
            );
            break;

          default:
            _state = LoginState(
              state: LoginStateEnum.error,
              errorMessage: 'An unexpected error occurred: ${e.code}',
            );
            break;
        }
      } else {
        _state =
            LoginState(state: LoginStateEnum.error, errorMessage: e.toString());
      }
      notifyListeners();
    }
  }

  Future startEmailLoginProcess(String emailAddress, String password) async {
    _state = const LoginState(state: LoginStateEnum.loading);
    notifyListeners();

    try {
      await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: emailAddress, password: password);
      _state = const LoginState(state: LoginStateEnum.loggedIn);
      notifyListeners();
    } on SocketException catch (e) {
      _state = LoginState(state: LoginStateEnum.error, errorMessage: e.message);
      notifyListeners();
    } catch (e) {
      if (e is FirebaseAuthException) {
        switch (e.code) {
          case 'invalid-email':
            _state = const LoginState(
              state: LoginStateEnum.error,
              errorMessage: 'The email address is not valid.',
            );
            break;

          case 'user-disabled':
            _state = const LoginState(
              state: LoginStateEnum.error,
              errorMessage:
                  'This user has been disabled. Please contact support.',
            );
            break;

          case 'user-not-found':
            _state = const LoginState(
              state: LoginStateEnum.error,
              errorMessage: 'No user found with this email.',
            );
            break;

          case 'wrong-password':
          case 'invalid-credential':
          case 'INVALID_LOGIN_CREDENTIALS':
            _state = const LoginState(
              state: LoginStateEnum.error,
              errorMessage: 'Incorrect password or credentials.',
            );
            break;

          case 'too-many-requests':
            _state = const LoginState(
              state: LoginStateEnum.error,
              errorMessage: 'Too many attempts. Please try again later.',
            );
            break;

          case 'user-token-expired':
            _state = const LoginState(
              state: LoginStateEnum.error,
              errorMessage: 'Session expired. Please log in again.',
            );
            break;

          case 'network-request-failed':
            _state = const LoginState(
              state: LoginStateEnum.error,
              errorMessage: 'Network error. Check your internet connection.',
            );
            break;

          case 'operation-not-allowed':
            _state = const LoginState(
              state: LoginStateEnum.error,
              errorMessage: 'Sign-in with email/password is not enabled.',
            );
            break;

          default:
            _state = LoginState(
              state: LoginStateEnum.error,
              errorMessage: 'An unexpected error occurred: ${e.code}',
            );
            break;
        }
      } else {
        _state =
            LoginState(state: LoginStateEnum.error, errorMessage: e.toString());
      }
      notifyListeners();
    }
  }

  void handleEmailLoginState(BuildContext context, LoginStateEnum state,
      String? errorMessage, Widget destination) {
    switch (state) {
      case LoginStateEnum.error:
        if (errorMessage != null) {
          showToast(errorMessage, Colors.red, Colors.white, "SHORT");
        }
        break;

      case LoginStateEnum.loggedIn:
        if (context.mounted) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => destination),
          );
        }
        break;

      default:
        break;
    }
  }
}
