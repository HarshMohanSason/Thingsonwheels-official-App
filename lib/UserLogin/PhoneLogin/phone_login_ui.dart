
import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:thingsonwheels/MerchantsOnTow/merchant_service.dart';
import 'package:thingsonwheels/UserLogin/PhoneLogin/otp_ui.dart';
import 'package:thingsonwheels/UserLogin/PhoneLogin/phone_login_service.dart';
import 'package:thingsonwheels/main.dart';

class PhoneLoginUi extends StatefulWidget {
  const PhoneLoginUi({super.key});

  @override
  PhoneLoginScreenState createState() => PhoneLoginScreenState();
}

class PhoneLoginScreenState extends State<PhoneLoginUi> {
  TextEditingController phoneController = TextEditingController(); //controller for the text
  final _formKey = GlobalKey<FormState>(); // GlobalKey for the Form

  @override
  void dispose() {
    phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final phoneLoginLoading = context.watch<PhoneLoginService>();
    final merchantProvider = context.watch<MerchantsOnTOWService>();
    return PopScope(
      canPop: Platform.isIOS ? false: true,
      child: Scaffold(
          backgroundColor: Colors.white,
          body: Padding(
            padding: const EdgeInsets.only(top: 50),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                InkWell(
                    onTap: () {
                      if(mounted && merchantProvider.isMerchantSignUp == true)
                        {
                          merchantProvider.setIsMerchantSignup(false);
                          Navigator.pop(context);
                        }
                      else
                        if(mounted) {
                          Navigator.pop(context);
                        }
                    },
                    child: Icon(
                      Icons.arrow_back,
                      size: screenWidth / 12,
                    )),

                Padding(
                  padding: const EdgeInsets.only(top: 40, left: 10),
                  child: Center(
                    child: RichText(
                      text: TextSpan(
                        text: 'Please enter your'.tr(),
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,// Default text color
                          fontSize: screenHeight/25, // Default text size
                        ),
                        children:  <TextSpan>[
                          TextSpan(
                            text: 'number'.tr(),
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.black, // Different color for emphasis
                              // Slightly larger font for emphasis
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(height: screenWidth/4.1),
                Center(
                    child: Form(key: _formKey, child: phoneTextForm(context))),

                if (phoneLoginLoading.isLoading)
                  Container(
                    width: screenWidth,
                    height: screenHeight,
                    color: Colors.black.withOpacity(0.5), // Semi-transparent background
                    child: const Center(
                      child: CircularProgressIndicator(
                        color: Colors.black,
                      ),
                    ),
                  ),
              const Spacer(),
              Padding(
                  padding: const EdgeInsets.only(bottom: 40),
                  child: nextButton(context))],
            ),
          )),
    );
  }

  Widget phoneTextForm(BuildContext context) {

    return SizedBox(
      width: screenWidth - 20,
      child: TextFormField(
          keyboardType: TextInputType.number,
          // Make sure the keyboard opened is the number
          maxLength: 10,
          cursorColor: Colors.black,
          cursorWidth: 3,
          controller: phoneController,
          // keyboardType: TextInputType.text,
          style: TextStyle(
              fontSize: screenWidth / 18,
              color: Colors.black,
              fontWeight: FontWeight.bold),
          // Set input text color to white
          decoration: InputDecoration(
            hintText: '+1',
            hintStyle: TextStyle(
              fontSize: screenWidth / 20,
              color: Colors.grey, // Change the hint text color to your preference
            ),
            helperText: 'Enter your phone number'.tr(),
            helperStyle: TextStyle(
              fontSize: screenWidth / 25,
              color:
              Colors.grey, // Change the helper text color to your preference
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(5),
              borderSide: BorderSide(
                color: Colors.grey.withOpacity(
                    0.5), // Change the border color to your preference
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(5),
              borderSide: BorderSide(
                color: Colors.grey.withOpacity(0.5),
                // Change the focused border color to your preference
                width: 2,
              ),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(5),
              borderSide: const BorderSide(
                color: Colors.red,
                // Change the error border color to your preference
                width: 2,
              ),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(5),
              borderSide: const BorderSide(
                color: Colors.red,
                // Change the focused error border color to your preference
                width: 2,
              ),
            ),
          ),
          validator: (text) {
            final nonNumericRegExp =
                RegExp(r'^[0-9]+$'); //RegExp to match the phone number
            if (text!.isEmpty) {
              //return an error if the textForm is not empty
              return 'Phone number cannot be empty'.tr();
            }
            //check if the number isWithin 0-9.
            if (!nonNumericRegExp.hasMatch(text)) {
              return 'Phone number must contain only digits'.tr(); //
            }
            if (text.length <
                10) //Make sure the number is a total of 10 digits.
            {
              return 'Number should be a ten digit number'.tr();
            }

            return null;
          }),
    );
  }

  Widget nextButton(BuildContext context) {

    final phoneLoginLoading = context.watch<PhoneLoginService>();
    return Padding(
      padding: const EdgeInsets.only(left: 10),
      child: ElevatedButton(
          style: ButtonStyle(
            backgroundColor: WidgetStateProperty.all(Colors.orange),
            fixedSize: WidgetStateProperty.all<Size>(
              Size(screenWidth - 20, 40),
            ),
            shape: WidgetStateProperty.all<RoundedRectangleBorder>(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.0),
              ),
            ),
          ),
          onPressed: () async {
          //If the form is validated when pressing the next arrow button
            if (_formKey.currentState!.validate()) {
                String getOTPVerificationID = await phoneLoginLoading.sendOTP(
                    phoneController
                        .text); //send OTP verificationCode to that number
                if (context.mounted) {
                  Navigator.push(context, MaterialPageRoute(
                      builder: (context) =>
                          OtpUI(verificationID: getOTPVerificationID,
                              phoneNo: phoneController.text)));
                }
              }
          },
          child: Text(
            'Next'.tr(),
            style: const TextStyle(
                fontSize: 18, color: Colors.white, fontWeight: FontWeight.bold),
          )),
    );
  }
}
