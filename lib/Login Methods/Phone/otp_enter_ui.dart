import 'dart:async';
import 'package:flutter/material.dart';
import 'package:pinput/pinput.dart';
import 'package:provider/provider.dart';
import 'package:thingsonwheels/Login%20Methods/Phone/phone_login_service.dart';
import 'package:thingsonwheels/Merchant%20Sign%20Up/merchant_sign_up_flow.dart';
import 'package:thingsonwheels/Reusable%20Widgets/text_form_validators.dart';
import 'package:thingsonwheels/Reusable%20Widgets/toast_widget.dart';
import 'package:thingsonwheels/main.dart';

import '../intro_to_tow_screen.dart';
import '../login_state.dart';

class OtpEnterUi extends StatefulWidget {
  final String phoneNumber;

  const OtpEnterUi({super.key, required this.phoneNumber});

  @override
  OtpEnterUiState createState() => OtpEnterUiState();
}

class OtpEnterUiState extends State<OtpEnterUi> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController otpTextController = TextEditingController();
  late PhoneLoginService phoneLoginService;
  late Timer timer;
  int remainingTime = 60;

  void startTimer() {
    const oneSec = Duration(seconds: 1);
    timer = Timer.periodic(oneSec, (timer) {
      setState(() {
        if (remainingTime < 1) {
          timer.cancel();
        } else {
          remainingTime--;
        }
      });
    });
  }

  @override
  void initState() {
    super.initState();
    startTimer();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    phoneLoginService = context.watch<PhoneLoginService>();
  }

  @override
  void dispose() {
    otpTextController.dispose();
    timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Padding(
          padding: const EdgeInsets.only(left: 20, right: 20, top: 100),
          child: Form(
            autovalidateMode: AutovalidateMode.onUserInteraction,
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  "OTP Verification",
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: screenWidth / 14,
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Text(
                  "We have sent a verification code to",
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: screenWidth / 25,
                  ),
                ),
                Text(
                  "+1${widget.phoneNumber}",
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: screenWidth / 25,
                  ),
                ),
                const SizedBox(
                  height: 50,
                ),
                pinput(context),
                const SizedBox(
                  height: 30,
                ),
                GestureDetector(
                  onTap: () async {
                    if (_formKey.currentState!.validate()) {
                      bool isCorrectPinCode = await phoneLoginService
                          .verifyOTP(otpTextController.text);
                      if (context.mounted && isCorrectPinCode) {
                        Navigator.push(
                            (context),
                            MaterialPageRoute(
                                builder: (context) =>
                                    const MerchantSignUpFlow()));

                      } else {
                        showToast(phoneLoginService.state.errorMessage!,
                            Colors.red, Colors.white, "SHORT");
                      }
                    }
                  },
                  child: phoneLoginService.state.state == LoginStateEnum.loading
                      ? Center(
                          child: Image.asset(
                          'assets/GIFs/loading_indicator.gif',
                          scale: 13,
                        ))
                      : Container(),
                ),
                const SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Didn't receive the code? ",
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: screenWidth / 28,
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        if (remainingTime < 1) {
                          phoneLoginService.sendOTP(widget.phoneNumber,
                              forceResend: true);
                        }
                      },
                      child: Text(
                        "Resend? (${remainingTime}s) ",
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: remainingTime < 1
                              ? FontWeight.bold
                              : FontWeight.normal,
                          fontSize: screenWidth / 28,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 30,),
                GestureDetector(
                  onTap: ()
                  {
                    Navigator.push(context, MaterialPageRoute(builder: (context)=> const IntroToTowScreen()));
                  },
                  child: Text(
                    "Go back to the main screen ",
                    style: TextStyle(
                      color: Colors.red,
                      fontWeight: FontWeight.w600,
                      fontSize: screenWidth / 28,
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget pinput(BuildContext context) {
    return SizedBox(
        width: screenWidth - 20,
        child: Pinput(

            onCompleted: (pin) async {
              if (_formKey.currentState!.validate()) {
                bool isCorrectPinCode =
                    await phoneLoginService.verifyOTP(otpTextController.text);
                if (context.mounted && isCorrectPinCode) {
                  Navigator.push(
                      (context),
                      MaterialPageRoute(
                          builder: (context) => const MerchantSignUpFlow()));

                } else {
                  showToast(phoneLoginService.state.errorMessage!, Colors.red,
                      Colors.white, "SHORT");
                }
              }
            },
            controller: otpTextController,
            validator: TextFormValidators.validatePin,
            length: 6,
            defaultPinTheme: PinTheme(
              height: 60,
              decoration: BoxDecoration(
                color: Colors.white, // Set the inside color to white
                border: Border.all(color: Colors.grey.shade300, width: 2), // Set the border color to grey
                borderRadius: BorderRadius.circular(13),
              ),
              textStyle: TextStyle(
                fontSize: screenWidth / 18,
                color: Colors.black, // Text color
              ),
            ),
            errorTextStyle: const TextStyle(

              color: Colors.red,
              fontWeight: FontWeight.bold,
            )));
  }
}
