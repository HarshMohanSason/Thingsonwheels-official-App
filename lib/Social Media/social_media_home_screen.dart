import 'package:flutter/material.dart';
import 'package:thingsonwheels/Social%20Media/display_social_media_posts.dart';
import 'package:thingsonwheels/Social%20Media/social_media_post_upload_overlay.dart';
import 'package:thingsonwheels/main.dart';

class SocialMediaHomeScreen extends StatefulWidget {
  const SocialMediaHomeScreen({super.key});

  @override
  SocialMediaHomeScreenState createState() => SocialMediaHomeScreenState();
}

class SocialMediaHomeScreenState extends State<SocialMediaHomeScreen> {
  bool _showOverLay = false;

  void _openOverlay() {
    setState(() {
      _showOverLay = true; // Show the overlay
    });
  }

  void _closeOverlay() {
    setState(() {
      _showOverLay = false; // Hide the overlay
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        const DisplaySocialMediaPosts(),
        Positioned(bottom: 20, right: 20, child: uploadImage(context)),
      ],
    );
  }

  Widget uploadImage(BuildContext context) {
    return GestureDetector(
        onTap: () {
          setState(() {
            _openOverlay();
            Navigator.of(context).push(SocialMediaPostUploadOverlay(closeOverlay: _closeOverlay));
          });
        },
        child: !_showOverLay ? CircleAvatar(
                backgroundColor: Colors.red,
                radius: screenWidth / 13,
                child: Icon(Icons.add,
                    color: Colors.white, size: screenWidth / 10),
              ) : Container()
           );
  }
}
