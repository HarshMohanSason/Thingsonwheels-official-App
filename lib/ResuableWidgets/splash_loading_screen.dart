
import 'package:flutter/material.dart';

class SplashLoadingScreen extends StatelessWidget{
  const SplashLoadingScreen({super.key});

  @override
  Widget build(BuildContext context) {

      return Scaffold(

        body:
            Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.orange[300]!, Colors.orange[700]!],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: Center(child: Image.asset('assets/images/launch_screen.png',
                fit: BoxFit.contain,))),
      );
  }


}