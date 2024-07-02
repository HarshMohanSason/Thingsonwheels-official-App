
import 'dart:io';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:thingsonwheels/main.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'package:fluttertoast/fluttertoast.dart';

class AboutUs extends StatelessWidget {

  const AboutUs({super.key});

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: Platform.isIOS ? false: true,
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(screenHeight / 13.5), // Adjust the height as needed
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.orange[300]!, Colors.orange[700]!],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: AppBar(
              backgroundColor: Colors.transparent, // Make AppBar transparent
              title: Platform.isAndroid ? Padding(
                padding: const EdgeInsets.only(right: 40),
                child: Center(
                  child: Text(
                    "About Us".tr(),
                    style: TextStyle(
                      color: Colors.white, // Ensure text is readable on gradient background
                      fontWeight: FontWeight.bold,
                      fontSize: screenHeight/31,
                    ),
                  ),
                ),
              ) : Text(
                "About Us".tr(),
                style: TextStyle(
                  color: Colors.white, // Ensure text is readable on gradient background
                  fontWeight: FontWeight.bold,
                  fontSize: screenHeight/31,
                ),
              ),
              leading: InkWell(
                child: Icon(Icons.arrow_back, size: screenWidth / 14, color: Colors.white), // Ensure icon is readable
                onTap: () {
                  Navigator.pop(context);
                },
              ),
              elevation: 0, // Remove shadow
            ),
          ),
        ),
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Welcome to Things On Wheels'.tr(),
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: screenWidth / 20,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text('About Us Text'.tr(),
                    style: TextStyle(
                      fontSize: screenWidth / 30,
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    "Developers".tr(),
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: screenWidth / 25,
                    ),
                  ),
                  const SizedBox(height: 10),
                  _buildDeveloperLink(
                    context,
                    name: "Satyam's LinkedIn".tr(),
                    url: "https://www.linkedin.com/in/satyam-sm",
                  ),
                  const SizedBox(height: 10),
                  _buildDeveloperLink(
                    context,
                    name: "Harsh's LinkedIn".tr(),
                    url: "https://www.linkedin.com/in/harsh-mohan-sason-50a72119b/",
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDeveloperLink(BuildContext context, {required String name, required String url}) {
    return InkWell(
      onTap: () async {
        if (await canLaunchUrlString(url)) {
          await launchUrlString(url);
        } else {
          Fluttertoast.showToast(
            msg: 'Could not launch the link'.tr(),
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: screenWidth / 25,
          );
        }
      },
      child: Row(
        children: [
          Icon(
            Icons.link,
            color: Colors.lightBlue,
            size: MediaQuery.of(context).size.width / 20,
          ),
          const SizedBox(width: 8),
          Text(
            name,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: MediaQuery.of(context).size.width / 30,
              color: Colors.lightBlue,
            ),
          ),
        ],
      ),
    );
  }
}
