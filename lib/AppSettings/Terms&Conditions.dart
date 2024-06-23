
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:thingsonwheels/main.dart';

class TermsAndConditions extends StatelessWidget
{
  const TermsAndConditions({super.key});

  @override
  Widget build(BuildContext context) {

    return PopScope(
      canPop: false,
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
              title: Center(
                child: Text(
                  "Terms and Conditions",
                  style: TextStyle(
                    color: Colors.white, // Ensure text is readable on gradient background
                    fontWeight: FontWeight.bold,
                    fontSize: screenWidth / 18,
                  ),
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
        body: SafeArea(
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              children: [
                Expanded(
                  child: ListView(
                    scrollDirection: Axis.vertical,
                    shrinkWrap:true,
                    children: [
                      const SizedBox(height: 20),
                      _buildHeading('Acceptance of Terms'),
                      _buildParagraph('By downloading, installing, or using Thingsonwheels, you agree to be bound by these Terms and Conditions.'),
                      _buildHeading('License'),
                      _buildParagraph('We grant you a limited, non-exclusive, non-transferable license to use Thingsonwheels for personal, non-commercial purposes.'),
                      _buildHeading('User Accounts'),
                      _buildParagraph('You may be required to create an account to access certain features of the app.'),
                      _buildParagraph('You are responsible for maintaining the confidentiality of your account credentials and for any activities that occur under your account.'),
                      _buildHeading('User Conduct'),
                      _buildParagraph('You agree not to use Thingsonwheels for any unlawful or prohibited purpose.'),
                      _buildParagraph('You agree not to interfere with the operation of the app or to engage in any activity that disrupts or harms our services.'),
                      _buildHeading('Intellectual Property'),
                      _buildParagraph('Thingsonwheels and its content are protected by copyright and other intellectual property laws.'),
                      _buildParagraph('You may not modify, reproduce, distribute, or create derivative works based on our app without our prior written consent.'),
                      _buildHeading('Limitation of Liability'),
                      _buildParagraph('We shall not be liable for any direct, indirect, incidental, special, or consequential damages arising out of or relating to your use of Thingsonwheels.'),
                      _buildParagraph('Our total liability for any claims arising from or related to the app shall not exceed the amount you paid, if any, for accessing the app.'),
                      _buildHeading('Governing Law'),
                      _buildParagraph('These Terms and Conditions shall be governed by and construed in accordance with the laws of the United States..'),
                      _buildHeading('Changes to Terms'),
                      _buildParagraph('We reserve the right to modify or replace these Terms and Conditions at any time. Your continued use of Thingsonwheels after any such changes constitutes acceptance of the new Terms and Conditions.'),
                      _buildHeading('Contact Us'),
                      _buildParagraph('If you have any questions or concerns about these Terms and Conditions, please contact us at oggpoggp19962000@gmail.com.'),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }


  Widget _buildHeading(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Text(
        text,
        style:  TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: screenWidth/22,
        ),
      ),
    );
  }

  Widget _buildParagraph(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Text(
        text,
        textAlign: TextAlign.justify,
        style:  TextStyle(
          fontSize: screenWidth/30,
        ),
      ),
    );
  }
}
