import 'dart:io';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:thingsonwheels/ResuableWidgets/language_change_button.dart';
import 'package:thingsonwheels/ResuableWidgets/tow_text_animation.dart';
import 'package:thingsonwheels/UserLogin/AppleLogin/apple_login_service.dart';
import 'package:thingsonwheels/UserLogin/GoogleLogin/google_login_service.dart';
import 'package:thingsonwheels/UserLogin/PhoneLogin/phone_login_ui.dart';
import 'package:thingsonwheels/main.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';

import '../MerchantsOnTow/merchant_service.dart';
import '../home_screen.dart';

class IntroLoginScreenUI extends StatefulWidget {
  const IntroLoginScreenUI({Key? key}) : super(key: key);

  @override
  IntroLoginScreenUIState createState() => IntroLoginScreenUIState();
}

class IntroLoginScreenUIState extends State<IntroLoginScreenUI> {
  @override
  Widget build(BuildContext context) {
    final googleLoginLoading = context.watch<GoogleSignInProvider>();
    final appleLoginLoading = context.watch<AppleLoginService>();

    return Scaffold(
      backgroundColor: colorTheme,
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.orange[300]!, Colors.orange[700]!],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.2,
                child: Center(
                  child: TOWLogoAnimation(
                    fontSize: screenWidth / 8,
                  ),
                ),
              ),
              Center(
                child: Image.asset(
                  "assets/images/launch_screen.png",
                  height: MediaQuery.of(context).size.height * 0.4,
                  fit: BoxFit.contain,
                ),
              ),
              LanguageSwitcherWidget(
                color: Colors.white,
                buttonContext: context,
              ),
              const SizedBox(height: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  if (Platform.isIOS) ...[
                    Align(
                      alignment: Alignment.center,
                      child: appleLoginLoading.isLoading
                          ? const CircularProgressIndicator(
                        color: Colors.white,
                      )
                          : SignInButton(
                        Buttons.Apple,
                        onPressed: () async {
                          try {
                            await handleAppleLogin(context);
                            if (appleLoginLoading.isSignedIn == true &&
                                context.mounted) {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const HomeScreen(),
                                ),
                              );
                            }
                          } catch (e) {
                           // print(e.toString());
                          }
                        },
                      ),
                    ),
                    const SizedBox(height: 15),
                  ],
                  Align(
                    alignment: Alignment.center,
                    child: googleLoginLoading.isLoading
                        ? const CircularProgressIndicator(
                      color: Colors.white,
                    )
                        : SignInButton(
                      Buttons.Google,
                      onPressed: () async {
                        try {
                          await handleGoogleLogin();
                          if (googleLoginLoading.isSignedIn == true &&
                              context.mounted) {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const HomeScreen(),
                              ),
                            );
                          }
                        } catch (e) {
                          //print(e.toString());
                        }
                      },
                    ),
                  ),
                  const SizedBox(height: 20),
                  Align(
                    alignment: Alignment.center,
                    child: phoneLoginButton(),
                  ),
                  const SizedBox(height: 15),
                  Align(
                    alignment: Alignment.center,
                    child: onboardingOnTowButton(context),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget phoneLoginButton() {
    return Container(
      width: 218,
      height: 37,
      decoration: BoxDecoration(
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
        borderRadius: BorderRadius.circular(2),
        child: InkWell(
          borderRadius: BorderRadius.circular(12.0),
          onTap: () async {
            await handlePhoneLogin(context, () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const PhoneLoginUi()),
              );
            });
          },
          child: const Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(left: 10, right: 15),
                  child: Icon(
                    Icons.phone,
                    size: 18,
                    color: Colors.black,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(right: 38),
                  child: Text(
                    'Sign in with Phone',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
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

    try {
      await sp.signInWithGoogle();
      await storage.write(key: 'LoggedIn', value: "true");
    } catch (e) {
      rethrow;
    }
  }

  Future<void> handlePhoneLogin(
      BuildContext context, Function() callback) async {
    try {
      if (context.mounted) {
        callback();
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<void> handleAppleLogin(BuildContext context) async {
    final ap = context.read<AppleLoginService>();
    try {
      await ap.appleLogin();
      await storage.write(key: 'LoggedIn', value: "true");
    } catch (e) {
      rethrow;
    }
  }

  Widget onboardingOnTowButton(BuildContext context) {
    var provider = context.watch<MerchantsOnTOWService>();
    return GestureDetector(
      onTap: () {
        provider.setIsMerchantSignup(true);
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const PhoneLoginUi()),
        );
      },
      child: Center(
        child: RichText(
          textAlign: TextAlign.center,
          text: TextSpan(
            text: 'Business owner?'.tr(),
            style: TextStyle(
              color: Colors.black,
              fontSize: screenHeight / 50,
              fontWeight: FontWeight.bold,
            ),
            children: <TextSpan>[
              TextSpan(
                text: ' Register here'.tr(),
                style: const TextStyle(
                  fontStyle: FontStyle.italic,
                  decoration: TextDecoration.underline,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
