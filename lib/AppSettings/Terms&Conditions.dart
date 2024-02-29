




import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:thingsonwheels/main.dart';

class TermsAndConditions extends StatelessWidget
{
  const TermsAndConditions({super.key});

  @override
  Widget build(BuildContext context) {



    return Scaffold(

      appBar: AppBar(
        leading: Padding(
          padding: EdgeInsets.only(right: 22),
          child: InkWell(
            child: Icon(Icons.arrow_back, size: screenWidth/14,),
            onTap: ()
            {
              Navigator.pop(context);
            },
          ),
        ),
        backgroundColor: colorTheme,),
      backgroundColor: colorTheme,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.only(top: 20),
          child: Column(
            children: [
              Text(
                "Hello",
                style: TextStyle(
                  fontSize: 18,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

}