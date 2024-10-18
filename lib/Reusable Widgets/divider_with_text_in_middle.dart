
import 'package:flutter/material.dart';
import '../main.dart';

class DividerWithTextInMiddle extends StatelessWidget{
  final String textInBetween;
  final double? textSize;
  const DividerWithTextInMiddle({super.key, required this.textInBetween, this.textSize});

  @override
  Widget build(BuildContext context) {
    return  Padding(
      padding: const EdgeInsets.only(left: 10,right: 10),
      child: Row(
        children: [
          Expanded(
            child: Divider(
              thickness: 1,
              color: Colors.grey.shade300,
            ),
          ),
          Padding(
            padding:const EdgeInsets.symmetric(horizontal: 8.0),
            child: Text(
              textInBetween,
              style: TextStyle(
                fontSize: textSize ?? screenWidth/25, // Adjust the font size as needed
                color: const Color(0xFF6D6D6D), // Text color
              ),
            ),
          ),
          Expanded(
            child: Divider(
              thickness: 1,
              color: Colors.grey.shade300,
            ),
          ),
        ],
      ),
    );
  }


}