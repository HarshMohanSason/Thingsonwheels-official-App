import 'dart:ui';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart' as sqflite_ffi;
import 'package:thingsonwheels/Image%20Upload/image_upload_helper.dart';
import 'package:thingsonwheels/Merchant%20Sign%20Up/merchant_structure.dart';
import 'package:thingsonwheels/Social%20Media/post_upload_state.dart';
import 'package:thingsonwheels/User%20Login/intro_to_tow_screen.dart';
import 'package:thingsonwheels/User%20Login/phone_login_service.dart';

var colorTheme = Colors.orange; //Global color theme for the app
FlutterView view = WidgetsBinding.instance.platformDispatcher.views.first;

// Dimensions in logical pixels (dp)
Size screenSize = view.physicalSize / view.devicePixelRatio;
double screenWidth = screenSize.width; //Global variable for screenWidth
double screenHeight = screenSize.height; //Global variable for sreenHeight

FlutterSecureStorage storage =
    const FlutterSecureStorage(); //Global instance for secure Storage

void main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized(); //ensure all the widgets are initialized
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  await Firebase.initializeApp();
  await EasyLocalization.ensureInitialized();
  sqflite_ffi.sqfliteFfiInit();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp
  ]) //Make sure the app is in portrait mode only
      .then((value) => runApp(
            EasyLocalization(
              supportedLocales: const [Locale('en', 'US'), Locale('es', 'ES')],
              path: 'assets/translations',
              // <-- change the path of the translation files
              fallbackLocale: const Locale('en', 'US'),
              child: const Thingsonwheels(),
            ),
          ));
  FlutterNativeSplash.remove();
}

class Thingsonwheels extends StatelessWidget {
  const Thingsonwheels({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: ((context) => PhoneLoginService())),
        ChangeNotifierProvider(create: ((context)=> MerchantStructure())),
        ChangeNotifierProvider(create: ((context)=> ImageUploadHelper())),
        ChangeNotifierProvider(create: ((context)=>PostUploadState())),
        ChangeNotifierProvider(create: ((context)=> MenuItem()))
      ],
      child: MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Thingsonwheels',
          theme: ThemeData(
            fontFamily: 'Poppins',
            canvasColor: Colors.white,
            textSelectionTheme: const TextSelectionThemeData(cursorColor: Colors.red),
            colorScheme: ColorScheme.fromSeed(seedColor: colorTheme),
            useMaterial3: true,
          ),
          localizationsDelegates: context.localizationDelegates,
          supportedLocales: context.supportedLocales,
          locale: context.locale,
          home: const IntroToTowScreen()),
    );
  }
}
