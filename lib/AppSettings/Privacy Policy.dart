


import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:thingsonwheels/main.dart';

class PrivacyPolicy extends StatelessWidget
{
  const PrivacyPolicy({super.key});

  @override
  Widget build(BuildContext context) {


    return PopScope(
      canPop: false,
      child: Scaffold(

        appBar: AppBar(
          title: Text("Privacy Policy",  style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: screenWidth/16,
          )),
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
        backgroundColor: Colors.white,
        body: SafeArea(
          child: Column(
            children: [
                Expanded(
                  child: ListView(
                    shrinkWrap: true,
                    children: [
                      const SizedBox(height: 20),
                      const Padding(
                          padding: EdgeInsets.only(left: 6),
                         child: Text("Thingsonwheels is committed to protecting the privacy of its users. This Privacy Policy describes how Thingsonwheels collects, uses, and shares personal information when you use our mobile application.")),
                      _buildHeading('Information We Collect'),
                      _buildBulletPoint('Personal Information: We may collect personal information such as your name, email address, and other contact details when you register an account with Thingsonwheels.'),
                      _buildBulletPoint('Usage Information: We do not collect information about how you interact with our app, including your device information, IP address, and usage patterns.'),
                      _buildBulletPoint('Location Information: For now we do not use or ask for you location as the app is still in beta version. We might need it when the app grows as we get more locations'),
                      _buildHeading('How We Use Your Information'),
                      _buildBulletPoint('We use the information we collect to provide and improve our services, personalize your experience, and communicate with you about our app and updates.'),
                      _buildBulletPoint('We may also use your information to analyze usage trends and optimize our app\'s performance.'),
                      _buildHeading('Data Sharing and Disclosure'),
                      _buildBulletPoint('We may share your personal information with third-party service providers who assist us in operating our app, conducting business, or servicing you.'),
                      _buildBulletPoint('We may also disclose your information in response to legal requests or to protect our rights, property, or safety.'),
                      _buildHeading('Data Security'),
                      _buildBulletPoint('We take reasonable measures to protect your personal information from unauthorized access, disclosure, alteration, or destruction.'),
                      _buildBulletPoint('However, please be aware that no method of transmission over the internet or electronic storage is 100% secure, and we cannot guarantee absolute security.'),
                      _buildHeading('Changes to This Privacy Policy'),
                      _buildBulletPoint('We may update our Privacy Policy from time to time. We will notify you of any changes by posting the new Privacy Policy on this page.'),
                      _buildBulletPoint('You are advised to review this Privacy Policy periodically for any changes.'),
                      _buildHeading('Contact Us'),
                      _buildBulletPoint('If you have any questions or concerns about our Privacy Policy, please contact us at oggpoggp19962000@gmail.com.'),
                    ],
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  //Widget to build the heading
  Widget _buildHeading(String text) {

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Text(
        text,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 18.0,
        ),
      ),
    );
  }

  Widget _buildBulletPoint(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.only(top: 5),
              child: Icon(Icons.brightness_1, size: 8.0)),
          const SizedBox(width: 8.0),
          Expanded(
            child: Text(
              text,
              textAlign: TextAlign.justify,
            ),
          ),
        ],
      ),
    );
  }
}

