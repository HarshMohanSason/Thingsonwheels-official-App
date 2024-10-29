import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:thingsonwheels/Login%20Methods/Phone/phone_login_service.dart';
import 'package:thingsonwheels/Reusable%20Widgets/create_a_button.dart';
import 'package:thingsonwheels/Reusable%20Widgets/custom_text_form.dart';
import 'package:thingsonwheels/Reusable%20Widgets/text_form_validators.dart';
import 'package:thingsonwheels/Reusable%20Widgets/toast_widget.dart';
import 'package:thingsonwheels/main.dart';
import '../../IconFiles/app_icons_icons.dart';
import '../login_state.dart';
import 'otp_enter_ui.dart';

class PhoneNumberEnterUi extends StatefulWidget {
  const PhoneNumberEnterUi({super.key});

  @override
  PhoneNumberEnterUiState createState() => PhoneNumberEnterUiState();
}

class PhoneNumberEnterUiState extends State<PhoneNumberEnterUi> {
  final _phoneNumberFormKey = GlobalKey<FormState>();
  late  PhoneLoginService phoneLoginService;
  TextEditingController phoneController = TextEditingController();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    phoneLoginService = context.watch<PhoneLoginService>();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: Platform.isAndroid ? true : false,
      child: Scaffold(
        resizeToAvoidBottomInset: false,
          backgroundColor: Colors.white,
          body: Padding(
            padding: EdgeInsets.only(top: screenWidth / 6, left: 20, right: 20),
            child: Form(
              key: _phoneNumberFormKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Icon(
                     AppIcons.keyboard_backspace,
                      color: Colors.black,
                      size: screenWidth / 20,
                    ),
                  ),
                  SizedBox(
                    height: screenWidth / 5,
                  ),
                  Row(
                    children: [
                      Text(
                        "Welcome",
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: screenWidth / 9,
                            fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(width: 10,),
                      Icon(Icons.waving_hand_outlined,
                      size: screenWidth/13 ,)
                    ],
                  ),
                  Text(
                    "Please enter your sign in details",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: screenWidth / 25,
                    ),
                  ),
                  const SizedBox(
                    height: 50,
                  ),
                  CustomTextForms(
                    keyBoardType: TextInputType.phone,
                    hintText: 'Enter your phone number',
                    hideText: false,
                    validator: TextFormValidators.validatePhoneNumber,
                    maxLength: 10,
                    controller: phoneController,
                  ),
                  const Spacer(),
                  Center(
                      child: Text(
                    "By clicking Get OTP you agree with our",
                    style: TextStyle(
                        fontSize: screenWidth / 30),
                  )),
                  const SizedBox(
                    height: 3,
                  ),
                  Center(
                      child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("Terms and Conditions ",
                          style: TextStyle(

                              fontSize: screenWidth / 30,
                              fontWeight: FontWeight.bold)),
                      Text("and",
                          style: TextStyle(
                            fontSize: screenWidth / 30,
                          )),
                      Text(" Privacy Policy",
                          style: TextStyle(
                              fontSize: screenWidth / 30,
                              fontWeight: FontWeight.bold))
                    ],
                  )),
                  Padding(
                    padding:
                        EdgeInsets.only(top: 15, bottom: screenWidth / 6.0),
                    child: Center(
                      child: GestureDetector(
                        onTap: () async {
                          if (_phoneNumberFormKey.currentState!.validate()) {
                            await phoneLoginService.sendOTP(phoneController.text);
                            // Ensure to await the OTP sending to check the state after completion
                            if (context.mounted) {
                              // Check the current state after sending OTP
                              if (phoneLoginService.state.state == LoginStateEnum.loading) {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => OtpEnterUi(
                                      phoneNumber: phoneController.text,
                                    ),
                                  ),
                                );
                                phoneLoginService.setLoginState = const LoginState(state: LoginStateEnum.idle);
                              } else {
                                // Display the error message if not idle
                                if (phoneLoginService.state.state == LoginStateEnum.error) {
                                  showToast(
                                    phoneLoginService.state.errorMessage!,
                                    Colors.red,
                                    Colors.white,
                                    "SHORT",
                                  );
                                }
                              }
                            }
                          }
                        },
                        child: phoneLoginService.state.state ==
                                LoginStateEnum.loading
                            ? Image.asset('assets/GIFs/loading_indicator.gif',
                          scale: 13,) :
                        CreateAButton(
                                width: screenWidth - 80,
                                height: screenWidth / 8,
                                buttonColor: Colors.red,
                                buttonText: 'Get OTP',
                                textSize: screenWidth/25,
                                textColor: Colors.white, borderRadius: 8,
                              ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          )),
    );
  }
}
