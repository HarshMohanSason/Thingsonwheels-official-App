
import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:thingsonwheels/main.dart';

class TermsAndConditions extends StatelessWidget
{
  const TermsAndConditions({super.key});

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
                    "termsandconditions".tr(),
                    style: TextStyle(
                      color: Colors.white, // Ensure text is readable on gradient background
                      fontWeight: FontWeight.bold,
                      fontSize: screenHeight/31,
                    ),
                  ),
                ),
              ): Text(
                "termsandconditions".tr(),
                style: TextStyle(
                  color: Colors.white, // Ensure text is readable on gradient background
                  fontWeight: FontWeight.bold,
                  fontSize: screenHeight / 31,
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
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Expanded(
                  child: ListView(
                    scrollDirection: Axis.vertical,
                    shrinkWrap:true,
                    children: [
                      const SizedBox(height: 20),
                      _buildHeading('acceptance_of_terms'.tr()),
                      _buildParagraph('acceptance_text'.tr()),
                      _buildHeading('license'.tr()),
                      _buildParagraph('license_text'.tr()),
                      _buildHeading('user_accounts'.tr()),
                      _buildParagraph('user_accounts_text1'.tr()),
                      _buildParagraph('user_accounts_text2'.tr()),
                      _buildHeading('user_conduct'.tr()),
                      _buildParagraph('user_conduct_text1'.tr()),
                      _buildParagraph('user_conduct_text2'.tr()),
                      _buildHeading('intellectual_property'.tr()),
                      _buildParagraph('intellectual_property_text1'.tr()),
                      _buildParagraph('intellectual_property_text2'.tr()),
                      _buildHeading('limitation_of_liability'.tr()),
                      _buildParagraph('limitation_of_liability_text1'.tr()),
                      _buildParagraph('limitation_of_liability_text2'.tr()),
                      _buildHeading('governing_law'.tr()),
                      _buildParagraph('governing_law_text'.tr()),
                      _buildHeading('changes_to_terms'.tr()),
                      _buildParagraph('changes_to_terms_text'.tr()),
                      _buildHeading('contact_us'.tr()),
                      _buildParagraph('contact_us_text'.tr()),
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
