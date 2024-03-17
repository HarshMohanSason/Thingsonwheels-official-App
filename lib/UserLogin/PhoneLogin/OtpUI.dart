
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:pinput/pinput.dart';
import 'package:provider/provider.dart';
import 'package:thingsonwheels/ResuableWidgets/ThingsOnWheelsAnimation.dart';
import 'package:thingsonwheels/HomeScreen.dart';
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

    final phoneLoginLoading = context.watch<PhoneLoginProvider>();
    return Scaffold(
      backgroundColor: colorTheme,
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Padding(
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
                padding: EdgeInsets.only(top: 40.0),
                child: Center(child: TOWLogoAnimation(fontSize: screenWidth/8,)),
              ),
              SizedBox(height: screenWidth/2.5),
              Center(child: Form(
                  key: _formKey,
                  child: _pinInputUI(context))),
              const SizedBox(height: 15),
               Center(
                  child: InkWell(
                    onTap: () async
                    {
                      if(remainingTime < 1)
                      {
                          otpTextController.clear();
                          String newOTPVerificationID = await phoneLoginLoading.sendOTP(widget.phoneNo); //send the OTP again.
                          isResent = await phoneLoginLoading.checkOTP(newOTPVerificationID, widget.phoneNo);
                      }
                      else
                      {
                        return;
                      }
                    },
                    child: phoneLoginLoading.isLoading ? const CircularProgressIndicator(color: Colors.white) : Text(
                                  "Resend OTP?  $remainingTime s",
                                  style: const TextStyle(fontSize: 14.5),
                             ),
                  )),

            ],
          ),
        ),
      ),
    );
  }

  Widget _pinInputUI(BuildContext context) {

    final phoneLoginLoading = context.watch<PhoneLoginProvider>();
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
              color: Colors.black,
              borderRadius: BorderRadius.circular(
                  21), // Adjust the border radius as needed
            ),
            textStyle: TextStyle(
              fontSize: screenWidth / 15,
              color: Colors.white, // White text color for better visibility
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
                bool verifyOTP = await phoneLoginLoading.checkOTP(
                    widget.verificationID,
                    otpTextController.text); //check if the otp is verified

                if (verifyOTP && mounted) {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (_) => const HomeScreen()));
                  await storage.write(key: 'LoggedIn', value: "true");
                }
                else if (isResent && mounted) {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (_) => const HomeScreen()));
                  await storage.write(key: 'LoggedIn', value: "true");
                }
              }
              else
                {
                  Fluttertoast.showToast(
                    msg: 'OTP entered is invalid',
                    toastLength: Toast.LENGTH_SHORT,
                    gravity: ToastGravity.CENTER,
                    backgroundColor: Colors.white,
                    textColor: Colors.black,
                  );
                }
            }catch(e)
            {
              Fluttertoast.showToast(
                msg: 'Error occurred, please try again',
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.CENTER,
                backgroundColor: Colors.white,
                textColor: Colors.black,
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
