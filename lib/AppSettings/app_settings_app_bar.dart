import 'package:flutter/material.dart';
import '../main.dart';

class AppSettingsAppBar extends StatelessWidget {

  const AppSettingsAppBar({super.key,});

  @override
  Widget build(BuildContext context) {
    return AppBar(
        automaticallyImplyLeading: false, // Hide default back arrow
        backgroundColor: Colors.red, // AppBar background color
        elevation: 0, // Remove shadow
        flexibleSpace: SafeArea(
          child: Padding(
            padding: EdgeInsets.only(top: screenWidth / 14),
            child: Center(
              child: Text(
                "Business Profile",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: screenWidth / 17,
                ),
              ),
            ),
          ),
        ));
  }
}
