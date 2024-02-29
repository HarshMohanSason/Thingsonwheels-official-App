
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:thingsonwheels/HomeScreen.dart';
import 'package:thingsonwheels/InternetProvider.dart';
import 'package:thingsonwheels/ResuableWidgets/ThingsOnWheelsAnimation.dart';
import 'package:thingsonwheels/UserLogin/GoogleLogin/GoogleLoginAuth.dart';
import 'package:thingsonwheels/UserLogin/PhoneLogin/OtpUI.dart';
import 'package:thingsonwheels/UserLogin/PhoneLogin/PhoneLoginFormUI.dart';
import 'package:thingsonwheels/main.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';


class LoginScreen extends StatefulWidget{

  const LoginScreen({super.key});

  @override
  LoginScreenState createState() => LoginScreenState();

}

class LoginScreenState extends State<LoginScreen>
{


  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: colorTheme,
      body: Padding(
        padding: const EdgeInsets.only(top: 80),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            const Center(
              child: TOWLogoAnimation(),
            ),
            Column(
              children: [

                Center(child: Image.asset("assets/images/Launch_Screen.png")),

                Padding(
                  padding: EdgeInsets.only(top: screenWidth/4),
                  child: Column(
                    children: [
                      Align(
                        alignment: Alignment.center,
                        child: SignInButton(
                          Buttons.Google,
                          onPressed: () async {

                           await handleGoogleLogin();

                           // Check if the user is signed in with Google and then navigate to HomeScreen
                           if (mounted && context.read<GoogleSignInProvider>().isSignedIn == true) {
                             Navigator.push(context, MaterialPageRoute(
                               builder: (context) => const HomeScreen(),
                             ));
                           } else {
                            return;
                           }
                          },
                        ),
                      ),
                      SizedBox(height: screenHeight/23),
                      Align(
                        alignment: Alignment.center,
                        child: phoneLoginButton(),
                      )
                    ],
                  ),
                ),

              ],
            ),

          ],
        ),
      )
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
          onTap: () {
           Navigator.push(context, MaterialPageRoute(builder: (context) => const PhoneLoginFormUI()));
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

  Future handleGoogleLogin() async
  {
    final sp = context.read<GoogleSignInProvider>(); //setup Provide for the googleSignInProvider
    final ip = context.read<InternetProvider>(); //setup provider for InternetProvider

    await ip.checkInternetConnection();  //check the internet connection

    if(ip.hasInternet == false)
      {
        //Display a toast message if there is no internet connection present
        Fluttertoast.showToast(
          msg: 'Check your Internet Connections',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          backgroundColor: Colors.white,
          textColor: Colors.black,
        );
      }
    else
      {
        await sp.signInWithGoogle();
        await storage.write(key: 'LoggedIn', value: "true");
      }
  }

}