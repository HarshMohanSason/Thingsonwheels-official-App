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
  final IconData? icon;
  final double? iconSize;
  final Color? iconColor;

  const CreateAButton(
      {super.key,
      required this.width,
      required this.height,
      required this.buttonColor,
      required this.buttonText,
      required this.textColor,
      required this.borderRadius,
      this.textSize,
      this.borderColor,
      this.icon,
      this.iconSize,
      this.iconColor});

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
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            buttonText,
            style: TextStyle(
              fontSize: textSize,
              fontWeight: FontWeight.bold,
              color: textColor,
            ),
          ),
          icon != null
              ? Padding(
                  padding: const EdgeInsets.only(left: 10),
                  child: Icon(
                    icon,
                    size: iconSize,
                    color: iconColor,
                  ))
              : Container()
        ],
      ),
    );
  }
}
