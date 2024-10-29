import 'package:flutter/material.dart';
import 'package:icons_flutter/icons_flutter.dart';

import '../main.dart';

class DisplayRating extends StatelessWidget {
  final int currentRating;

  const DisplayRating(
      {super.key, required this.currentRating});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: screenWidth / 9,
      height: screenWidth / 20,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        color: const Color(0xFF007012),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            FontAwesome.star,
            color: Colors.white,
            size: screenWidth / 43.2,
          ),
          const SizedBox(
            width: 5,
          ),
          Text(
            '$currentRating',
            style: TextStyle(
                color: Colors.white,
                fontSize: screenWidth / 36,
                fontWeight: FontWeight.w600),
          )
        ],
      ),
    );
  }
}
