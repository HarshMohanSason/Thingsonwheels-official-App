
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:thingsonwheels/AppSettings/about_us_ui.dart';
import 'package:thingsonwheels/AppSettings/terms_and_conditions_ui.dart';
import 'package:thingsonwheels/AppSettings/faq.dart';
import 'package:thingsonwheels/ResuableWidgets/language_change_button.dart';
import 'package:thingsonwheels/home_screen.dart';
import 'package:thingsonwheels/MerchantsOnTow/merchant_service.dart';
import 'package:thingsonwheels/MerchantsOnTow/merchant_home_screen.dart';
import 'package:thingsonwheels/ResuableWidgets/tow_text_animation.dart';
import 'package:thingsonwheels/UserLogin/AppleLogin/apple_login_service.dart';
import 'package:thingsonwheels/UserLogin/GoogleLogin/google_login_service.dart';
import 'package:thingsonwheels/UserLogin/PhoneLogin/phone_login_ui.dart';
import 'package:thingsonwheels/UserLogin/PhoneLogin/phone_login_service.dart';
import 'package:thingsonwheels/main.dart';
import '../UserLogin/intro_login_screen.dart';

class AppSettings extends StatefulWidget {
  const AppSettings({super.key});

  @override
  AppSettingsState createState() => AppSettingsState();
}

class AppSettingsState extends State<AppSettings> {
  String? imageUrl;
  String? name;
  String? phoneNumber;
  late User? user;
  bool isAlsoMerchant = false;

  @override
  void initState() {
    super.initState();
    user = FirebaseAuth.instance.currentUser;
    isAlsoAMerchant();
  }

  Future<bool> isAlsoAMerchant() async {
    try {
      var snapshot = await FirebaseFirestore.instance
          .collection('Merchants')
          .where('uid', isEqualTo: user!.uid)
          .get();
      if (snapshot.docs.isEmpty) {
        setState(() {
          isAlsoMerchant = false;
        });
        return isAlsoMerchant;
      }
      setState(() {
        isAlsoMerchant = true;
      });
      return isAlsoMerchant;
    } catch (e) {
      return false;
    }
  }


  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: Platform.isIOS ? false: true,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: SafeArea(
              child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  InkWell(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const HomeScreen()));
                      },
                      child: Icon(Icons.home, size: screenWidth / 14)),
                  const Spacer(),
                  isAlsoMerchant ?
                  InkWell(
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) =>  const MerchantProfileScreen()));
                    },
                    child: Icon(
                      size: screenWidth / 12,
                      Icons.change_circle,
                      color: colorTheme,
                    ),
                  ) : Container(),
                ],
              ),

              Center(
                child: Container(
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                      colors: [Colors.black, Colors.black87],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black26,
                        blurRadius: 10,
                        spreadRadius: 2,
                        offset: Offset(0, 5),
                      ),
                    ],
                  ),
                  child: CircleAvatar(
                    radius: screenWidth / 8,
                    backgroundColor: Colors.transparent, // Set transparent to show gradient
                    child: user!.photoURL != null
                        ? ClipOval(
                      child: Image.network(
                        user!.photoURL!,
                        fit: BoxFit.cover,
                        width: screenWidth / 4,
                        height: screenWidth / 4,
                        errorBuilder: (context, error, stackTrace) {
                          return Icon(Icons.person, size: screenWidth / 10, color: Colors.white);
                        },
                      ),
                    )
                        : Icon(Icons.person, size: screenWidth / 10, color: Colors.white),
                  )


                ),
              ),
              SizedBox(height: screenWidth / 30),
              Center(
                child: Text(
                  user!.displayName ?? user!.phoneNumber ?? '', // Use empty string if both are null
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: screenWidth / 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Center(child: LanguageSwitcherWidget(color: Colors.black,buttonContext: context)),
              const SizedBox(height: 5),
              Text(
                phoneNumber ?? '',
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 30),
              _buildTile(
                context,
                "About Us",
              ),
              const SizedBox(height: 20),
              _buildTile(context, "FAQ"),
              const SizedBox(height: 20),
              _buildTile(context, "Terms and Conditions"),
              const SizedBox(height: 20),
              _buildTile(context, "Register your business"),
              const SizedBox(height: 20),
              _buildTile(context, "Sign out"),
              const SizedBox(height: 50),
              Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                    padding: const EdgeInsets.only(bottom: 20),
                    child: Center(
                        child: TOWLogoAnimation(
                      fontSize: screenWidth / 8,
                    ))),
              )
            ],
          )),
        ),
      ),
    );
  }

  Widget _buildTile(BuildContext originalContext, String title) {
    final sp = originalContext.read<GoogleSignInProvider>();
    final ap = originalContext.read<AppleLoginService>();
    final phoneProvider = originalContext.read<PhoneLoginService>();
    final merchantProvider = originalContext.read<MerchantsOnTOWService>();

    return Card(
        elevation: 5,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.orange[300]!, Colors.orange[700]!],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(10),
          ),
          child: ListTile(
            title: Text(
              title.tr(),
              style: TextStyle(
                  fontSize: screenWidth / 21,
                  fontWeight: FontWeight.bold,
                  color: Colors.black),
            ),
            onTap: () async {
              if (title.tr() == "About Us".tr()) {
                Navigator.push(originalContext,
                    MaterialPageRoute(builder: (context) => const AboutUs()));
              } else if (title == "FAQ".tr()) {
                Navigator.push(
                    originalContext,
                    MaterialPageRoute(
                        builder: (context) => const PrivacyPolicy()));
              } else if (title.tr() == "Terms and Conditions".tr()) {
                Navigator.push(
                    originalContext,
                    MaterialPageRoute(
                        builder: (context) => const TermsAndConditions()));
              } else if (title.tr() == "Register your business".tr()) {
                bool doesExists = await phoneProvider.checkMerchantExistsWithSameNumber();
                 if(doesExists == true)
                  {
                    Fluttertoast.showToast(
                      msg: 'You already have an account registered with this number. Sign out login with a different number'.tr(),
                      toastLength: Toast.LENGTH_LONG,
                      gravity: ToastGravity.CENTER,
                      backgroundColor: Colors.lightBlue,
                      textColor: Colors.white,
                      fontSize: 16.0,
                    );
                  }
                else {
                  await userSignOut(sp, ap);

                  if(originalContext.mounted) {
                    Navigator.push(originalContext,
                        MaterialPageRoute(
                            builder: (context) => const IntroLoginScreenUI()));
                  }
                  merchantProvider.setIsMerchantSignup(true);
                  await Future.delayed(const Duration(seconds: 1));
                  if(originalContext.mounted) {
                    Navigator.push(
                        originalContext,
                        MaterialPageRoute(
                            builder: (context) => const PhoneLoginUi()));
                  }
                }
              } else {
                showDialog(
                  context: originalContext, // Use the context where showDialog is called
                  builder: (BuildContext dialogContext) { // Use dialogContext for the dialog
                    return AlertDialog(
                      backgroundColor: Colors.white,
                      title: Center(
                        child: Text(
                           "Are you sure you want to sign out?".tr(),
                          style: TextStyle(
                            fontSize: screenHeight / 40,
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      content: Padding(
                        padding: const EdgeInsets.only(left: 25, top: 20),
                        child: Row(
                          children: [
                            Expanded(
                              child: ElevatedButton(
                                onPressed: () async {
                                  await userSignOut(sp, ap);
                                  if(dialogContext.mounted) {
                                    if (dialogContext.findRenderObject()!
                                        .attached) {
                                      Navigator.push(
                                        dialogContext,
                                        MaterialPageRoute(
                                          builder: (
                                              context) => const IntroLoginScreenUI(),
                                        ),
                                      );
                                    }
                                  }
                                },
                                style: ButtonStyle(
                                  backgroundColor: WidgetStateProperty.all<Color>(const Color(0xFFFF9800)),
                                  shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                                    RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12.0),
                                    ),
                                  ),
                                  padding: WidgetStateProperty.all<EdgeInsetsGeometry>(
                                    EdgeInsets.symmetric(
                                      vertical: MediaQuery.of(dialogContext).size.height / 75,
                                      horizontal: MediaQuery.of(dialogContext).size.width / 58,
                                    ),
                                  ),
                                ),
                                child: Text(
                                  "Sign out".tr(),
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: screenHeight / 55,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 20),
                          ],
                        ),
                      ),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.of(dialogContext).pop(); // Close the dialog using dialogContext
                          },
                          child: Text(
                            "Cancel".tr(),
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: MediaQuery.of(dialogContext).size.width / 30,
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                );
              }
            },
          ),
        ));
  }

  Future<void> userSignOut(
      GoogleSignInProvider sp, AppleLoginService ap) async {
    if (sp.isSignedIn != null && sp.isSignedIn!) {
      await sp.signOut();
    } else if (ap.isSignedIn != null && ap.isSignedIn!) {
      await ap.signOut();
    } else {
      await FirebaseAuth.instance.signOut();
      await storage.delete(key: 'LoggedIn');
    }
  }
}
