
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:thingsonwheels/ResuableWidgets/splash_loading_screen.dart';
import 'package:thingsonwheels/home_screen.dart';
import 'intro_login_screen.dart';

class CheckIfLoggedIn extends StatefulWidget {
  const CheckIfLoggedIn({Key? key}) : super(key: key);

  @override
  State<CheckIfLoggedIn> createState() => _CheckIfLoggedInState();
}


class _CheckIfLoggedInState extends State<CheckIfLoggedIn> {

  FlutterSecureStorage storage = const FlutterSecureStorage();

  @override
  void initState() {

    initFuture();
    super.initState();
  }

  Future<void> initFuture()
  async {
    await checkIfLoggedIn();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
          future: checkIfLoggedIn(),
          builder: (context, AsyncSnapshot<bool> snapshot) {

            if(snapshot.connectionState == ConnectionState.waiting)
            {
              return const SplashLoadingScreen();
            }
            else if(snapshot.data == true)
            {
              return const HomeScreen();
            }
            else if(snapshot.hasError == true)
            { //Return to intro to login screen if any error occurs
              return const IntroLoginScreenUI();
            }
            {
              return const IntroLoginScreenUI();
            }
          }
      ),
    );
  }


  Future<bool> checkIfLoggedIn() async
  {
    try {
      if ((await storage.containsKey(key: 'LoggedIn')) && FirebaseAuth.instance.currentUser != null) {
        return true;
      }
    }
    catch (e) {
     return false;
    }
    return false;
  }

}