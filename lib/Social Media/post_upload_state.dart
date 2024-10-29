import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:thingsonwheels/Social%20Media/social_media_post_structure.dart';
import '../Reusable Widgets/toast_widget.dart';

enum PostUploadStateEnum {
  loading,
  idle,
  error,
  success,
}

class PostUploadState extends ChangeNotifier {
  PostUploadStateEnum _uploadState = PostUploadStateEnum.idle;

  PostUploadStateEnum get uploadState => _uploadState;

  set uploadState(PostUploadStateEnum state) {
    _uploadState = state;
    notifyListeners();
  }

  Future uploadPost(SocialMediaPostStructure post) async {
    _uploadState = PostUploadStateEnum.loading;
    notifyListeners();
    try {
      await FirebaseFirestore.instance
          .collection('socialMediaPosts')
          .doc()
          .set(post.toMap());
      _uploadState = PostUploadStateEnum.success;
      notifyListeners();
    } on SocketException {
      showToast('Network error occurred, please try again', Colors.red,
          Colors.white, "SHORT");
      _uploadState = PostUploadStateEnum.error;
      notifyListeners();
    } catch (e) {
      showToast('An error occurred, please try again ', Colors.red,
          Colors.white, "SHORT");
      _uploadState = PostUploadStateEnum.error;
      notifyListeners();
    }
  }

  Future<String> getImageUrlFromFirebaseStorage(String image) async {
    try {
      if (!image.contains('https')) {
        File imageFile = File(image); // Get the image path
        String imageName =
            basename(imageFile.path); // Get the basename from the path

        Reference storageReference = FirebaseStorage.instance
            .ref()
            .child('MerchantProfileImages/$imageName');

        // Upload the image file
        await storageReference.putFile(imageFile);

        // Get the download URL
        String imageUrl = await storageReference.getDownloadURL();

        return imageUrl;
      } else {
        // If it's already a URL, return it directly
        return image;
      }
    } on SocketException {
      showToast(
          'Check your Internet Connection', Colors.red, Colors.white, 'SHORT');
      _uploadState = PostUploadStateEnum.error;
      notifyListeners();
      return ""; // Return empty string on error
    } catch (e) {
      showToast('An error occurred, please try again', Colors.red, Colors.white,
          'SHORT');
      _uploadState = PostUploadStateEnum.error;
      notifyListeners();
      return ""; // Return empty string on error
    }
  }
}
