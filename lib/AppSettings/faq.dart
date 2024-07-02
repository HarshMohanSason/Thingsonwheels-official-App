import 'dart:io';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:thingsonwheels/UserLogin/PhoneLogin/phone_login_service.dart';
import 'package:thingsonwheels/main.dart';
import '../MerchantsOnTow/merchant_service.dart';
import '../UserLogin/AppleLogin/apple_login_service.dart';
import '../UserLogin/GoogleLogin/google_login_service.dart';
import '../UserLogin/intro_login_screen.dart';

class PrivacyPolicy extends StatelessWidget {
  const PrivacyPolicy({super.key});

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: Platform.isIOS ? false: true,
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(screenHeight / 13.5),
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.orange[300]!, Colors.orange[700]!],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: AppBar(
              backgroundColor: Colors.transparent,
              title: Platform.isAndroid ? Padding(
                padding: const EdgeInsets.only(right: 40),
                child: Center(
                  child: Text(
                    "FAQ",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: screenHeight/31,
                    ),
                  ),
                ),
              ): Text(
                "FAQ",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: screenHeight / 31,
                ),
              ),
              leading: InkWell(
                child: Icon(Icons.arrow_back,
                    size: screenWidth / 14,
                    color: Colors.white),
                onTap: () {
                  Navigator.pop(context);
                },
              ),
              elevation: 0,
            ),
          ),
        ),
        backgroundColor: Colors.white,
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Expanded(
                  child: ListView(
                    shrinkWrap: true,
                    children: [
                      const SizedBox(height: 20),
                      _buildH1Heading('faq_title'.tr()),
                      _buildH2Heading('faq_thingsonwheels'.tr()),
                      _buildBulletPoint('faq_thingsonwheels_desc'.tr()),
                      _buildH2Heading('faq_location'.tr()),
                      _buildBulletPoint('faq_location_desc'.tr()),
                      _buildH2Heading('faq_delete_account'.tr()),
                      _buildRichTextWithLink(context),
                      _buildH2Heading('faq_privacy_policy'.tr()),
                      _buildRichTextWithUrl(context, 'faq_privacy_policy_desc'.tr(), 'https://thingsonwheels-751ca.web.app/'),
                      _buildH2Heading('faq_merchant_name'.tr()),
                      _buildBulletPoint('faq_merchant_name_desc'.tr()),
                      _buildH2Heading('faq_menus'.tr()),
                      _buildBulletPoint('faq_menus_desc'.tr()),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildH1Heading(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0),
      child: Text(
        text,
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: screenWidth / 18,
        ),
      ),
    );
  }

  Widget _buildH2Heading(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: Text(
        text,
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: screenWidth / 22,
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
            padding: EdgeInsets.only(top: 6.0),
            child: Icon(Icons.brightness_1, size: 8.0),
          ),
          const SizedBox(width: 8.0),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                fontSize: screenWidth / 30,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRichTextWithLink(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: RichText(
        text: TextSpan(
          text: 'faq_delete_account_desc.'.tr(),
          style: TextStyle(
            fontSize: screenWidth / 30,
            color: Colors.black,
          ),
          children: <TextSpan>[
            TextSpan(
              text: 'faq_delete_account_link'.tr(),
              style: TextStyle(
                color: Colors.lightBlue,
                fontSize: screenWidth / 30,
                decoration: TextDecoration.underline,
              ),
              recognizer: TapGestureRecognizer()
                ..onTap = () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return deleteAccountPopup(context);
                    },
                  );
                },
            ),
             TextSpan(
              text:
              '\n${'faq_delete_account_note'.tr()}',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRichTextWithUrl(BuildContext context, String text, String url) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: RichText(
        text: TextSpan(
          text: text,
          style: TextStyle(
            fontSize: screenWidth / 30,
            color: Colors.black,
          ),
          children: <TextSpan>[
            TextSpan(
              text: url,
              style: TextStyle(
                color: Colors.lightBlue,
                fontSize: screenWidth / 30,
                decoration: TextDecoration.underline,
              ),
              recognizer: TapGestureRecognizer()
                ..onTap = () async {
                  final uri = Uri.parse(url);
                  if (await canLaunchUrl(uri)) {
                    await launchUrl(uri);
                  } else {
                    throw 'Could not launch $url';
                  }
                },
            ),
          ],
        ),
      ),
    );
  }

  Widget deleteAccountPopup(BuildContext context) {
    final sp = context.read<GoogleSignInProvider>();
    final ap = context.read<AppleLoginService>();
    final merchantProvider = context.read<MerchantsOnTOWService>();
    final phoneProvider = context.read<PhoneLoginService>();

    return AlertDialog(
      elevation: 5,
      shadowColor: Colors.black,
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      content: SafeArea(
        child: SizedBox(
          height: screenHeight / 3.5,
          child: Column(
            children: [
              Icon(Icons.error_outline, color: Colors.red, size: screenWidth / 5.5),
              Padding(
                padding: EdgeInsets.only(top: screenWidth / 27),
                child: Text(
                  'do_you_really_want_to_delete_your_account'.tr(),
                  style: TextStyle(fontSize: screenHeight / 68),
                ),
              ),
              const Spacer(),
              Padding(
                padding: EdgeInsets.only(bottom: screenWidth / 17),
                child: Row(
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      style: ButtonStyle(
                        shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                            side: const BorderSide(
                              color: Colors.red,
                              width: 1.0,
                            ),
                          ),
                        ),
                        backgroundColor: WidgetStateProperty.all<Color>(Colors.white),
                        fixedSize: WidgetStateProperty.all<Size>(
                          Size(screenWidth / 3.5, screenWidth / 43.2),
                        ),
                      ),
                      child:  Text(
                        'Cancel'.tr(),
                        style: const TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                    ),
                    const Spacer(),
                    ElevatedButton(
                      onPressed: () async {
                        try {
                          if (sp.isSignedIn != null && sp.isSignedIn!) {
                            await sp.deleteGoogleRelatedAccount();
                          } else if (ap.isSignedIn != null && ap.isSignedIn!) {
                            await ap.deleteAppleRelatedAccount();
                          } else {
                            await phoneProvider.deletePhoneRelatedAccount();
                            merchantProvider.deleteMerchantDocument();
                          }
                          if (context.mounted) {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const IntroLoginScreenUI(),
                              ),
                            );
                          }
                        } catch (e) {
                          Fluttertoast.showToast(
                            msg: 'Error occurred, please try again'.tr(),
                            toastLength: Toast.LENGTH_SHORT,
                            gravity: ToastGravity.CENTER,
                            backgroundColor: Colors.red,
                            textColor: Colors.white,
                          );
                        }
                      },
                      style: ButtonStyle(
                        shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                        ),
                        backgroundColor: WidgetStateProperty.all(Colors.red),
                        fixedSize: WidgetStateProperty.all(
                          Size(screenWidth / 3.5, screenWidth / 43.2),
                        ),
                      ),
                      child:  Text(
                        'delete'.tr(),
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
