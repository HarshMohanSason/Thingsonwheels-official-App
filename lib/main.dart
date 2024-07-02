
import 'dart:ui';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:thingsonwheels/ResuableWidgets/language_state.dart';
import 'package:thingsonwheels/UserLogin/AppleLogin/apple_login_service.dart';
import 'package:thingsonwheels/ResuableWidgets/check_if_logged_in.dart';
import 'package:thingsonwheels/UserLogin/PhoneLogin/phone_login_service.dart';
import 'Location/location_service.dart';
import 'MerchantsOnTow/merchant_service.dart';
import 'firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:provider/provider.dart';
import 'package:thingsonwheels/ResuableWidgets/internet_provider.dart';
import 'package:flutter/services.dart';
import 'package:thingsonwheels/UserLogin/GoogleLogin/google_login_service.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart' as sqflite_ffi;

var colorTheme = Colors.orange; //Global color theme for the app
FlutterView view = WidgetsBinding.instance.platformDispatcher.views.first;

// Dimensions in logical pixels (dp)
Size screenSize = view.physicalSize / view.devicePixelRatio;
double screenWidth = screenSize.width; //Global variable for screenWidth
double screenHeight = screenSize.height; //Global variable for sreenHeight

FlutterSecureStorage storage = const FlutterSecureStorage(); //Global instance for secure Storage

void main() async {

  WidgetsBinding widgetsBinding =  WidgetsFlutterBinding.ensureInitialized(); //ensure all the widgets are initialized
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform,);
  await EasyLocalization.ensureInitialized();
  sqflite_ffi.sqfliteFfiInit();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]) //Make sure the app is in portrait mode only
      .then((value) => runApp(
    EasyLocalization(
      supportedLocales: const [Locale('en', 'US'), Locale('es', 'ES')],
      path: 'assets/translations', // <-- change the path of the translation files
      fallbackLocale: const Locale('en', 'US'),
      child: const MyApp(),
    ),

  ));
  FlutterNativeSplash.remove();
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
        ChangeNotifierProvider(create: ((context) => PhoneLoginService())),
        ChangeNotifierProvider(create: ((context) => AppleLoginService())),
        ChangeNotifierProvider(create: ((context) => MerchantsOnTOWService())),
        ChangeNotifierProvider(create: ((context) => LocationService())),
        ChangeNotifierProvider(create: (context) => LanguageState())
    ],
      child:   MaterialApp(
       debugShowCheckedModeBanner: false,
        title: 'Thingsonwheels',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: colorTheme),
          useMaterial3: true,
        ),
          localizationsDelegates: context.localizationDelegates,
          supportedLocales: context.supportedLocales,
          locale: context.locale,
         home:  const CheckIfLoggedIn()),
    );
  }
}

