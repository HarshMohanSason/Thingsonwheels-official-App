

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../main.dart';

class FoodTruckSocialLinkForm extends StatefulWidget {

  const FoodTruckSocialLinkForm({super.key});

  @override
  State<StatefulWidget> createState() => FoodTruckSocialLinkFormState();

}

class FoodTruckSocialLinkFormState extends State<FoodTruckSocialLinkForm>
{
  @override
  Widget build(BuildContext context) {

    return SizedBox(
      width: screenWidth - 20,
      child: TextFormField(
        keyboardType: TextInputType.name,
        cursorColor: colorTheme,
        cursorWidth: 4,
        style: TextStyle(
            fontSize: screenWidth / 18,
            color: Colors.white,
            fontWeight: FontWeight.bold),
        decoration: InputDecoration(
          helperText: 'Enter your food truck social media link',
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
          RegExp(r'^[0-9]+$'); //RegExp to match the phone number
          if (text!.isEmpty) {
            //return an error if the textForm is not empty
            return 'Please enter a valid address';
          }
          if(!text.contains('https'))
          {
            return 'Social links need to have a valid https address';
          }
          return null;
        }),
    );
  }
}
