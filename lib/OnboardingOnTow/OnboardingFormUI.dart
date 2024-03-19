import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:thingsonwheels/OnboardingOnTow/FoodTruckAddress&NumberFormUI.dart';
import 'package:thingsonwheels/OnboardingOnTow/FoodTruckSocialLinkFormUI.dart';
import 'package:thingsonwheels/OnboardingOnTow/FoodtruckNameFormUI.dart';
import 'package:thingsonwheels/ResuableWidgets/ThingsOnWheelsAnimation.dart';
import 'package:thingsonwheels/UserLogin/PhoneLogin/OtpUI.dart';
import 'package:thingsonwheels/UserLogin/PhoneLogin/PhoneLoginService.dart';
import 'package:thingsonwheels/main.dart';

class OnboardingFormUI extends StatefulWidget {
  const OnboardingFormUI({super.key});

  @override
  OnboardingOnTowFormScreenState createState() => OnboardingOnTowFormScreenState();

}

class OnboardingOnTowFormScreenState extends State<OnboardingFormUI> with TickerProviderStateMixin{

  late AnimationController progressBarController;
  int currIndex = 0;
  static List<Widget> widgetScreens = [
    const FoodTruckNameForm(),
    const FoodTruckAddressAndPhoneForm(),
    const FoodTruckSocialLinkForm(),
  ];

  @override
  void initState()
  {
    super.initState();
    progressBarController =
    AnimationController(vsync: this, duration: const Duration(seconds: 5))
      ..addListener(() {
        setState(() {});
      });
    super.initState();
  }
  @override
  void dispose() {
    progressBarController.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return PopScope(
        canPop: false,
        child: Scaffold(
          backgroundColor: colorTheme,
        resizeToAvoidBottomInset:
        progressBarController.value > 0.5 ? true : false,
        body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
        Padding(
        padding: const EdgeInsets.only(top: 70),
         child: LinearProgressIndicator(
         value: progressBarController.value,
         valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
         backgroundColor: Colors.black,
         minHeight: 8),
              ),
        SizedBox(height: screenWidth/2),
        Center(child: widgetScreens[currIndex]),
         const  Spacer(),
          Padding(
              padding:const  EdgeInsets.only(bottom:20),
              child: _nextButton())
          ])
        )
          );
  }

  Widget _nextButton() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Align(
        alignment: Alignment.bottomCenter,
        child: InkWell(

          onTap: () async {
            setState(() {
             currIndex ++;
              });
                },
            child: Icon(Icons.forward,
              color: Colors.black,
              size: screenWidth / 5,),

            ),
        ),

    );
  }
}