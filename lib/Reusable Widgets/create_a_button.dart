import 'package:flutter/material.dart';

class CreateAButton extends StatelessWidget {
  final double width;
  final double height;
  final Color buttonColor;
  final String buttonText;
  final Color textColor;
  final double borderRadius;
  final Color? borderColor; // Optional border color
  final double? textSize;

  const CreateAButton(
      {super.key,
      required this.width,
      required this.height,
      required this.buttonColor,
      required this.buttonText,
      required this.textColor,
      required this.borderRadius,
      this.textSize,
      this.borderColor});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
          color: buttonColor, // background color
          borderRadius: BorderRadius.circular(borderRadius),
          border: borderColor != null // Apply border only if provided
              ? Border.all(
                  color: borderColor!,
                )
              : null),
      child: Center(
        child: Text(
          buttonText,
          style: TextStyle(
            fontSize: textSize,
            fontWeight: FontWeight.bold,
            color: textColor,
          ),
        ),
      ),
    );
  }
}
