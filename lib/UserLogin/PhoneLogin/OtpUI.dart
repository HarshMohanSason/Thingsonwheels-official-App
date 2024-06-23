
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:pinput/pinput.dart';
import 'package:provider/provider.dart';
import 'package:thingsonwheels/HomeScreen.dart';
import 'package:thingsonwheels/MerchantsOnTow/MerchantOnTowService.dart';
import 'package:thingsonwheels/MerchantsOnTow/OnboardingFormUI.dart';
import 'package:thingsonwheels/UserLogin/PhoneLogin/PhoneLoginService.dart';
import '../../main.dart';

class OtpUI extends StatefulWidget {
  final String verificationID; //verification ID sent for that OTP token
  final String phoneNo;
  const OtpUI({super.key, required this.verificationID, required this.phoneNo});

  @override
  OtpUIState createState() => OtpUIState();
}

class OtpUIState extends State<OtpUI> {

  TextEditingController otpTextController = TextEditingController();
  final _formKey = GlobalKey<FormState>(); // GlobalKey for the Form
  late Timer timer;
  int remainingTime = 60; // Initial remaining time in seconds
  bool isResent = false;


  @override
  void initState() {

    super.initState();
    startTimer();
  }

  @override
  void dispose() {

    otpTextController.dispose();
    timer.cancel();
    super.dispose();
  }

  void startTimer() //Function to start the timer
  {
    const oneSec = Duration(seconds: 1);
    timer = Timer.periodic(oneSec, (timer) {
      setState(() {
        if(remainingTime < 1)
          {
            timer.cancel();
          }
        else
          {
            remainingTime --;
          }

      });
    });
  }

  @override
  Widget build(BuildContext context) {

    final phoneLoginLoading = context.watch<PhoneLoginService>();
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: EdgeInsets.only(top: screenWidth / 7),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            InkWell(
                onTap: () {
                  if (mounted) {
                    Navigator.pop(context);
                  }
                },
                child: Icon(
                  Icons.arrow_back,
                  size: screenWidth / 12,
                )),
            Padding(
              padding: EdgeInsets.only(top: screenHeight/25, left: 10),
              child: RichText(
                text: TextSpan(
                  text: 'Enter your code',
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,// Default text color
                    fontSize: screenHeight/24, // Default text size
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 25, left: 10),
              child: RichText(
                text: TextSpan(
                  text: '+1${widget.phoneNo}',
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,// Default text color
                    fontSize: screenHeight/35, // Default text size
                  ),
                ),
              ),
            ),
            SizedBox(height: screenWidth/2.5),
            Center(child: Form(
                key: _formKey,
                child: _pinInputUI(context))),
            const SizedBox(height: 20),
             Center(
                child: InkWell(
                  onTap: () async
                  {
                    if(remainingTime < 1)
                    {
                        otpTextController.clear();
                        String newOTPVerificationID = await phoneLoginLoading.sendOTP(widget.phoneNo); //send the OTP again.
                        isResent = await phoneLoginLoading.checkOTP(newOTPVerificationID, widget.phoneNo);
                        setState(() {
                          phoneLoginLoading.setIsLoading = false; // Ensure isLoading is set to false after resending OTP
                        });
                    }
                    else {
                      return;
                    }
                  },
                  child: phoneLoginLoading.isLoading ? const CircularProgressIndicator(color: Colors.black) : Text(
                                "Resend OTP?  $remainingTime s",
                                style: const TextStyle(fontSize: 15.5),
                           ),
                )),

          ],
        ),
      ),
    );
  }

  Widget _pinInputUI(BuildContext context) {

    final phoneLoginLoading = context.watch<PhoneLoginService>();
    final merchantProvider = context.watch<MerchantsOnTOWService>();
    return SizedBox(
      width: screenWidth - 20,
      child: Pinput(
          pinputAutovalidateMode: PinputAutovalidateMode.onSubmit,
          controller: otpTextController,
          length: 6, // Length for the OTP being entered
          defaultPinTheme: PinTheme(
            width: 100,
            height: 80,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(
                  21), // Adjust the border radius as needed
            ),
            textStyle: TextStyle(
              fontSize: screenWidth / 15,
              color: Colors.black, // White text color for better visibility
              fontWeight: FontWeight.bold,
            ),
          ),
         errorTextStyle: const TextStyle(
           color: Colors.white,
           fontWeight: FontWeight.bold,
         ),

          onCompleted: (value)
          async {
            try {
              if (_formKey.currentState!.validate()) {
                bool verifyOTP = await phoneLoginLoading.checkOTP(widget.verificationID, otpTextController.text); //check if the otp is verified
                phoneLoginLoading.setIsLoading = false; // Set loading to false
                if (verifyOTP && mounted && !merchantProvider.isMerchantSignUp) {
                  phoneLoginLoading.setLoggedInWithPhone = true;
                  Navigator.push(context, MaterialPageRoute(builder: (_) => const HomeScreen()));
                  await storage.write(key: 'LoggedIn', value: "true");
                  await storage.write(key: 'LoggedInWithPhone', value: "true");
                }
                else if(verifyOTP && mounted && merchantProvider.isMerchantSignUp)
                  {
                    Navigator.push(context, MaterialPageRoute(builder: (context)=> const OnboardingFormUI()));
                  }
                else if (isResent && mounted) {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (_) => const HomeScreen()));
                  await storage.write(key: 'LoggedIn', value: "true");
                }
              }
              else
                {
                phoneLoginLoading.setIsLoading = false;
                  Fluttertoast.showToast(
                    msg: 'OTP entered is invalid',
                    toastLength: Toast.LENGTH_SHORT,
                    gravity: ToastGravity.CENTER,
                    backgroundColor: Colors.red,
                    textColor: Colors.white,
                  );
                }
            }
            catch(e)
            {
              phoneLoginLoading.setIsLoading = false;
              Fluttertoast.showToast(
                msg: 'Error occurred, please try again',
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.CENTER,
                backgroundColor: Colors.red,
                textColor: Colors.white,
              );
            }

          },
          validator: (value) {
            final nonNumericRegExp = RegExp(r'^[0-9]');
            if (value!.isEmpty == true) {
              return 'OTP cannot be empty';
            }
            //check if the number isWithin 0-9 and is lowercase
            else if (!nonNumericRegExp.hasMatch(value)) {
              return 'OTP can only contain digits'; //return error if it doesn't match the REGEXP
            } else if (value.length < 6) {
              return 'OTP should be 6 digit number';
            }
            return null;
          }),
    );
  }
}
