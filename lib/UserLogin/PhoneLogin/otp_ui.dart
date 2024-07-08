
import 'dart:async';
import 'dart:io';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:pinput/pinput.dart';
import 'package:provider/provider.dart';
import 'package:thingsonwheels/home_screen.dart';
import 'package:thingsonwheels/MerchantsOnTow/merchant_service.dart';
import 'package:thingsonwheels/MerchantsOnTow/merchant_on_boarding_form.dart';
import 'package:thingsonwheels/UserLogin/PhoneLogin/phone_login_service.dart';
import '../../ResuableWidgets/toast_widget.dart';
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
  final _formKey = GlobalKey<FormState>();
  late Timer timer;
  int remainingTime = 60;
  bool verifyNewVerificationID = false;

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
    return PopScope(
      canPop: Platform.isIOS ? false: true,
      child: Scaffold(
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
                    text: 'Enter your code'.tr(),
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
              SizedBox(height: screenWidth/3.8),
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
                          String newOTPVerificationID = await phoneLoginLoading.sendOTP(widget.phoneNo, forceResend: true); //send the OTP again.
                          verifyNewVerificationID = await phoneLoginLoading.checkOTP(newOTPVerificationID, widget.phoneNo);
                          phoneLoginLoading.setIsLoading = false; // Ensure isLoading is set to false after resending OTP
                      }
                      else {
                        return;
                      }
                    },
                    child: phoneLoginLoading.isLoading ? const CircularProgressIndicator(color: Colors.black) : Text(
                                  "${"Resend OTP?".tr()} $remainingTime s",
                                  style: const TextStyle(fontSize: 15.5),
                             ),
                  )),

            ],
          ),
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
              if (!_formKey.currentState!.validate()) {
                phoneLoginLoading.setIsLoading = false;
                showToast('OTP entered is invalid', Colors.red, Colors.white, 'SHORT');
                return;
              }

              bool verifyOTP = await phoneLoginLoading.checkOTP(widget.verificationID, otpTextController.text);
              bool isAlreadyMerchant = await phoneLoginLoading.checkMerchantExistsWithSameNumber();
              phoneLoginLoading.setIsLoading = false;

              if (!verifyOTP) {
                showToast('OTP entered is invalid', Colors.red, Colors.white, 'SHORT');
                return;
              }

              if (context.mounted) {
                if (isAlreadyMerchant) {
                  if (merchantProvider.isMerchantSignUp) {
                    await _handleMerchantExistsAndSignUp(phoneLoginLoading);
                  } else {
                    await _handleMerchantExists(phoneLoginLoading);
                  }
                } else {
                  if (merchantProvider.isMerchantSignUp) {
                    await _handleNewMerchantSignUp();
                  } else {
                    await _handleNewUser(phoneLoginLoading);
                  }
                }
              }
            } catch (e) {
              phoneLoginLoading.setIsLoading = false;
              showToast('An error occurred: $e', Colors.red, Colors.white, 'SHORT');
            }
          },

          validator: (value) {
            final nonNumericRegExp = RegExp(r'^[0-9]');
            if (value!.isEmpty == true) {
              return 'OTP cannot be empty'.tr();
            }
            //check if the number isWithin 0-9 and is lowercase
            else if (!nonNumericRegExp.hasMatch(value)) {
              return 'OTP can only contain digits'.tr(); //return error if it doesn't match the REGEXP
            } else if (value.length < 6) {
              return 'OTP should be 6 digit number'.tr();
            }
            return null;
          }),
    );
  }

  Future<void> _handleMerchantExistsAndSignUp(PhoneLoginService phoneLoginLoading) async {
    Navigator.push(context, MaterialPageRoute(builder: (_) => const HomeScreen()));
    phoneLoginLoading.setLoggedInWithPhone(true);
    await storage.write(key: 'LoggedIn', value: "true");
    await storage.write(key: 'LoggedInWithPhone', value: "true");
    showToast('You already have a Merchant account registered with this number. Sign out login with a different number'.tr(), Colors.lightBlue, Colors.white, 'SHORT');
  }

  Future<void> _handleMerchantExists(PhoneLoginService phoneLoginLoading) async {
    phoneLoginLoading.setLoggedInWithPhone(true);
    Navigator.push(context, MaterialPageRoute(builder: (_) => const HomeScreen()));
    await storage.write(key: 'LoggedIn', value: "true");
    await storage.write(key: 'LoggedInWithPhone', value: "true");
  }

  Future<void> _handleNewMerchantSignUp() async {
    Navigator.push(context, MaterialPageRoute(builder: (context) => const OnboardingFormUI()));
  }

  Future<void> _handleNewUser(PhoneLoginService phoneLoginLoading) async {
    phoneLoginLoading.setLoggedInWithPhone(true);
    Navigator.push(context, MaterialPageRoute(builder: (_) => const HomeScreen()));
    await storage.write(key: 'LoggedIn', value: "true");
    await storage.write(key: 'LoggedInWithPhone', value: "true");
  }

}
