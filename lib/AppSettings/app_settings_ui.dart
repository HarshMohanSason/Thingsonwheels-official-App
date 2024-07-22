import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:thingsonwheels/AppSettings/about_us_ui.dart';
import 'package:thingsonwheels/AppSettings/terms_and_conditions_ui.dart';
import 'package:thingsonwheels/AppSettings/faq.dart';
import 'package:thingsonwheels/MerchantsOnTow/merchant_on_boarding_form.dart';
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

  late GoogleSignInProvider googleSignServiceProvider;
  late AppleLoginService appleLoginServiceProvider;
  late PhoneLoginService phoneLoginServiceProvider;
  late MerchantsOnTOWService merchantsOnTOWServiceProvider;

  @override
  void initState() {
    super.initState();
    user = FirebaseAuth.instance.currentUser;
    isAlsoAMerchant();
  }

  @override
  void didChangeDependencies(){
    super.didChangeDependencies();
    googleSignServiceProvider = context.watch<GoogleSignInProvider>();
    appleLoginServiceProvider = context.watch<AppleLoginService>();
    phoneLoginServiceProvider = context.watch<PhoneLoginService>();
    merchantsOnTOWServiceProvider = context.watch<MerchantsOnTOWService>();
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
      canPop: Platform.isIOS ? false : true,
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
                  isAlsoMerchant
                      ? Padding(
                          padding: const EdgeInsets.only(right: 10),
                          child: InkWell(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          const MerchantProfileScreen()));
                            },
                            child: Text(
                              "Switch to merchant".tr(),
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                        )
                      : Container(),
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
                      backgroundColor: Colors.transparent,
                      // Set transparent to show gradient
                      child: user!.photoURL != null
                          ? ClipOval(
                              child: Image.network(
                                user!.photoURL!,
                                fit: BoxFit.cover,
                                width: screenWidth / 4,
                                height: screenWidth / 4,
                                errorBuilder: (context, error, stackTrace) {
                                  return Icon(Icons.person,
                                      size: screenWidth / 10,
                                      color: Colors.white);
                                },
                              ),
                            )
                          : Icon(Icons.person,
                              size: screenWidth / 10, color: Colors.white),
                    )),
              ),
              SizedBox(height: screenWidth / 30),
              Center(
                child: Text(
                  user!.displayName ?? user!.phoneNumber ?? '',
                  // Use empty string if both are null
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: screenWidth / 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Center(
                  child: LanguageSwitcherWidget(
                      color: Colors.black, buttonContext: context)),
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
              const SizedBox(height: 20),
              _buildTile(context, "Delete account"),
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
                if (isAlsoMerchant == true) {
                  Fluttertoast.showToast(
                    msg:
                        'You already have an account registered with this number. Sign out login with a different number'
                            .tr(),
                    toastLength: Toast.LENGTH_LONG,
                    gravity: ToastGravity.CENTER,
                    backgroundColor: Colors.lightBlue,
                    textColor: Colors.white,
                    fontSize: 16.0,
                  );
                } else if (phoneLoginServiceProvider.loggedInWithPhone == true && isAlsoMerchant == false &&
                    originalContext.mounted) {
                  Navigator.push(
                      originalContext,
                      MaterialPageRoute(
                          builder: (context) => const OnboardingFormUI()));
                }
                else {
                  await userSignOut(googleSignServiceProvider, appleLoginServiceProvider);
                  if (originalContext.mounted) {
                    Navigator.push(
                        originalContext,
                        MaterialPageRoute(
                            builder: (context) => const IntroLoginScreenUI()));
                  }
                  merchantsOnTOWServiceProvider.setIsMerchantSignup(true);
                  await Future.delayed(const Duration(seconds: 1));
                  if (originalContext.mounted) {
                    Navigator.push(
                        originalContext,
                        MaterialPageRoute(
                            builder: (context) => const PhoneLoginUi()));
                  }
                }
              }
              else if(title == "Delete account")
              {
                  showDeleteAccountDialog(originalContext);
              }
              else {
                showDialog(
                  context: originalContext,
                  // Use the context where showDialog is called
                  builder: (BuildContext dialogContext) {
                    // Use dialogContext for the dialog
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
                                  await userSignOut(googleSignServiceProvider, appleLoginServiceProvider);
                                  if (dialogContext.mounted) {
                                    if (dialogContext
                                        .findRenderObject()!
                                        .attached) {
                                      Navigator.push(
                                        dialogContext,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              const IntroLoginScreenUI(),
                                        ),
                                      );
                                    }
                                  }
                                },
                                style: ButtonStyle(
                                  backgroundColor:
                                      WidgetStateProperty.all<Color>(
                                          const Color(0xFFFF9800)),
                                  shape: WidgetStateProperty.all<
                                      RoundedRectangleBorder>(
                                    RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12.0),
                                    ),
                                  ),
                                  padding: WidgetStateProperty.all<
                                      EdgeInsetsGeometry>(
                                    EdgeInsets.symmetric(
                                      vertical: MediaQuery.of(dialogContext)
                                              .size
                                              .height /
                                          75,
                                      horizontal: MediaQuery.of(dialogContext)
                                              .size
                                              .width /
                                          58,
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
                            Navigator.of(dialogContext)
                                .pop(); // Close the dialog using dialogContext
                          },
                          child: Text(
                            "Cancel".tr(),
                            style: TextStyle(
                              color: Colors.black,
                              fontSize:
                                  MediaQuery.of(dialogContext).size.width / 30,
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

  Future<void> userSignOut(GoogleSignInProvider googleLoginServiceProvider, AppleLoginService appleLoginServiceProvider) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (googleLoginServiceProvider.isSignedIn != null && googleLoginServiceProvider.isSignedIn!) {
      await prefs.clear();
      await storage.deleteAll();
      await googleLoginServiceProvider.signOut();
    } else if (appleLoginServiceProvider.isSignedIn != null && appleLoginServiceProvider.isSignedIn!) {
      await prefs.clear();
      await storage.deleteAll();
      await appleLoginServiceProvider.signOut();
    } else {
      phoneLoginServiceProvider.setLoggedInWithPhone(false);
      await prefs.clear();
      await storage.deleteAll();
      await FirebaseAuth.instance.signOut();
    }
  }

  void showDeleteAccountDialog(BuildContext context) {

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          elevation: 5,
          shadowColor: Colors.black,
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          content: SafeArea(
            child: SizedBox(
              height: MediaQuery.of(context).size.height / 3.5,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.error_outline, color: Colors.red, size: MediaQuery.of(context).size.width / 5.5),
                  Padding(
                    padding: EdgeInsets.only(top: MediaQuery.of(context).size.width / 27),
                    child: Text(
                      'do_you_really_want_to_delete_your_account'.tr(),
                      style: TextStyle(fontSize: MediaQuery.of(context).size.height / 68),
                    ),
                  ),
                  const Spacer(),
                  Padding(
                    padding: EdgeInsets.only(bottom: MediaQuery.of(context).size.width / 17),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          style: ButtonStyle(
                            shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0),
                                side: const BorderSide(
                                  color: Colors.red,
                                  width: 1.0,
                                ),
                              ),
                            ),
                            backgroundColor: WidgetStateProperty.all<Color>(Colors.white),
                            fixedSize: WidgetStateProperty.all<Size>(
                              Size(MediaQuery.of(context).size.width / 3.5, MediaQuery.of(context).size.width / 43.2),
                            ),
                          ),
                          child:  Text(
                            'Cancel'.tr(),
                            style: const TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                            ),
                          ),
                        ),
                        ElevatedButton(
                          onPressed: () async {
                            try {
                              if (googleSignServiceProvider.isSignedIn != null && googleSignServiceProvider.isSignedIn!) {
                                await googleSignServiceProvider.deleteGoogleRelatedAccount();
                              } else if (appleLoginServiceProvider.isSignedIn != null && appleLoginServiceProvider.isSignedIn!) {
                                await appleLoginServiceProvider.deleteAppleRelatedAccount();
                              } else {
                                await merchantsOnTOWServiceProvider.deleteMerchantDocument();
                                await phoneLoginServiceProvider.deletePhoneRelatedAccount();
                              }
                              if (context.mounted) {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const IntroLoginScreenUI(),
                                  ),
                                );
                              }
                            } catch (e) {
                              Fluttertoast.showToast(
                                msg: 'Error occurred, please try again'.tr(),
                                toastLength: Toast.LENGTH_SHORT,
                                gravity: ToastGravity.CENTER,
                                backgroundColor: Colors.red,
                                textColor: Colors.white,
                              );
                            }
                          },
                          style: ButtonStyle(
                            shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                            ),
                            backgroundColor: WidgetStateProperty.all<Color>(Colors.red),
                            fixedSize: WidgetStateProperty.all<Size>(
                              Size(MediaQuery.of(context).size.width / 3.5, MediaQuery.of(context).size.width / 43.2),
                            ),
                          ),
                          child:  Text(
                            'delete'.tr(),
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }


}
