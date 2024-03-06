


import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:thingsonwheels/AppSettings/AboutUs.dart';
import 'package:thingsonwheels/AppSettings/Privacy%20Policy.dart';
import 'package:thingsonwheels/AppSettings/Terms&Conditions.dart';
import 'package:thingsonwheels/ResuableWidgets/ThingsOnWheelsAnimation.dart';
import 'package:thingsonwheels/UserLogin/GoogleLogin/GoogleLoginAuth.dart';
import 'package:thingsonwheels/UserLogin/IntroLoginScreenUI.dart';
import 'package:thingsonwheels/main.dart';
import 'package:url_launcher/url_launcher_string.dart';

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

              child: Icon(Icons.arrow_back, size: screenWidth/13)),

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
              SizedBox(height: screenWidth/34),
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
                style: TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 20),
              _buildTile(context, "About Us",),
              const SizedBox(height: 10),
              _buildTile(context, "Privacy Policy"),
              const  SizedBox(height: 10),
              _buildTile(context, "Terms and Conditions"),
              const  SizedBox(height: 10),
              _buildTile(context, "Submit a TOW"),
              const  SizedBox(height: 10),
              _buildTile(context, "Sign Out"),
              const  SizedBox(height: 120),
              const Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                    padding: EdgeInsets.only(bottom: 20),
                    child: Center(child: TOWLogoAnimation())),
              )
            ],
          )),
        ),
      ),
    );
  }


  Widget _buildTile(BuildContext context, String title) {
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
          else if (title == "Terms and Conditions")
            {
              Navigator.push(context, MaterialPageRoute(builder: (context)=> const TermsAndConditions()));
            }
          else if(title == "Submit a TOW")
            {
              if (await canLaunchUrlString("https://forms.gle/rASyS8igzxhFqfXt6")) {
                await launchUrlString("https://forms.gle/rASyS8igzxhFqfXt6");
              } else {
                throw 'Could not launch the link';
              }

            }
          else
            {
              final sp = context.read<GoogleSignInProvider>();
              if (sp.isSignedIn != null && sp.isSignedIn!) { // If the user is signed in with Google
               await sp.signOut(); // Sign out from Google
               if (mounted) {//Navigate to the homeScreen
                 Navigator.push(
                   context,
                   MaterialPageRoute(builder: (context) => const LoginScreen()),
                 );
               }
             }

            // Sign out from the Firebase Authentication
            await FirebaseAuth.instance.signOut();
            // Clear any local storage data
            await storage.deleteAll();
              if (mounted) {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const LoginScreen()),
                );
              }
          }
        },
      ),
    );
  }
}
