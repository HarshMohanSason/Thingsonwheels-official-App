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
              CachedNetworkImage(
                imageUrl: socialMediaStructure.postImage,
                fit: BoxFit.cover,
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
                      InkWell(
                        onTap: () {
                          _showCommentSheet(context, socialMediaStructure);
                        },
                        child: Image.asset(
                          'assets/images/ChatCircle.png',
                          scale: 0.8,
                        ),
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
                                  SocialMediaPostStructure.formatWithCount(
                                      socialMediaStructure.likes, 'like'),
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
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    socialMediaStructure.caption!.length > 15
                        ? '${socialMediaStructure.caption!.substring(0, 15)}...'
                        : socialMediaStructure.caption!,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: screenWidth / 30,
                      color: const Color(0xFFAFAFAF),
                    ),
                  ),
                  Text(
                    SocialMediaPostStructure.formatDate(
                        socialMediaStructure.timestamp),
                    style: TextStyle(
                        fontSize: screenWidth / 35,
                        color: const Color(0xFFAFAFAF)),
                  ),
                ],
              ),
              Text(
                  SocialMediaPostStructure.formatWithCount(
                      socialMediaStructure.comments.length, 'comment'),
                  style: TextStyle(
                      fontSize: screenWidth / 35,
                      color: const Color(0xFFAFAFAF))),
            ],
          ),
        )
      ],
    );
  }

  void _showCommentSheet(
      BuildContext context, SocialMediaPostStructure socialMediaPostStructure) {
    showModalBottomSheet(
      backgroundColor: Colors.white,
      context: context,
      isScrollControlled: true,
      // Allows better control over height
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(30), // Rounded top corners
        ),
      ),
      builder: (BuildContext context) {
        return Container(
          height: screenHeight / 1.3, // Set height to half the screen
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              // Handle for drag-down gesture
              Container(
                width: screenWidth / 5,
                height: 5,
                decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              const SizedBox(height: 10),
              // Display comments
              Expanded(
                child: ListView.builder(
                  itemCount: socialMediaPostStructure.comments.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      leading: CircleAvatar(
                        foregroundImage: socialMediaPostStructure
                                    .comments[index]!.profileImage !=
                                null
                            ? CachedNetworkImageProvider(
                                socialMediaPostStructure
                                    .comments[index]!.profileImage!)
                            : null,
                        child: socialMediaPostStructure
                                    .comments[index]!.profileImage ==
                                null
                            ? const Icon(Icons.person)
                            : null,
                      ),
                      title: Text(
                        socialMediaPostStructure.comments[index]!.userName,
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: screenWidth / 25,
                            fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text(
                        socialMediaPostStructure.comments[index]!.comment,
                        style: TextStyle(
                            fontSize: screenWidth / 30,
                            color: const Color(0xFF505050)),
                      ),
                    );
                  },
                ),
              ),

              // TextField for input
              Padding(
                padding: const EdgeInsets.only(bottom: 20.0),
                child: TextFormField(
                  maxLines: 2,
                  decoration: InputDecoration(
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5),
                      borderSide: BorderSide(
                        color: Colors.grey.withOpacity(
                            0.2), // Change the border color to your preference
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5),
                      borderSide: BorderSide(
                        color: Colors.grey.withOpacity(0.2),
                        // Change the focused border color to your preference
                        width: 2,
                      ),
                    ),
                    errorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5),
                      borderSide: const BorderSide(
                        color: Colors.red,
                        // Change the error border color to your preference
                        width: 2,
                      ),
                    ),
                    focusedErrorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5),
                      borderSide: const BorderSide(
                        color: Colors.red,
                        // Change the focused error border color to your preference
                        width: 2,
                      ),
                    ),
                    suffixIcon: GestureDetector(
                        onTap: () {
                          //print("Yo");
                        },
                        child: const Icon(Icons.send, color: Colors.black,)),
                    hintText: 'Write a comment...',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
