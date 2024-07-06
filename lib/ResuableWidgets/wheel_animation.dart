
import 'package:flutter/material.dart';

class WheelAnimation extends StatefulWidget {
  const WheelAnimation({super.key});

  @override
  State<WheelAnimation> createState() => WheelAnimationState();
}

class WheelAnimationState extends State<WheelAnimation> with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat(); // Repeats the animation indefinitely
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [

          RotationTransition(
            turns: _controller,
            child: Image.asset(
              'assets/images/wheel.png',
              width: screenWidth * 0.3, // 40% of the screen width
              height: screenWidth * 0.3, // 40% of the screen width to maintain aspect ratio
            ),
          ),
          SizedBox(height: screenHeight * 0.02), // Spacing between the images
          Image.asset(
            'assets/images/towText.png',
            width: screenWidth * 0.6, // 60% of the screen width
            height: screenWidth * 0.2, // Adjust the height proportionally
          ),
        ],
      ),
    );
  }
}