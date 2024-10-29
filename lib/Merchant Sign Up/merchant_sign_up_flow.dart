import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:thingsonwheels/Merchant%20Sign%20Up/add_menu_items.dart';
import 'package:thingsonwheels/Merchant%20Sign%20Up/merchant_business_image_upload.dart';
import 'package:thingsonwheels/Merchant%20Sign%20Up/merchant_structure.dart';
import 'package:thingsonwheels/Reusable%20Widgets/create_a_button.dart';
import 'package:thingsonwheels/Reusable%20Widgets/toast_widget.dart';
import 'package:thingsonwheels/home_screen.dart';
import 'package:thingsonwheels/main.dart';
import '../IconFiles/app_icons_icons.dart';
import '../Login Methods/intro_to_tow_screen.dart';
import 'merchant_sign_up_form_ui.dart';

class MerchantSignUpFlow extends StatefulWidget {
  const MerchantSignUpFlow({super.key});

  @override
  MerchantSignUpFlowState createState() => MerchantSignUpFlowState();
}

class MerchantSignUpFlowState extends State<MerchantSignUpFlow> {
  final _merchantFormKey = GlobalKey<FormState>();
  final List<Widget> signUpScreens = [];

  @override
  void initState() {
    super.initState();
    signUpScreens.add(MerchantSignUpFormUi(merchantFormKey: _merchantFormKey));
    signUpScreens.add(const MerchantBusinessImageUpload());
    signUpScreens.add(const AddMenuItems());
  }

  int _currentScreenIndex = 0;
  double _progressValue = 0;

  void _incrementBarProgress() {
    setState(() {
      _progressValue += 0.5;
      _currentScreenIndex += 1;
      if (_progressValue > 1.0) {
        _progressValue = 1.0;
      }
    });
  }

  void _decrementBarProgress() {
    setState(() {
      _progressValue -= 0.5;
      _currentScreenIndex -= 1;
      if (_progressValue < 0.0) {
        _progressValue = 0.0;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final merchantProvider = Provider.of<MerchantStructure>(context);
    return PopScope(
      canPop: Platform.isAndroid ? true : false,
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(25),
          child: AppBar(
            automaticallyImplyLeading: false,
            flexibleSpace: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                LinearProgressIndicator(
                  minHeight: 6,
                  value: _progressValue,
                  color: Colors.red,
                  backgroundColor: Colors.grey.shade300,
                ),
              ],
            ),
            backgroundColor: Colors.white, // Background color of AppBar
            elevation: 0, // Remove shadow
          ),
        ),
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          physics: const ScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.only(left: 20, right: 20),
            child: Column(
              children: [
                const SizedBox(
                  height: 20,
                ),
                Align(
                  alignment: Alignment.topLeft,
                  child: GestureDetector(
                    onTap: () {
                      if (_currentScreenIndex == 0) {
                        //make sure user signs out if they decide to cancel the leaving signing up
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    const IntroToTowScreen()));
                      } else {
                        _decrementBarProgress();
                      }
                    },
                    child: Icon(
                      AppIcons.keyboard_backspace,
                      color: Colors.black,
                      size: screenWidth / 20,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                signUpScreens[_currentScreenIndex],
              ],
            ),
          ),
        ),
        bottomSheet: Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.white, // Background color of the container
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2), // Shadow color
                blurRadius: 30, // Blur radius of the shadow
                offset: const Offset(0, 5), // Offset of the shadow
              ),
            ],
          ),
          padding: EdgeInsets.only(
              top: 15, bottom: screenWidth / 8, left: 20, right: 20),
          child: GestureDetector(
              onTap: () async {
                switch (_currentScreenIndex) {
                  case 0:
                    if (_merchantFormKey.currentState!.validate()) {
                      _incrementBarProgress();
                      _merchantFormKey.currentState!
                          .save(); //save the current State
                      break;
                    }
                  case 1:
                    if (merchantProvider.merchantBusinessImages[0] != null) {
                      _incrementBarProgress();
                    } else {
                      showToast(
                          "You need at least one main image for your profile",
                          Colors.red,
                          Colors.white,
                          "LONG");
                    }
                    break;
                  case 2:
                    if (merchantProvider.menuItems.length < 3) {
                      showToast(
                          "You need at least 3 menuItems for your profile",
                          Colors.red,
                          Colors.white,
                          "LONG");
                    } else {
                      await merchantProvider.uploadMerchantInformation();
                      if (merchantProvider.merchantSignUpState ==
                              MerchantSignUpStateEnum.success &&
                          context.mounted) {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const HomeScreen()));
                      } else {
                        return;
                      }
                      break;
                    }
                }
              },
              child: merchantProvider.merchantSignUpState ==
                      MerchantSignUpStateEnum.loading
                  ? Image.asset(
                      'assets/GIFs/loading_indicator.gif',
                      scale: 13,
                    )
                  : CreateAButton(
                      width: screenWidth - 40,
                      height: screenWidth / 8.5,
                      buttonColor: Colors.red,
                      buttonText: _currentScreenIndex > 1 ? 'Submit' : 'Next',
                      textColor: Colors.white,
                      textSize: screenWidth / 25,
                      borderRadius: 30,
                    )),
        ),
      ),
    );
  }
}
