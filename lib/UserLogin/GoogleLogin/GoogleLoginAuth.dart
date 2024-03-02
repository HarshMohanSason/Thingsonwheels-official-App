
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:pinput/pinput.dart';

import '../../main.dart';

class GoogleSignInProvider extends ChangeNotifier {

  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;//firebase auth instance
  final GoogleSignIn googleSignIn = GoogleSignIn(); //google Sign in instance

  String? _errorCode;
  String? get errorCode => _errorCode;

  bool? _isSignedIn;
  bool? get isSignedIn => _isSignedIn;

  bool? _hasError;
  bool? get hasError => _hasError;

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


  //Future function to signInWithGoogle
  Future signInWithGoogle() async {

    final GoogleSignInAccount? googleSignInAccount = await googleSignIn.signIn(); //Start the signIn process

    if (googleSignInAccount != null) {

      try {

        final GoogleSignInAuthentication googleSignInAuthentication = await googleSignInAccount
            .authentication;
        final AuthCredential credential = GoogleAuthProvider.credential(
          accessToken: googleSignInAuthentication.accessToken,
          idToken: googleSignInAuthentication.idToken,
        );

        //sign in to firebase using the user Instance
        final User userDetails = (await firebaseAuth.signInWithCredential(credential)).user!;

        _username = userDetails.displayName;
        _email = userDetails.email;
        _imageURL = userDetails.photoURL;
        _uid = userDetails.uid;
        _provider = "GOOGLE";
        _isSignedIn = true;
        notifyListeners();

        if (!await checkUserExists()) //check if the userExists in firestore or not, else logout
        {
          await saveDataToFirestore();
        }
        //catch any errors when logging the user in
      } on FirebaseAuthException catch (e) {

        switch(e.code)
            {
          case "account-exists-with-different-credential":
            _errorCode = "You already have an account with us. Use correct provider";
            _hasError = true;
            notifyListeners();
            break;

          case "null":
            _errorCode = "Some unexpected error came while trying to sign in";
             _hasError = true;
             //print("nothing");
             notifyListeners();
             break;

          default:
            _errorCode = e.toString();
            //print("nothing");
            _hasError = true;
            notifyListeners();
            }
     //
      }
    }
    else
      {
       _hasError = true;
       notifyListeners();
      }
  }

  //Function to sign the userOUT
  Future signOut() async {

    await googleSignIn.signOut();
    await firebaseAuth.signOut();
    _isSignedIn = false;
    await storage.deleteAll();
    notifyListeners();

  }

  //check if the userExists already
  Future<bool> checkUserExists() async {
    try {
      var snapshot = await FirebaseFirestore.instance.collection('userInfo')
          .doc(uid)
          .get();

      if (snapshot.exists) {
        return true;
      }
      return false;
    }
    catch(e)
    {
      rethrow;
    }
  }

  //Get user Data from Firestore
  Future getUserDataFromFirestore(uid) async{

    try {
      await FirebaseFirestore.instance.collection('userInfo').doc(uid)
          .get()
          .then((snapshot) {
        _uid = snapshot["uid"];
        _username = snapshot["username"];
        _email = snapshot["email"];
        _imageURL = snapshot["imageURL"];
        _provider = snapshot["provider"];
      });
    }
    catch(e)
    {
      return null;
    }
  }


  //Function to save the Data to the firestore database
  Future saveDataToFirestore() async
  {
    final docSnapshot = FirebaseFirestore.instance.collection('userInfo').doc(uid);
    await docSnapshot.set({
      "username": _username,
      "email": _email,
      "imageURL": _imageURL,
      "uid": _uid,
      "provider": _provider,
    });
    notifyListeners();
  }

}