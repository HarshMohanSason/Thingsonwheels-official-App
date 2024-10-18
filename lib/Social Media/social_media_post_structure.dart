import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:thingsonwheels/Reusable%20Widgets/toast_widget.dart';
import 'package:uuid/uuid.dart';

class SocialMediaPostStructure {
  String postID;
  final String userName;
  String? userProfileImage;
  final String postImage;
  final int likes;
  String? caption;
  final Timestamp timestamp;
  final List<String?> comments;

  SocialMediaPostStructure({
    required this.postImage,
    this.caption,
    required this.userName,
    this.userProfileImage,
    required this.likes,
    required this.comments,
    String? postID,
    Timestamp? timestamp,
  })  : postID = const Uuid().v4(),
        timestamp = Timestamp.now();

  static Future<List<SocialMediaPostStructure>> getPosts(
      {String? location}) async {
    List<SocialMediaPostStructure> posts = [];
    try {
      var usersSnapshot =
          await FirebaseFirestore.instance.collection('userInfo').get();

      for (var userDoc in usersSnapshot.docs) {
        var postsSnapshot =
            await userDoc.reference.collection('socialMediaPosts').get();
        for (var postDoc in postsSnapshot.docs) {
          SocialMediaPostStructure obj = toSocialMediaStructureObj(postDoc);
          posts.add(obj);
        }
      }
    } on SocketException {
      showToast('Network error occurred, please try again', Colors.red,
          Colors.white, "SHORT");
    } catch (e) {
      showToast(
          'An error occurred fetching the social media posts, please try again ',
          Colors.red,
          Colors.white,
          "SHORT");
    }
    return posts;
  }

  toMap() {
    return {
      'PostID': postID,
      'UserName': userName,
      'ProfileImage': userProfileImage,
      'PostImage': postImage,
      'likes': likes,
      'Caption': caption,
      'TimeStamp': timestamp,
      'Comments': comments
    };
  }

  static SocialMediaPostStructure toSocialMediaStructureObj(
      QueryDocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data();
    return SocialMediaPostStructure(
      postID: data['PostID'],
      userName: data['UserName'],
      userProfileImage: data['UserProfileImage'],
      postImage: data['PostImage'],
      likes: data['Likes'],
      caption: data['Caption'],
      timestamp: data['TimeStamp'],
      comments: List<String?>.from(
          data['Comments'] ?? []), // Safely handle potential null values
    );
  }

  static String formatTimestamp(Timestamp timestamp) {
    DateTime dateTime = timestamp.toDate();
    return DateFormat('hh:mm a').format(dateTime);
  }

  static String formatLikesAndComments(int likes) {
    if (likes < 1000) {
      return '$likes';
    } else if (likes < 10000) {
      // Divide by 1000 and keep one decimal point (e.g., 4003 -> 4.0k)
      return '${(likes / 1000).toStringAsFixed(1)}k';
    } else if (likes < 1000000) {
      // For numbers >= 10k but < 1M (e.g., 23000 -> 23k)
      return '${(likes / 1000).toStringAsFixed(0)}k';
    } else {
      // For numbers >= 1M (e.g., 1500000 -> 1.5M)
      return '${(likes / 1000000).toStringAsFixed(1)}M';
    }
  }

  static String formatDate(Timestamp timestamp) {
    DateTime date = timestamp.toDate();
    String formattedDate = DateFormat('d MMM, yyyy').format(date);
    return formattedDate;
  }
}
