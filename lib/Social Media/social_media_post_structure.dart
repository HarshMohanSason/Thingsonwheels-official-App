import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:thingsonwheels/Reusable%20Widgets/toast_widget.dart';
import 'package:uuid/uuid.dart';

class Comment {
  final String? profileImage;
  final String userName;
  final String comment;
  final String uid;

  Comment({
    this.profileImage,
    required this.userName,
    required this.comment,
    required this.uid,
  });

  // Factory constructor to create a Comments object from dynamic data
  factory Comment._fromMap(Map<String, dynamic> data) {
    return Comment(
      profileImage: data['ProfileImage'] as String?,
      userName: data['UserName'] as String,
      comment: data['Comment'] as String,
      uid: data['uid'] as String,
    );
  }

  static List<Comment?> toComment(List<dynamic> commentList) {
    return commentList.map((comment) {
      if (comment is Map<String, dynamic>) {
        return Comment._fromMap(comment);
      } else {
        return null; // Handle invalid comment structures gracefully
      }
    }).toList();
  }
}

class SocialMediaPostStructure {
  String postID;
  final String userName;
  String? userProfileImage;
  final String postImage;
  final int likes;
  String? caption;
  final Timestamp timestamp;
  final List<Comment?> comments;
  final String uid;
  final String? location;

  SocialMediaPostStructure({
    this.location,
    required this.postImage,
    this.caption,
    required this.userName,
    required this.likes,
    required this.comments,
    String? userProfileImage,
    String? uid,
    String? postID,
    Timestamp? timestamp,
  })  : postID = const Uuid().v4(),
        uid = FirebaseAuth.instance.currentUser!.uid,
        userProfileImage = FirebaseAuth.instance.currentUser!.photoURL!,
        timestamp = Timestamp.now();

  static Future<List<SocialMediaPostStructure>> getPosts(
      {String? location}) async {
    List<SocialMediaPostStructure> posts = [];
    try {
      var snapshot =
          await FirebaseFirestore.instance.collection('socialMediaPosts').get();

      for (var doc in snapshot.docs) {
        SocialMediaPostStructure post = toSocialMediaStructureObj(doc);
        posts.add(post);
      }
    } on SocketException {
      showToast('Network error occurred, please try again', Colors.red,
          Colors.white, "SHORT");
    } catch (e) {
      print(e);
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
      'Comments': comments,
      'Location': location,
      'uid': FirebaseAuth.instance.currentUser!.uid
    };
  }

  static SocialMediaPostStructure toSocialMediaStructureObj(
      QueryDocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data();
    return SocialMediaPostStructure(
        uid: data['uid'],
        postID: data['PostID'],
        userName: data['UserName'],
        userProfileImage: data['UserProfileImage'],
        postImage: data['PostImage'],
        likes: data['Likes'],
        caption: data['Caption'],
        timestamp: data['TimeStamp'],
        location: data['Location'],
        comments: Comment.toComment(
            doc['Comments']) // Safely handle potential null values
        );
  }

  static String formatTimestamp(Timestamp timestamp) {
    DateTime dateTime = timestamp.toDate();
    return DateFormat('hh:mm a').format(dateTime);
  }

  static String formatWithCount(int count, String noun) {
    // Handle singular/plural logic
    String suffix = count < 2 ? noun : '${noun}s';

    // Format the number based on its size
    if (count < 1000) {
      return '$count $suffix';
    } else if (count < 10000) {
      return '${(count / 1000).toStringAsFixed(1)}k $suffix';
    } else if (count < 1000000) {
      return '${(count / 1000).toStringAsFixed(0)}k $suffix';
    } else {
      return '${(count / 1000000).toStringAsFixed(1)}M $suffix';
    }
  }

  static String formatDate(Timestamp timestamp) {
    DateTime date = timestamp.toDate();
    String formattedDate = DateFormat('d MMM, yyyy').format(date);
    return formattedDate;
  }
}
