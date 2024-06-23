
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:thingsonwheels/AppSettings/AboutUs.dart';
import 'package:thingsonwheels/AppSettings/Privacy%20Policy.dart';
import 'package:thingsonwheels/AppSettings/Terms&Conditions.dart';
import 'package:thingsonwheels/HomeScreen.dart';
import 'package:thingsonwheels/MerchantsOnTow/MerchantOnTowService.dart';
import 'package:thingsonwheels/MerchantsOnTow/MerchantProfileScreen.dart';
import 'package:thingsonwheels/MerchantsOnTow/OnboardingFormUI.dart';
import 'package:thingsonwheels/ResuableWidgets/ThingsOnWheelsAnimation.dart';
import 'package:thingsonwheels/UserLogin/AppleLogin/AppleLoginService.dart';
import 'package:thingsonwheels/UserLogin/GoogleLogin/GoogleLoginAuth.dart';
import 'package:thingsonwheels/UserLogin/PhoneLogin/PhoneLoginFormUI.dart';
import 'package:thingsonwheels/UserLogin/PhoneLogin/PhoneLoginService.dart';
import 'package:thingsonwheels/main.dart';
import 'package:url_launcher/url_launcher_string.dart';
import '../UserLogin/IntroLoginScreenUI.dart';

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
      canPop: false,
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
                      Navigator.push(context, MaterialPageRoute(builder: (context) => const MerchantProfileScreen()));
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
                child: CircleAvatar(
                  radius: screenWidth/8,
                  backgroundColor: Colors.black,
                  backgroundImage: user!.photoURL != null ? NetworkImage(user!.photoURL!) : null,
                  child: user!.photoURL == null
                      ?  Icon(Icons.person, size: screenWidth/10, color: Colors.white)
                      : null,
                ),
              ),

              SizedBox(height: screenWidth / 30),
              Center(
                child: Text(
                  user!.displayName ?? user!.phoneNumber!,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: screenWidth / 20, fontWeight: FontWeight.bold),
                ),
              ),
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
              _buildTile(context, "Privacy Policy"),
              const SizedBox(height: 20),
              _buildTile(context, "Terms and Conditions"),
              const SizedBox(height: 20),
              _buildTile(context, "Register your business"),
              const SizedBox(height: 20),
              _buildTile(context, "Sign Out"),
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

  Widget _buildTile(BuildContext context, String title) {
    final sp = context.read<GoogleSignInProvider>();
    final ap = context.read<AppleLoginService>();
    final phoneProvider = context.read<PhoneLoginService>();
    final merchantProvider = context.read<MerchantsOnTOWService>();

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
              title,
              style: TextStyle(
                  fontSize: screenWidth / 21,
                  fontWeight: FontWeight.bold,
                  color: Colors.black),
            ),
            onTap: () async {
              if (title == "About Us") {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => const AboutUs()));
              } else if (title == "Privacy Policy") {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const PrivacyPolicy()));
              } else if (title == "Terms and Conditions") {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const TermsAndConditions()));
              } else if (title == "Submit your recommended FoodTruck") {
                if (await canLaunchUrlString(
                    "https://forms.gle/rASyS8igzxhFqfXt6")) {
                  await launchUrlString("https://forms.gle/rASyS8igzxhFqfXt6");
                } else {
                  throw 'Could not launch the link';
                }
              } else if (title == "Register your business") {
                if (phoneProvider.loggedInWithPhone == true) {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const OnboardingFormUI()));
                } else {
                  await userSignOut(sp, ap);

                  Navigator.push(context,
                      MaterialPageRoute(
                          builder: (context) => const IntroLoginScreenUI()));
                  merchantProvider.setIsMerchantSignup = true;
                  await Future.delayed(Duration(seconds: 1));
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const PhoneLoginFormUI()));


                }
              } else {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      backgroundColor: Colors.white,
                      title: Center(
                        child: Text(
                          "Choose an Action",
                          style: TextStyle(
                            fontSize: MediaQuery.of(context).size.width / 18,
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      content: Padding(
                        padding: EdgeInsets.only(left: 25, top: 20),
                        child: Row(
                          children: [
                            Expanded(
                              child: ElevatedButton(
                                onPressed: () async {
                                  await userSignOut(sp, ap);
                                  if (mounted) {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => const IntroLoginScreenUI(),
                                      ),
                                    );
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
                                      vertical: MediaQuery.of(context).size.height / 50,
                                      horizontal: MediaQuery.of(context).size.width / 35,
                                    ),
                                  ),
                                ),
                                child: Text(
                                  "Sign out",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: screenHeight / 50,
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
                            Navigator.of(context).pop(); // Close the dialog
                          },
                          child: Text(
                            "Cancel",
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: MediaQuery.of(context).size.width /
                                  30, // Adjusted font size
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
