
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/cupertino.dart';

class TOWLogoAnimation extends StatefulWidget
{
  final double fontSize;
  const TOWLogoAnimation({super.key, required this.fontSize});

  @override
  TOWLogoAnimationState createState()=> TOWLogoAnimationState();
}

class  TOWLogoAnimationState extends State<TOWLogoAnimation>
{
  @override
  Widget build(BuildContext context) {
    return  AnimatedTextKit(
      animatedTexts: [
        TypewriterAnimatedText('Thingsonwheels',
          textStyle:  TextStyle(
              fontSize: widget.fontSize,
              fontWeight: FontWeight.bold,
              fontFamily: 'WinterSong'
          ),
          speed: const Duration(milliseconds: 80),
        ),
      ],
      totalRepeatCount: 10000,
      pause: const Duration(milliseconds: 1000),
      displayFullTextOnTap: true,
      stopPauseOnTap: true,
    );
  }

}