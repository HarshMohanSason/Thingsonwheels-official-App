
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:thingsonwheels/AppSettings/AboutUs.dart';
import 'package:thingsonwheels/AppSettings/Privacy%20Policy.dart';
import 'package:thingsonwheels/AppSettings/Terms&Conditions.dart';
import 'package:thingsonwheels/MerchantsOnTow/OnboardingFormUI.dart';
import 'package:thingsonwheels/ResuableWidgets/ThingsOnWheelsAnimation.dart';
import 'package:thingsonwheels/UserLogin/AppleLogin/AppleLoginService.dart';
import 'package:thingsonwheels/UserLogin/GoogleLogin/GoogleLoginAuth.dart';
import 'package:thingsonwheels/main.dart';
import 'package:url_launcher/url_launcher_string.dart';
import '../UserLogin/IntroLoginScreenUI.dart';

class AppSettings extends StatefulWidget
{

  const AppSettings({super.key});

  @override
  AppSettingsState createState() => AppSettingsState();

}

class AppSettingsState extends State<AppSettings>
{
  String? imageUrl;
  String? name;
  String? phoneNumber;
  late User? user;

  @override
  void initState()
  {
    super.initState();
    user = FirebaseAuth.instance.currentUser;
  }


  @override
  Widget build(BuildContext context) {

    return  PopScope(
      canPop: false,
      child:  Scaffold(
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: SafeArea(child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              InkWell(

               onTap : ()
              {
                 Navigator.pop(context);
              },

              child: Icon(Icons.arrow_back, size: screenWidth/14)),

             /*   Center(
                child: CircleAvatar(
                  radius: screenWidth/8,
                  backgroundColor: Colors.black,
                  backgroundImage: user!.photoURL != null ? NetworkImage(user!.photoURL!) : null,
                  child: user!.photoURL == null
                      ?  Icon(Icons.person, size: screenWidth/10, color: Colors.white)
                      : null,
                ),
              ),
              */
              SizedBox(height: screenWidth/30),

              Center(
                child: Text(
                  user!.displayName ?? user!.phoneNumber!,
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: screenWidth/20, fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(height: 5),
              Text(
                phoneNumber ?? '',
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 20),
              _buildTile(context, "About Us",),
              const SizedBox(height: 10),
              _buildTile(context, "Privacy Policy"),
              const  SizedBox(height: 10),
              _buildTile(context, "Terms and Conditions"),
              const  SizedBox(height: 10),
              _buildTile(context, "Submit your recommended FoodTruck"),
              const  SizedBox(height: 10),
              _buildTile(context, "Sign Out / Delete Account"),
              const  SizedBox(height: 10),
              _buildTile(context, "Register your business"),
              const  SizedBox(height: 50),
               Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                    padding: const EdgeInsets.only(bottom: 20),
                    child: Center(child: TOWLogoAnimation(fontSize: screenWidth/8,))),
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

    return Card(
      color: Colors.orange,
      elevation: 5,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: ListTile(
        title: Text(
          title,
          style: TextStyle(fontSize: screenWidth/21, fontWeight: FontWeight.bold, color: Colors.black),
        ),
        onTap: () async {

          if (title == "About Us") {
            Navigator.push(context, MaterialPageRoute(builder: (context)=> const AboutUs()));
          }
          else if(title == "Privacy Policy"){
            Navigator.push(context, MaterialPageRoute(builder: (context)=> const PrivacyPolicy()));
          }
          else if (title == "Terms and Conditions") {
              Navigator.push(context, MaterialPageRoute(builder: (context)=> const TermsAndConditions()));
            }
          else if(title == "Submit your recommended FoodTruck") {
              if (await canLaunchUrlString("https://forms.gle/rASyS8igzxhFqfXt6")) {
                await launchUrlString("https://forms.gle/rASyS8igzxhFqfXt6");
              } else {
                throw 'Could not launch the link';
              }

            }
          else if(title=="Register your business"){
            Navigator.push(context, MaterialPageRoute(builder: (context)=> const OnboardingFormUI()));
          }
          else
            {
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
                  content: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () async {

                            if (sp.isSignedIn != null && sp.isSignedIn!) {
                              await sp.signOut();
                            }
                            else if(ap.isSignedIn != null && ap.isSignedIn!)
                              {
                                await ap.signOut();
                              }
                            else {
                              await FirebaseAuth.instance.signOut();
                              await storage.delete(key: 'LoggedIn');
                            }
                            if (mounted) {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const LoginScreen(),
                                ),
                              );
                            }
                          },
                          style: ButtonStyle(
                            minimumSize: MaterialStateProperty.all<Size>(
                              Size(
                                MediaQuery.of(context).size.width / 4,
                                MediaQuery.of(context).size.height / 15,
                              ),
                            ),
                            backgroundColor: MaterialStateProperty.all<Color>(Color(0xFFFF9800)),
                            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12.0),
                              ),
                            ),
                          ),
                          child: Text(
                            "Sign out",
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: MediaQuery.of(context).size.width / 30, // Adjusted font size
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 20), // Add space between buttons
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () async {
                            try {
                              if (sp.isSignedIn != null && sp.isSignedIn!) {
                                await sp.deleteGoogleRelatedAccount();
                              }
                              else if(ap.isSignedIn != null && ap.isSignedIn!)
                                {
                                  await ap.deleteAppleRelatedAccount();
                                }
                              else
                                {
                                  FirebaseFirestore.instance.collection('userInfo').doc(FirebaseAuth.instance.currentUser!.uid).delete();
                                  FirebaseAuth.instance.currentUser!.delete();
                                  await storage.delete(key: 'LoggedIn');
                                }
                              if (mounted) {
                                Fluttertoast.showToast(
                                  msg: 'Your account has been Deleted',
                                  toastLength: Toast.LENGTH_SHORT,
                                  gravity: ToastGravity.CENTER,
                                  backgroundColor: Colors.white,
                                  textColor: Colors.black,
                                );
                                Navigator.push(context, MaterialPageRoute(
                                    builder: (context) => const LoginScreen()));
                              }
                              await storage.delete(key: 'LoggedIn');
                            }
                            catch(e)
                            {

                              Fluttertoast.showToast(
                                msg: 'Error deleting your Account',
                                toastLength: Toast.LENGTH_SHORT,
                                gravity: ToastGravity.CENTER,
                                backgroundColor: Colors.white,
                                textColor: Colors.black,
                              );
                            }
                          },
                          style: ButtonStyle(
                            minimumSize: MaterialStateProperty.all<Size>(
                              Size(
                                MediaQuery.of(context).size.width / 4,
                                MediaQuery.of(context).size.height / 15,
                              ),
                            ),
                            backgroundColor: MaterialStateProperty.all<Color>(Color(0xFFFF9800)),
                            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12.0),
                              ),
                            ),
                          ),
                          child: Text(
                            "Delete Account",
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: MediaQuery.of(context).size.width / 30, // Adjusted font size
                            ),
                          ),
                        ),
                      ),
                    ],
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
                          fontSize: MediaQuery.of(context).size.width / 30, // Adjusted font size
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
    );
  }
}
