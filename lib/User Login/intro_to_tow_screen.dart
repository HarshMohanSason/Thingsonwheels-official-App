import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:thingsonwheels/Merchant%20Sign%20Up/add_menu_items.dart';
import 'package:thingsonwheels/Merchant%20Sign%20Up/merchant_sign_up_flow.dart';
import 'package:thingsonwheels/Reusable%20Widgets/divider_with_text_in_middle.dart';
import 'package:thingsonwheels/User%20Login/phone_number_enter_ui.dart';
import 'package:thingsonwheels/home_screen.dart';
import '../main.dart';

class IntroToTowScreen extends StatefulWidget {
  const IntroToTowScreen({super.key});

  @override
  IntroToTowScreenState createState() => IntroToTowScreenState();
}

class IntroToTowScreenState extends State<IntroToTowScreen> {
  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Scaffold(
          backgroundColor: Colors.white,
          body: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Stack(
                children: [
                  Container(
                    padding:  EdgeInsets.only(top: screenWidth/13),
                    height: screenHeight / 2.7,
                    decoration: const BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(85.0), // Adjust as needed
                        bottomRight: Radius.circular(85.0), // Adjust as needed
                      ),
                    ),
                    child: Image.asset(
                      'assets/images/food_truck.jpg',
                      scale: 3.5,
                    ),
                  ),
                  Positioned(
                    top: 50,
                    right: 10,
                    child: TextButton(
                      onPressed: () {
                       Navigator.push(context, MaterialPageRoute(builder: (context)=> const HomeScreen()));
                      },
                      style: TextButton.styleFrom(
                        backgroundColor: Colors.black.withOpacity(0.6),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 15, vertical: 10),
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                      child:Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            "Skip",
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: screenWidth/30,
                            ),
                          ),
                          Icon(
                            Icons.keyboard_double_arrow_right,
                            size: screenWidth/20,
                            color: Colors.white,
                          ),
                        ],
                      )
                    ),
                  )
                ],
              ),
              SizedBox(
                height: screenWidth / 3,
              ),
              Text(
                "Country’s #1 Food Truck ",
                style: TextStyle(
                    fontSize: screenWidth / 18, fontWeight: FontWeight.bold),
              ),
              Text(
                "and Community App",
                style: TextStyle(
                    fontSize: screenWidth / 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(
                height: 20,
              ),
              SizedBox(
                width: screenWidth - 80,
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.red,
                    borderRadius: BorderRadius.circular(30),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.red.withOpacity(0.5),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const HomeScreen()));
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                        side: const BorderSide(color: Colors.red, width: 2),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 15),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(left: 15, right: 15),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        // Align items
                        children: [
                          const Icon(
                            FontAwesomeIcons.truckMoving,
                            color: Colors.red, // Icon color
                          ),
                          Expanded(
                            child: Text(
                              'Sign up as a User',
                              textAlign: TextAlign.center,
                              // Center the text
                              style: TextStyle(
                                color: Colors.red,
                                fontWeight: FontWeight.bold, // Text color
                                fontSize: screenWidth / 25,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 15),
              const DividerWithTextInMiddle(textInBetween: 'OR'),
              const SizedBox(height: 15),
              SizedBox(
                width: screenWidth - 80,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const PhoneNumberEnterUi()));
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 15),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(left: 15),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        const Icon(
                          FontAwesomeIcons.truckMoving,
                          color: Colors.white,
                        ),
                        Expanded(
                          child: Text(
                            'Sign up as a Business Owner',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: screenWidth / 25,
                            ),
                          ),
                        ),
                        const SizedBox(width: 5),
                      ],
                    ),
                  ),
                ),
              )
            ],
          )),
    );
  }
}
