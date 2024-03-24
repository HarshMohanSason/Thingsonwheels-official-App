
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:thingsonwheels/HomeScreen.dart';
import 'package:thingsonwheels/InternetProvider.dart';
import 'package:thingsonwheels/ResuableWidgets/ThingsOnWheelsAnimation.dart';
import 'package:thingsonwheels/UserLogin/AppleLogin/AppleLoginService.dart';
import 'package:thingsonwheels/UserLogin/GoogleLogin/GoogleLoginAuth.dart';
import 'package:thingsonwheels/UserLogin/PhoneLogin/PhoneLoginFormUI.dart';
import 'package:thingsonwheels/main.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';

import '../MerchantsOnTow/OnboardingFormUI.dart';


class LoginScreen extends StatefulWidget{

  const LoginScreen({super.key});

  @override
  LoginScreenState createState() => LoginScreenState();

}

class LoginScreenState extends State<LoginScreen> {
  @override
Widget build(BuildContext context) {
  final googleLoginLoading = context.watch<GoogleSignInProvider>();
  final appleLoginLoading = context.watch<AppleLoginService>();

  return PopScope(
    canPop: false,
    child: Scaffold(
      backgroundColor: colorTheme,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
             Center(
              child: TOWLogoAnimation(fontSize: screenWidth/8,),
            ),
            const SizedBox(height: 20),
            Center(
              child: Image.asset(
                "assets/images/Launch_Screen.png",
                height: MediaQuery.of(context).size.height * 0.4,
                fit: BoxFit.contain,
              ),
            ),
            const Spacer(),

            Column(
              children:[
                if (Platform.isIOS) ...[// Check if the platform is iOS
                  Align(
                      alignment: Alignment.center,
                      child: appleLoginLoading.isLoading
                          ? const CircularProgressIndicator(color: Colors.white) : SignInButton(
                          Buttons.Apple,
                          onPressed: () async {
                            try {
                              await handleAppleLogin(context);
                            } catch(e) {
                              e.toString();
                            }
                            if (appleLoginLoading.isSignedIn == true && mounted) {
                              Navigator.push(context, MaterialPageRoute(
                                builder: (context) => const HomeScreen(),
                              ));
                            }

                          }
                      )),
                  const SizedBox(height: 20),  ],
                Align(
                  alignment: Alignment.center,
                  child: googleLoginLoading.isLoading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : SignInButton(
                    Buttons.Google,
                    onPressed: () async {
                      try {
                        await handleGoogleLogin();
                      } catch(e) {
                        e.toString();
                      }
                      if (googleLoginLoading.isSignedIn == true && mounted) {
                        Navigator.push(context, MaterialPageRoute(
                          builder: (context) => const HomeScreen(),
                        ));
                      }
                    },
                  ),
                ),
                const SizedBox(height: 20),
                Align(
                  alignment: Alignment.center,
                  child: phoneLoginButton(),
                ),
                const SizedBox(height: 20),
                Align(
                  alignment: Alignment.center,
                  child: onboardingOnTowButton(),
                ),
              ],
            ),
          ],
        ),
      ),
    ),
  );
}


//Button for phone Login()
  Widget phoneLoginButton() {

    return Container(
      width: 218,
      height: 37,
      decoration:  BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        color: Colors.white,
        boxShadow: const [
          BoxShadow(
            color: Color(0x40000000),
            blurRadius: 5.0,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Material(
        child: InkWell(
          borderRadius: BorderRadius.circular(2.0),
          onTap: () async{
            await handlePhoneLogin(context, () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => const PhoneLoginFormUI()));
            });
          },
          child: const Center(
            child: Row(
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(left: 10),
                  child: Icon(
                    Icons.phone,
                    size: 18,
                    color: Colors.black,
                  ),
                ),
                SizedBox(width: 18),
                Text(
                  'Sign in with Phone',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> handleGoogleLogin() async {

    final sp = context.read<GoogleSignInProvider>();
    final ip = context.read<InternetProvider>();

    await ip.checkInternetConnection(); // Check internet connection

    if (!ip.hasInternet) {
      // Display a toast message if there is no internet connection
      Fluttertoast.showToast(
        msg: 'Check your Internet Connection',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        backgroundColor: Colors.white,
        textColor: Colors.black,
      );
    }

    else {
      try {
        // Attempt sign in with Google
        await sp.signInWithGoogle();

        await storage.write(key: 'LoggedIn', value: "true");
       } catch (e) {
        rethrow;
      }
    }
  }

  Future<void> handlePhoneLogin(BuildContext context, Function()  callback) async
  {
    final ip = context.read<InternetProvider>();
    await ip.checkInternetConnection(); // Check internet connection

    if (!ip.hasInternet) {
      // Display a toast message if there is no internet connection
      Fluttertoast.showToast(
        msg: 'Check your Internet Connection',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        backgroundColor: Colors.white,
        textColor: Colors.black,
      );
    }
    else {
      try {
        if(mounted) {
          callback(); // Execute the callback function
        }
      } catch (e) {
        rethrow;
      }
    }
  }

Future<void> handleAppleLogin(BuildContext context) async
{
  final ip = context.read<InternetProvider>();
  final ap = context.read<AppleLoginService>();

  await ip.checkInternetConnection(); // Check internet connection

  if (!ip.hasInternet) {
    // Display a toast message if there is no internet connection
    Fluttertoast.showToast(
      msg: 'Check your Internet Connection',
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.CENTER,
      backgroundColor: Colors.white,
      textColor: Colors.black,
    );
  }

  else {
    try {
      // Attempt sign in with Google
      await ap.appleLogin();
      await storage.write(key: 'LoggedIn', value: "true");
    } catch (e) {
      rethrow;
    }
  }
}

  /// Below method is designed to create button on login-screen and provide option to on-baord the merchant
  Widget onboardingOnTowButton() {

    return Container(
      width: 218,
      height: 37,
      decoration:  BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        color: Colors.white,
        boxShadow: const [
          BoxShadow(
            color: Color(0x40000000),
            blurRadius: 5.0,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Material(
        child: InkWell(
          borderRadius: BorderRadius.circular(2.0),
          onTap: () async {

            await handlePhoneLogin(context, () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => const OnboardingFormUI()));
            });
          },
          child: const Center(
            child: Row(
              children: <Widget>[
                SizedBox(width: 18),
                Text(
                  'Register Your Business',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
