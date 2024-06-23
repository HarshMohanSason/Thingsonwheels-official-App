



import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:provider/provider.dart';
import 'package:thingsonwheels/HomeScreen.dart';
import 'package:thingsonwheels/UserLogin/GoogleLogin/GoogleLoginAuth.dart';

import 'IntroLoginScreenUI.dart';

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

  @override
  void dispose()
  {
    super.dispose();

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
              return const CircularProgressIndicator();
            }
            else if(snapshot.data == true)
            {
              return const HomeScreen();
            }
            else
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
      if ((await storage.containsKey(key: 'LoggedIn'))) {
        return true;
      }
    }
    catch (e) {
      rethrow;
    }
    return false;
  }

}