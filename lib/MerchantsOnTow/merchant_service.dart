
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:path/path.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Provider class to handle state of MerchantOnTOWBoarding form.
class MerchantsOnTOWService extends ChangeNotifier {

  MerchantsOnTOWService()
  {
    _loadIsMerchantSignUp();
  }
  final List<String?> _businessImages = List<String?>.generate(4, (_) => null);
  List<String?> get businessImages => _businessImages;

  void addImage(String imagePath) {
    int index = businessImages.indexWhere((element) => element == null);
    if (index != -1) {
      businessImages[index] = imagePath;
      notifyListeners();
    }
  }

  bool _isMerchantSignUp = false;
  bool get isMerchantSignUp => _isMerchantSignUp;

  void setIsMerchantSignup(bool value) async
  {
    _isMerchantSignUp = value;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isMerchantSignUp', value);
    notifyListeners();
  }

  Future<void> _loadIsMerchantSignUp() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
   _isMerchantSignUp = prefs.getBool('isMerchantSignUp') ?? false;
    notifyListeners();
  }

  String _merchantName = "";
  String get merchantName => _merchantName;

  void setMerchantName(String name) {
    _merchantName = name;
    notifyListeners();
  }

  String _socialLink ="";
  String get socialLink => _socialLink;

  void setSocialLink(String socialLink) {
    _socialLink = socialLink;
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

  String _merchantCity = "";

  String get merchantCity => _merchantCity;

  void setMerchantCity(String city) {
    _merchantCity = city;
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
    } on SocketException {
      Fluttertoast.showToast(
        msg: 'Check your Internet Connection',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        backgroundColor: Colors.red,
        textColor: Colors.white,
      );
      return imageUrls;
    }
    catch (e) {
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
        'merchantEmail': merchantEmail,
        'merchantBusinessName': merchantBusinessName,
        'merchantBusinessAddr': merchantBusinessAddress,
        'merchantCity': merchantCity,
        'merchantContactNum':FirebaseAuth.instance.currentUser!.phoneNumber,
        'merchantBusinessMobileNum': merchantBusinessMobileNum,
        'merchantBusinessImages': imageUrls,
        'socialLink': socialLink,
        'isLive': false,
        'uid': FirebaseAuth.instance.currentUser!.uid,
      });
      return true;
    } on SocketException {
      Fluttertoast.showToast(
        msg: 'Check your Internet Connection',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        backgroundColor: Colors.red,
        textColor: Colors.white,
      );
      return false;
    }
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

  Future<Map<String, dynamic>> getMerchantInfo() async {
    Map<String, dynamic> currMerchantInfo = {};
    String currUserID = FirebaseAuth.instance.currentUser!.uid;
    try {
      var snapshot = await FirebaseFirestore.instance
          .collection('Merchants')
          .where('uid', isEqualTo: currUserID)
          .get();

      currMerchantInfo = snapshot.docs.first.data();

      return currMerchantInfo;
    } on SocketException {
      Fluttertoast.showToast(
        msg: 'Check your Internet Connection',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        backgroundColor: Colors.red,
        textColor: Colors.white,
      );
      return currMerchantInfo;
    }
    catch (e) {
      return currMerchantInfo;
    }
  }

  Stream<bool> getIsLiveStream() {
    try {
      String currUserID = FirebaseAuth.instance.currentUser!.uid;
      return FirebaseFirestore.instance
          .collection('Merchants')
          .where('uid', isEqualTo: currUserID)
          .snapshots()
          .map((snapshot) => snapshot.docs.first.data()['isLive'] ?? false);
    }
    on SocketException {
      Fluttertoast.showToast(
        msg: 'Check your Internet Connection',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        backgroundColor: Colors.red,
        textColor: Colors.white,
      );
      return Stream.value(false);
    }
    catch (e) {
      return Stream.value(false);
    }
  }

  Future goLive() async {
    try {
      var snapshot = await FirebaseFirestore.instance
          .collection('Merchants')
          .where('uid', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
          .get();
      if (snapshot.docs.isNotEmpty) {
        var docRef = snapshot.docs.first.reference;
        await docRef.update({'isLive': true});
        Fluttertoast.showToast(
          msg: 'Live right now!'.tr(),
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.CENTER,
          backgroundColor: Colors.green,
          textColor: Colors.white,
          fontSize: 16.0,
        );
      }
    } on SocketException {
      Fluttertoast.showToast(
        msg: 'Check your Internet Connection'.tr(),
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        backgroundColor: Colors.red,
        textColor: Colors.white,
      );
    }
    catch (e) {
      Fluttertoast.showToast(
        msg: 'Could not go live, Please try again later',
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.CENTER,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0,
      );
    }
  }

  Future goOffLive() async {
    try {
      var snapshot = await FirebaseFirestore.instance
          .collection('Merchants')
          .where('uid', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
          .get();
      if (snapshot.docs.isNotEmpty) {
        var docRef = snapshot.docs.first.reference;
        await docRef.update({'isLive': false});
        Fluttertoast.showToast(
          msg: 'No more live right now'.tr(),
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.CENTER,
          backgroundColor: Colors.green,
          textColor: Colors.white,
          fontSize: 16.0,
        );
      }
    } catch (e) {
      Fluttertoast.showToast(
        msg: 'Could not go off live, Please try again later',
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.CENTER,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0,
      );
    }
  }

 Future<bool> updateMerchantInfo(Map<String, dynamic> updates) async {
    try {
      var snapshot = await FirebaseFirestore.instance
          .collection('Merchants')
          .where('uid', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
          .get();

      if (snapshot.docs.isNotEmpty) {
        var documentID = snapshot.docs.first.id;
        var docRef =
            FirebaseFirestore.instance.collection('Merchants').doc(documentID);
        await docRef.update(updates);
      }
    return true;
    } on SocketException {
      Fluttertoast.showToast(
        msg: 'Check your Internet Connection'.tr(),
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        backgroundColor: Colors.red,
        textColor: Colors.white,
      );
      return false;
    }
    catch (e) {
      Fluttertoast.showToast(
        msg: 'Error occurred, please try again'.tr(),
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.CENTER,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0,
      );
    }
    return false;
  }

  Future<List<String?>> newImageUpload(List<String?> imageUrls) async {
    List<String?> updatedImageUrls = List<String?>.from(imageUrls); // Copy the original list
    updatedImageUrls.removeWhere((element) => element == null);
    try {
      for (int i = 0; i < updatedImageUrls.length; i++) {
        String? image = updatedImageUrls[i];
        if (!image!.contains('https')) {
          File imageFile = File(image); // Get the image path
          String imageName = basename(imageFile.path); // Get the basename from the path
          Reference storageReference = FirebaseStorage.instance.ref().child('TruckImages/$imageName');
          await storageReference.putFile(imageFile); // Upload the image
          String imageUrl = await storageReference.getDownloadURL(); // Get the Download Url for the image
          updatedImageUrls[i] = imageUrl; // Update the image URL in the list
        }
      }

      return updatedImageUrls;
    } on SocketException {
      Fluttertoast.showToast(
        msg: 'Check your Internet Connection'.tr(),
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        backgroundColor: Colors.red,
        textColor: Colors.white,
      );
      return updatedImageUrls;
    }
    catch (e) {
      // Handle errors for individual image uploads
      Fluttertoast.showToast(
        msg: 'Error uploading image: $e',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        backgroundColor: Colors.red,
        textColor: Colors.white,
      );
      return updatedImageUrls; // Return the list even if some images failed to upload
    }
  }

  void deleteMerchantDocument() async {
    // Get the current user's UID
    String currentUserUID = FirebaseAuth.instance.currentUser!.uid;

    // Query the 'Merchants' collection for documents where 'uid' field matches currentUserUID
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('Merchants')
        .where('uid', isEqualTo: currentUserUID)
        .get();

    // Check if any documents match the query
    if (querySnapshot.docs.isNotEmpty) {
      // Assuming there is only one document that matches the query, delete it
      String documentID = querySnapshot.docs.first.id;
      await FirebaseFirestore.instance
          .collection('Merchants')
          .doc(documentID)
          .delete();

      // Show success message using FlutterToast
      Fluttertoast.showToast(
        msg: 'Merchant information deleted successfully.',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        backgroundColor: Colors.green,
        textColor: Colors.white,
      );
    } else {
      // Show failure message using FlutterToast
      Fluttertoast.showToast(
        msg: 'Could not find any merchant information for this number.',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        backgroundColor: Colors.red,
        textColor: Colors.white,
      );
    }
  }
}