import 'package:flutter/material.dart';
import 'package:thingsonwheels/ResuableWidgets/ThingsOnWheelsAnimation.dart';
import 'package:thingsonwheels/UserLogin/PhoneLogin/OtpUI.dart';
import 'package:thingsonwheels/UserLogin/PhoneLogin/PhoneLoginService.dart';
import 'package:thingsonwheels/main.dart';

class PhoneLoginFormUI extends StatefulWidget {
  const PhoneLoginFormUI({super.key});

  @override
  PhoneLoginScreenState createState() => PhoneLoginScreenState();
}

class PhoneLoginScreenState extends State<PhoneLoginFormUI> {
  TextEditingController phoneController =
      TextEditingController(); //controller for the text
  final _formKey = GlobalKey<FormState>(); // GlobalKey for the Form

  @override
  void dispose() {
    phoneController.dispose(); //No memory leaks :)
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Scaffold(
          backgroundColor: colorTheme,
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
                const Padding(
                  padding: EdgeInsets.only(top: 40.0),
                  child: Center(child: TOWLogoAnimation()),
                ),
                SizedBox(height: screenWidth/2.3),
                Center(
                    child: Form(key: _formKey, child: phoneTextForm(context))),
              ],
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
          cursorColor: colorTheme,
          cursorWidth: 4,
          controller: phoneController,
          // keyboardType: TextInputType.text,
          style: TextStyle(
              fontSize: screenWidth / 18,
              color: Colors.white,
              fontWeight: FontWeight.bold),
          // Set input text color to white
          decoration: InputDecoration(
            suffixIcon: InkWell(
                onTap: () async {

                  if (phoneController.text.isEmpty) {
                    return;
                  }

                  //If the form is validated when pressing the next arrow button
                  if (_formKey.currentState!.validate()) {
                    String getOTPVerificationID = await sendOTP(phoneController.text); //send OTP verificationCode to that number
                    if (mounted) {

                      Navigator.push(context, MaterialPageRoute(
                          builder: (context) =>
                                  OtpUI(verificationID: getOTPVerificationID,
                                      phoneNo: phoneController.text)));
                    }
                  }
                },
                child: const Icon(Icons.arrow_forward)),
            helperText: 'Enter your US phone number',
            helperStyle: TextStyle(
              fontSize: screenWidth / 28,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
            // hintText
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(
                // decorate the border of the box
                width: 7,
                style: BorderStyle.solid,
                color: Colors.white, // Set border color to white
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(
                // decorate the border of the box
                width: 7,
                style: BorderStyle.solid,
                color: Colors.white, // Set border color to white
              ),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(
                // decorate the border of the box
                width: 7,
                style: BorderStyle.solid,
                color: Colors.white, // Set border color to white
              ),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(
                // decorate the border of the box
                width: 7,
                style: BorderStyle.solid,
                color: Colors.white, // Set border color to white
              ),
            ),
            errorStyle: TextStyle(
                color: Colors.white,
                fontSize: screenWidth / 28,
                fontWeight: FontWeight.bold),
            suffixIconColor: Colors.black,
          ),

          validator: (text) {
            final nonNumericRegExp =
                RegExp(r'^[0-9]+$'); //RegExp to match the phone number
            if (text!.isEmpty) {
              //return an error if the textForm is not empty
              return 'Please enter a valid phone number';
            }
            //check if the number isWithin 0-9.
            if (!nonNumericRegExp.hasMatch(text)) {
              return 'Phone number must contain only digits'; //
            }
            if (text.length <
                10) //Make sure the number is a total of 10 digits.
            {
              return 'Number should be a ten digit number';
            }

            return null;
          }),
    );
  }
}
