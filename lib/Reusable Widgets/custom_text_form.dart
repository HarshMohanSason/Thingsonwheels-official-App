import 'package:flutter/material.dart';
import 'package:thingsonwheels/main.dart';

class CustomTextForms extends StatelessWidget {
  const CustomTextForms(
      {super.key,
      required this.hintText,
       this.initialValue,
      this.labelText,
      this.controller,
      required this.hideText,
      required this.validator,
      this.maxLength,
      this.onSaved, this.maxLines, this.keyBoardType});


  final int? maxLines;
  final String hintText;
  final String? initialValue;
  final String? labelText;
  final TextEditingController? controller;
  final String? Function(String?) validator;
  final bool hideText;
  final int? maxLength;
  final TextInputType? keyBoardType;
  final Function(String?)? onSaved;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      keyboardType: keyBoardType,
      maxLines: maxLines,
      initialValue: initialValue,
      onSaved: onSaved,
      style: const TextStyle(),
      maxLength: maxLength,
      cursorColor: Colors.red,
      controller: controller,
      obscureText: hideText,
      decoration: InputDecoration(
          floatingLabelBehavior: FloatingLabelBehavior.always,
          labelStyle:  TextStyle(color: Colors.black,
          fontSize: screenWidth/20),
          // Makes the l
          labelText:labelText,
          //prefixIcon: Icon(icon, size: screenWidth / 20, color: Colors.black),
          hintText: hintText,
          hintStyle: TextStyle(
            fontSize: screenWidth/27
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(5),
            borderSide: BorderSide(
              color: Colors.grey.withOpacity(
                  0.2), // Change the border color to your preference
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(5),
            borderSide: BorderSide(
              color: Colors.grey.withOpacity(0.2),
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
      validator: validator,
    );
  }
}
