import 'dart:ui';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:icons_flutter/icons_flutter.dart';
import 'package:thingsonwheels/Social%20Media/social_media_post_structure.dart';
import 'package:thingsonwheels/main.dart';

class SocialMediaPostTileUi extends StatelessWidget {
  final SocialMediaPostStructure socialMediaStructure;

  const SocialMediaPostTileUi({super.key, required this.socialMediaStructure});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            CircleAvatar(
              foregroundImage: socialMediaStructure.userProfileImage != null
                  ? CachedNetworkImageProvider(
                      socialMediaStructure.userProfileImage!)
                  : null,
              child: socialMediaStructure.userProfileImage == null
                  ? const Icon(Icons.person)
                  : null,
            ),
            const SizedBox(
              width: 10,
            ),
            Text(
              socialMediaStructure.userName,
              style: TextStyle(
                  fontSize: screenWidth / 30, fontWeight: FontWeight.bold),
            ),
          ],
        ),
        const SizedBox(
          height: 10,
        ),
        ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: Stack(
            children: [
              Container(
                color: Colors.grey.shade500,
                height: screenHeight / 3,
                width: screenWidth - 40,
                child: CachedNetworkImage(
                  imageUrl: socialMediaStructure.postImage,
                  fit: BoxFit.cover,
                ),
              ),
              Positioned(
                bottom: 15, // Adjusted to bring it up slightly from the bottom
                left: 10, // Adjusted to add padding from the left
                child: SizedBox(
                  width: screenWidth - 60,
                  child: Row(
                    children: [
                      const SizedBox(width: 5),
                      Icon(FontAwesome.heart,
                          size: screenWidth / 18, color: Colors.red),
                      const SizedBox(width: 15), // Add space between icons
                      Image.asset(
                        'assets/images/ChatCircle.png',
                        scale: 0.8,
                      ),
                      const Spacer(),
                      ClipRect(
                        child: BackdropFilter(
                          filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
                          child: Container(
                            padding: const EdgeInsets.only(
                                right: 10, left: 10, top: 8, bottom: 8),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.5),
                              // Background color with transparency
                              borderRadius: BorderRadius.circular(12),
                              // Rounded corners
                              border: Border.all(
                                  color: Colors.grey.shade400,
                                  width: 1), // Optional border
                            ),
                            child: Row(
                              children: [
                                Text(
                                  SocialMediaPostStructure.formatLikesAndComments(
                                      socialMediaStructure.likes),
                                  // Display number of likes with heart emoji
                                  style: const TextStyle(
                                    fontSize: 14, // Font size
                                    fontFamily: 'Poppins',
                                    fontWeight: FontWeight.bold, // Bold text
                                    color: Colors.white, // Text color
                                  ),
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                                Icon(FontAwesome.heart,
                                    size: screenWidth / 25, color: Colors.red),
                              ],
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(
          height: 5,
        ),
        Padding(
          padding: const EdgeInsets.only(left: 20.0, right: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                SocialMediaPostStructure.formatDate(socialMediaStructure.timestamp),
                style: TextStyle(
                    fontSize: screenWidth / 35, color: const Color(0xFFAFAFAF)),
              ),
              Text(
                socialMediaStructure.comments.length < 2
                    ? '1 comment'
                    : '${SocialMediaPostStructure.formatLikesAndComments(socialMediaStructure.comments.length)} comments',
                style: TextStyle(
                    fontSize: screenWidth / 35, color: const Color(0xFFAFAFAF)),
              ),
            ],
          ),
        )
      ],
    );
  }
}
