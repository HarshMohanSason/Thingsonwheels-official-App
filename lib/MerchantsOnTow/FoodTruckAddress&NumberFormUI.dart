

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../main.dart';

class FoodTruckAddressAndPhoneForm extends StatefulWidget {

  const FoodTruckAddressAndPhoneForm({super.key});

  @override
  State<StatefulWidget> createState() => FoodTruckAddressAndPhoneFormState();

}

class FoodTruckAddressAndPhoneFormState extends State<FoodTruckAddressAndPhoneForm>
{
  @override
  Widget build(BuildContext context) {

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [

        foodTruckPhoneNumberForm(context),
        const SizedBox(height: 40),
        foodTruckAddressForm(context),
      ],
    );
  }

  Widget foodTruckPhoneNumberForm(BuildContext context)
  {
    return TextFormField(
        keyboardType: TextInputType.text,
        cursorColor: colorTheme,
        maxLength: 10,
        cursorWidth: 4,
        style: TextStyle(
            fontSize: screenWidth / 18,
            color: Colors.white,
            fontWeight: FontWeight.bold),
        decoration: InputDecoration(
          helperText: 'Enter your food truck contact number',
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
        });
  }

  Widget foodTruckAddressForm(BuildContext context)
  {
    return TextFormField(
        keyboardType: TextInputType.name,
        cursorColor: colorTheme,
        cursorWidth: 4,
        style: TextStyle(
            fontSize: screenWidth / 18,
            color: Colors.white,
            fontWeight: FontWeight.bold),
        decoration: InputDecoration(
          helperText: 'Enter your food truck address',
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
          return null;
        });
  }
}
