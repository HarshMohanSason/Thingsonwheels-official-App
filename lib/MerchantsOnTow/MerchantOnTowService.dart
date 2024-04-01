
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:path/path.dart';

// Provider class to handle state of MerchantOnTOWBoarding form.

class MerchantsOnTOWService extends ChangeNotifier {

  List<String?> _businessImages = List<String?>.generate(4, (_) => null);
  List<String?> get businessImages => _businessImages;

  String _merchantName = "";
  String get merchantName => _merchantName;

  void setMerchantName(String name) {
    _merchantName = name;
    notifyListeners();
  }

  String _merchantBusinessAddress = "";
  String get merchantBusinessAddress => _merchantBusinessAddress;

  void setMerchantAddress(String address) {
    _merchantBusinessAddress = address;
    notifyListeners();
  }

  String _merchantMobileNum = "";
  String get merchantMobileNum => _merchantMobileNum;

  void setMerchantMobileNum(String num) {
    _merchantMobileNum = num;
    notifyListeners();
  }

  String _merchantEmail = "";
  String get merchantEmail => _merchantEmail;

  void setMerchantEmail(String email) {
    _merchantEmail = email;
    notifyListeners();
  }

  String _merchantBusinessName = "";
  String get merchantBusinessName => _merchantBusinessName;

  void setMerchantBusinessName(String businessName) {
    _merchantBusinessName = businessName;
    notifyListeners();
  }

  String _merchantBusinessMobileNum = "";
  String get merchantBusinessMobileNum => _merchantBusinessMobileNum;

  void setMerchantBusinessMobileNum(String businessMobileNum) {
    _merchantBusinessMobileNum = businessMobileNum;
    notifyListeners();
  }

  void addImage(String imagePath) {
    int index = businessImages.indexWhere((element) => element == null);
    if (index != -1) {
      businessImages[index] = imagePath;
      notifyListeners();
    }
  }

  Future<List<String?>> getMerchantImagesUrl() //function to store the images to the storage in firebase, then fetching the respective http url
  async {
    List<String?> imageUrls = [];
    try {
      for (String? image in businessImages) {
        if (!image!.contains('https')) {
          File imageFile = File(image); //Get the image path
          String imageName =
              basename(imageFile.path); //get the basename from the path
          Reference storageReference =
              FirebaseStorage.instance.ref().child('TruckImages/$imageName');
          await storageReference.putFile(imageFile); //upload the image
          String imageUrl = await storageReference
              .getDownloadURL(); //get the Download Url for the image
          imageUrls.add(imageUrl); //add the image to the list
        } else {
          imageUrls.add(image);
        }
      }
      return imageUrls;
    } catch (e) {
      Fluttertoast.showToast(
        msg: '$e',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        backgroundColor: Colors.red,
        textColor: Colors.white,
      );
      return imageUrls;
    }
  }

  Future<bool> uploadMerchantInfoToDB() async {

    var imageUrls = await getMerchantImagesUrl(); //wait to get the image URL list.
    try {
      await FirebaseFirestore.instance.collection('Merchants').add({
        'merchantName': merchantName,
        'merchantMobileNum': merchantMobileNum,
        'merchantEmail': merchantEmail,
        'merchantBusinessName': merchantBusinessName,
        'merchantBusinessMobileNum': merchantBusinessMobileNum,
        'merchantBusinessAddr': merchantBusinessAddress,
        'merchantBusinessImages': imageUrls,
      });
   return true; }
    catch (e) {
      Fluttertoast.showToast(
        msg: '$e',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        backgroundColor: Colors.red,
        textColor: Colors.white,
      );
      return false;
    }
  }
}
