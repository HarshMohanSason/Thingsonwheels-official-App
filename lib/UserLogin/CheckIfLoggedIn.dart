



import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:thingsonwheels/HomeScreen.dart';

import 'IntroLoginScreenUI.dart';

class CheckIfLoggedIn extends StatefulWidget {
  const CheckIfLoggedIn({Key? key}) : super(key: key);

  @override
  State<CheckIfLoggedIn> createState() => _CheckIfLoggedInState();
}


class _CheckIfLoggedInState extends State<CheckIfLoggedIn> {

  FlutterSecureStorage storage = const FlutterSecureStorage();
  late bool ifLoggedIn;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose()
  {
    super.dispose();
   // _getUserIDAndFlag.dispose();
  }

  Future<void> initFuture()
  async {
    ifLoggedIn  = await checkIfLoggedIn();
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
            else if(snapshot.hasData)
            {
              return const HomeScreen();
            }
            else
            {
              return const LoginScreen();
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