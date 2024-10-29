import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:crypto/crypto.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:thingsonwheels/Reusable%20Widgets/toast_widget.dart';
import '../../main.dart';
import '../login_state.dart';

class AppleLoginService extends ChangeNotifier {
  final FirebaseAuth firebaseAuth =
      FirebaseAuth.instance; //firebase auth instance

  LoginState _state = const LoginState(state: LoginStateEnum.idle);

  LoginState get state => _state;

  String? _provider;

  String? get provider => _provider;

  String? _uid;

  String? get uid => _uid;

  String? _username;

  String? get username => _username;

  String? _email;

  String? get email => _email;

  String? _imageURL;

  String? get imageURL => _imageURL;

  String sha256ofString(String input) {
    final bytes = utf8.encode(input);
    final digest = sha256.convert(bytes);
    return digest.toString();
  }

  //check if the userExists already
  Future<bool> checkUserExists() async {
    try {
      var snapshot = await FirebaseFirestore.instance
          .collection('userInfo')
          .doc(uid)
          .get();
      if (snapshot.exists) {
        return true;
      }
    } catch (e) {
      showToast(e.toString(), Colors.red, Colors.white, "SHORT");
    }
    return false;
  }

  Future<void> startSignInWithApple() async {
    _state = const LoginState(state: LoginStateEnum.loading);
    notifyListeners();
    try {
      final rawNonce = generateNonce();
      final nonce = sha256ofString(rawNonce);
      final appleCredential = await SignInWithApple.getAppleIDCredential(
        scopes: [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
        nonce: nonce,
      );

      // Check if the user canceled the sign-in process
      if (appleCredential.identityToken == null) {
        _state = const LoginState(state: LoginStateEnum.idle);
        notifyListeners();
        return; // Exit the method without further processing
      }

      final oauthCredential = OAuthProvider("apple.com").credential(
        idToken: appleCredential.identityToken,
        rawNonce: rawNonce,
      );

      final authResult =
          await firebaseAuth.signInWithCredential(oauthCredential);
      _username =
          await storage.read(key: 'appleUserName') ?? appleCredential.givenName;
      authResult.user!.displayName ??
          await firebaseAuth.currentUser!.updateDisplayName(_username);
      await firebaseAuth.currentUser!.updatePhotoURL("");
      _uid = authResult.user!.uid;
      _provider = "APPLE";

      if (!await checkUserExists() &&
          authResult.credential!.token != null &&
          appleCredential.identityToken != null) {
        //  await saveDataToFirestore();
      }
      _state = const LoginState(state: LoginStateEnum.loggedIn);
      notifyListeners();
    } on SignInWithAppleAuthorizationException {
      _state = const LoginState(state: LoginStateEnum.idle);
      notifyListeners();
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case "account-exists-with-different-credential":
          _state = const LoginState(
              state: LoginStateEnum.error,
              errorMessage:
                  "An account already exists with the same email address but different sign-in credentials.");

          break;

        case "invalid-credential":
          _state = const LoginState(
              state: LoginStateEnum.error,
              errorMessage: "The credential data is malformed or has expired.");
          break;

        case "operation-not-allowed":
          _state = const LoginState(
              state: LoginStateEnum.error,
              errorMessage:
                  "This type of account is not enabled. Enable it in the Firebase Console.");
          break;

        case "user-disabled":
          _state = const LoginState(
              state: LoginStateEnum.error,
              errorMessage:
                  "The user account has been disabled by an administrator.");
          break;

        case "user-not-found":
          _state = const LoginState(
              state: LoginStateEnum.error,
              errorMessage:
                  "No user corresponding to this identifier. The user may have been deleted.");
          break;

        case "wrong-password":
          _state = const LoginState(
              state: LoginStateEnum.error,
              errorMessage:
                  "The password is invalid or the user does not have a password.");
          break;

        case "invalid-verification-code":
          _state = const LoginState(
              state: LoginStateEnum.error,
              errorMessage: "The verification code provided is invalid.");
          break;

        case "invalid-verification-id":
          _state = const LoginState(
              state: LoginStateEnum.error,
              errorMessage: "The verification ID provided is invalid.");
          break;

        case "credential-already-in-use":
          _state = const LoginState(
              state: LoginStateEnum.error,
              errorMessage:
                  "This credential is already associated with a different user account.");
          break;

        case "weak-password":
          _state = const LoginState(
              state: LoginStateEnum.error,
              errorMessage: "The password provided is too weak.");
          break;

        case "email-already-in-use":
          _state = const LoginState(
              state: LoginStateEnum.error,
              errorMessage:
                  "The email address is already in use by another account.");
          break;

        case "invalid-email":
          _state = const LoginState(
              state: LoginStateEnum.error,
              errorMessage: "The email address is badly formatted.");
          break;

        case "network-request-failed":
          _state = const LoginState(
              state: LoginStateEnum.error,
              errorMessage:
                  "A network error occurred (e.g., timeout, interrupted connection).");
          break;

        case "too-many-requests":
          _state = const LoginState(
              state: LoginStateEnum.error,
              errorMessage:
                  "We have blocked all requests from this device due to unusual activity. Try again later.");
          break;

        case "user-token-expired":
          _state = const LoginState(
              state: LoginStateEnum.error,
              errorMessage:
                  "The user's credential is no longer valid. The user must sign in again.");
          break;

        case "user-mismatch":
          _state = const LoginState(
              state: LoginStateEnum.error,
              errorMessage:
                  "The supplied credentials do not correspond to the previously signed-in user.");
          break;

        case "requires-recent-login":
          _state = const LoginState(
              state: LoginStateEnum.error,
              errorMessage:
                  "This operation is sensitive and requires recent authentication. Log in again before retrying this request.");
          break;

        default:
          _state = const LoginState(
              state: LoginStateEnum.error,
              errorMessage: "An undefined Error happened.");
          break;
      }
      notifyListeners();
    }
  }
}
