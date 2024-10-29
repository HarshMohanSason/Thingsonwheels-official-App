import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:icons_flutter/icons_flutter.dart';
import 'package:provider/provider.dart';
import 'package:thingsonwheels/CheckOut/checkout_state.dart';
import 'package:thingsonwheels/Reusable%20Widgets/create_a_button.dart';
import 'package:thingsonwheels/home_screen.dart';
import 'package:thingsonwheels/main.dart';

import '../IconFiles/app_icons_icons.dart';

class PaymentConfirmation extends StatelessWidget {
  const PaymentConfirmation({super.key});

  @override
  Widget build(BuildContext context) {
    final checkOutState = Provider.of<CheckoutState>(context);
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Align(
              alignment: Alignment.topLeft,
              child: IconButton(
                  onPressed: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => HomeScreen())),
                  icon: Icon(AppIcons.home, color: Colors.black,
                  size: screenWidth/21,)),
            ),
            const Spacer(),
            SizedBox(
              width: screenWidth,
              child: Image.asset(
                'assets/images/payment_confirmation_image.png',
                fit: BoxFit.contain,
              ),
            ),
            SizedBox(
              height: screenWidth / 13,
            ),
            Text(
              "Payment Confirmed",
              style: TextStyle(
                  color: const Color(0xFF232323),
                  fontWeight: FontWeight.bold,
                  fontSize: screenWidth / 25),
            ),
            const SizedBox(
              height: 5,
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: screenWidth / 8),
              child: RichText(
                textAlign: TextAlign.center, // Center the text horizontally
                text: TextSpan(
                  text:
                      '\$${checkOutState.totalPrice} was successfully paid the item will\n',
                  // First line with a line break
                  style: TextStyle(
                    fontSize: screenWidth / 28,
                    color: Colors.black,
                  ),
                  children: <TextSpan>[
                    const TextSpan(
                      text:
                          ' be ready to be picked within ', // Second line part 1
                    ),
                    TextSpan(
                      text: '10 min', // Bold part
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: screenWidth / 28,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const Spacer(),
            Padding(
              padding: const EdgeInsets.only(bottom: 15.0),
              child: CreateAButton(
                width: screenWidth - 40,
                height: screenWidth / 8.5,
                textSize: screenWidth / 25,
                buttonColor: Colors.red,
                buttonText: 'Get Directions',
                textColor: Colors.white,
                borderRadius: 30,
                iconSize: screenWidth / 15,
                icon: Typicons.direction,
                iconColor: Colors.white,
              ),
            )
          ],
        ),
      ),
    );
  }
}
