import 'dart:io';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sign_button/sign_button.dart';
import 'package:thingsonwheels/ResuableWidgets/language_change_button.dart';
import 'package:thingsonwheels/ResuableWidgets/tow_text_animation.dart';
import 'package:thingsonwheels/ResuableWidgets/wheel_animation.dart';
import 'package:thingsonwheels/UserLogin/AppleLogin/apple_login_service.dart';
import 'package:thingsonwheels/UserLogin/GoogleLogin/google_login_service.dart';
import 'package:thingsonwheels/UserLogin/PhoneLogin/phone_login_ui.dart';
import 'package:thingsonwheels/main.dart';
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

    return PopScope(
      canPop: false,
      child: Scaffold(
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
            padding:  EdgeInsets.symmetric(horizontal: 20.0, vertical: screenHeight/17),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: TOWLogoAnimation(
                    fontSize: screenWidth / 8,
                  ),
                ),
                SizedBox(height: screenHeight/20),
                const WheelAnimation(),
                 SizedBox(height:  screenHeight/20),
                Center(
                  child: LanguageSwitcherWidget(
                    color: Colors.white,
                    buttonContext: context,
                  ),
                ),
                const Spacer(),
                Padding(
                  padding: EdgeInsets.only(bottom: screenHeight/200),
                  child: Column(
                    children: [
                  if (Platform.isIOS) ...[
                    Align(
                      alignment: Alignment.center,
                      child: appleLoginLoading.isLoading
                          ? const CircularProgressIndicator(
                        color: Colors.white,
                      )
                          : SignInButton(
                        buttonType: ButtonType.apple,
                        onPressed: () async {
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
                        },
                      ),
                    ),
                    const SizedBox(height: 10),
                  ],
                  Align(
                    alignment: Alignment.center,
                    child: googleLoginLoading.isLoading
                        ? const CircularProgressIndicator(
                      color: Colors.white,
                    )
                        : SignInButton(
                      buttonType: ButtonType.google,
                      onPressed: () async {
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
                      },
                    ),
                  ),
                  const SizedBox(height: 15),
                  Align(
                    alignment: Alignment.center,
                    child: phoneLoginButton(),
                  ),
                  const SizedBox(height: 30),
                  Align(
                    alignment: Alignment.center,
                    child: onboardingOnTowButton(context),
                  ),
                                ],
                              ),
                ),
         ] ),
        ),
      ),
      )  );
  }

  Widget phoneLoginButton() {
    return Container(
      width: 230,
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
        borderRadius: BorderRadius.circular(20),
        child: InkWell(
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
                Icon(
                  Icons.phone,
                  size: 24,
                  color: Colors.black,
                ),
                SizedBox(width: 10),
                Padding(
                  padding: EdgeInsets.only(right: 11),
                  child: Text(
                    'Sign in with Phone',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 15,
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
              fontSize: screenWidth/23,
              fontWeight: FontWeight.bold,
            ),
            children: <TextSpan>[
              TextSpan(
                text: 'Register here'.tr(),
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
