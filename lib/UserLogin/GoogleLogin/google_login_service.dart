
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:thingsonwheels/ResuableWidgets/toast_widget.dart';
import '../../main.dart';

class GoogleSignInProvider extends ChangeNotifier {

  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;//firebase auth instance
  final GoogleSignIn googleSignIn = GoogleSignIn(); //google Sign in instance

  bool _isLoading = false;
  bool get isLoading => _isLoading;

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

    _isLoading = true;
    notifyListeners();
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
        _isLoading = false;
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
            _isLoading = false;
            notifyListeners();
            break;

          case "null":
            _errorCode = "Some unexpected error came while trying to sign in";
             _hasError = true;
            _isLoading = false;
             //print("nothing");
             notifyListeners();
             break;

          default:
            _errorCode = e.toString();
            //print("nothing");
            _hasError = true;
            _isLoading = false;
            notifyListeners();
            }
      }
    }
    else
      {
        _isLoading = false;
       _hasError = true;
       notifyListeners();
      }
  }

  //Function to sign the userOUT
  Future signOut() async {
    await googleSignIn.signOut();
    await firebaseAuth.signOut();
    _isSignedIn = false;
    _isLoading = false;
    await storage.delete(key: 'LoggedIn');
    notifyListeners();
  }

  //check if the userExists already
  Future<bool> checkUserExists() async {
    try {
      var snapshot = await FirebaseFirestore.instance.collection('userInfo').doc(uid).get();

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
    try{
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
  catch(e)
    {
      throw e.toString();
    }
    }

    Future deleteGoogleRelatedAccount() async {
      try {
        // Update Firestore document to mark account for deletion
        await FirebaseFirestore.instance.collection('userInfo').doc(
            firebaseAuth.currentUser!.uid).update({
          'toBeDeleted': true,
        });
        // Clear local storage or perform other cleanup as needed
        await storage.delete(key: 'LoggedIn');

        showToast('Your account will be deleted within 30 days of inactivity. You can still login',Colors.green,Colors.white, 'SHORT');

      } catch (e) {
        showToast('Error occurred, please try again', Colors.red,Colors.white,'SHORT');

      }
    }
}