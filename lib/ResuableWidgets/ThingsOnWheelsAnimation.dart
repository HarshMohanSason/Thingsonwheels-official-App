

import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/cupertino.dart';

import '../main.dart';

class TOWLogoAnimation extends StatefulWidget
{

  const TOWLogoAnimation({super.key});

  @override
  TOWLogoAnimationState createState()=> TOWLogoAnimationState();
}

class  TOWLogoAnimationState extends State<TOWLogoAnimation>
{
  @override
  Widget build(BuildContext context) {
    return  AnimatedTextKit(
      animatedTexts: [
        TypewriterAnimatedText(
          'Things on wheels',
          textStyle:  TextStyle(
              fontSize: screenWidth/8,
              fontWeight: FontWeight.bold,
              fontFamily: 'WinterSong'
          ),
          speed: const Duration(milliseconds: 80),
        ),
      ],
      totalRepeatCount: 10,
      pause: const Duration(milliseconds: 1000),
      displayFullTextOnTap: true,
      stopPauseOnTap: true,
    );
  }

}