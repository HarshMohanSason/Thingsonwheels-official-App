
import 'dart:ui';
import 'package:thingsonwheels/UserLogin/IntroLoginScreenUI.dart';
import 'package:thingsonwheels/UserLogin/PhoneLogin/OtpUI.dart';

import 'firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:provider/provider.dart';
import 'package:thingsonwheels/InternetProvider.dart';
import 'package:flutter/services.dart';
import 'package:thingsonwheels/UserLogin/GoogleLogin/GoogleLoginAuth.dart';
import 'UserLogin/CheckIfLoggedIn.dart';

Color colorTheme = Colors.orange; //Global color theme for the app

//get the FlutterView.
FlutterView view = WidgetsBinding.instance.platformDispatcher.views.first;

// Dimensions in logical pixels (dp)
Size screenSize = view.physicalSize / view.devicePixelRatio;
double screenWidth = screenSize.width;
double screenHeight = screenSize.height;

FlutterSecureStorage storage = const FlutterSecureStorage();

void main() async {

  WidgetsFlutterBinding.ensureInitialized(); //ensure all the widgets are initialized
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]) //Make sure the app is in portrait mode only
      .then((value) => runApp(const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(

      providers: [
        ChangeNotifierProvider(create: ((context)=> GoogleSignInProvider())),
        ChangeNotifierProvider(create: ((context) => InternetProvider())),
    ],
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: colorTheme),
          useMaterial3: true,
        ),
         home:  const CheckIfLoggedIn()),
    );
  }
}

