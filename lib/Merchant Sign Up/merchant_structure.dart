import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:thingsonwheels/Reusable%20Widgets/toast_widget.dart';

enum MerchantSignUpStateEnum { loading, error, success, idle }

class MenuItem extends ChangeNotifier {
  String _itemName;
  String _description;
  double _price;
  String _itemImage;

  // Optional parameters with default values
  MenuItem({
    String itemName = '',
    String description = '',
    double price = 0.0,
    String itemImage = '',
  })  : _itemName = itemName,
        _description = description,
        _price = price,
        _itemImage = itemImage;

  // Getters
  String get itemName => _itemName;

  String get description => _description;

  double get price => _price;

  String get itemImage => _itemImage;

  // Setters with notifyListeners()
  set itemName(String name) {
    _itemName = name;
    notifyListeners();
  }

  set description(String desc) {
    _description = desc;
    notifyListeners();
  }

  set price(double itemPrice) {
    _price = itemPrice;
    notifyListeners();
  }

  set itemImage(String val) {
    _itemImage = val;
    notifyListeners();
  }
}

class MerchantStructure extends ChangeNotifier {
  MerchantSignUpStateEnum _merchantSignUpState = MerchantSignUpStateEnum.idle;

  String? _merchantProfileImage;
  String _merchantEmail = "";
  String _merchantBusinessName = "";
  String _merchantBusinessPhoneNumber = "";
  String _merchantAddress = "";
  final List<String?> _merchantBusinessImages =
      List<String?>.generate(7, (_) => null);
  final List<MenuItem> _menuItems = [];

  String? get merchantProfileImage => _merchantProfileImage;

  String? get merchantEmail => _merchantEmail;

  String get merchantBusinessName => _merchantBusinessName;

  String get merchantBusinessPhoneNumber => _merchantBusinessPhoneNumber;

  String get merchantAddress => _merchantAddress;

  List<String?> get merchantBusinessImages => _merchantBusinessImages;

  List<MenuItem> get menuItems => _menuItems;

  MerchantSignUpStateEnum get merchantSignUpState => _merchantSignUpState;

  set setMerchantProfileImage(String? value) {
    _merchantProfileImage = value;
    notifyListeners();
  }

  set setMerchantEmail(String value) {
    _merchantEmail = value;
    notifyListeners();
  }

  set setMerchantBusinessName(String value) {
    _merchantBusinessName = value;
    notifyListeners();
  }

  set setMerchantBusinessPhoneNumber(String value) {
    _merchantBusinessPhoneNumber = value;
    notifyListeners();
  }

  set setMerchantBusinessAddress(String value) {
    _merchantAddress = value;
    notifyListeners();
  }

  set setMerchantSignUpState(MerchantSignUpStateEnum val) {
    _merchantSignUpState = val;
    notifyListeners();
  }

  set setMerchantBusinessImages(String imagePath) {
    // Find the first empty or null slot, if any
    int index = merchantBusinessImages
        .indexWhere((element) => element == null || element.isEmpty);

    if (index != -1) {
      // Replace the empty slot with the new image path
      merchantBusinessImages[index] = imagePath;
    } else {
      // If no empty slot found, add the new image to the list
      merchantBusinessImages.add(imagePath);
    }

    // Notify listeners of the update
    notifyListeners();
  }

  set setMenuItems(MenuItem item) {
    menuItems.add(item);
    notifyListeners();
  }

  //This function will only be called when we are editing the images in the merchant user settings
  void setMenuItemImagesForEditing(List<MenuItem> items) {
    menuItems.clear();
    for (int i = 0; i < items.length; i++) {
      setMenuItems = items[i];
    }
  }

  void updateMenuItemImage(int index, String image) {
    _menuItems[index].itemImage = image;
    notifyListeners();
  }

  void removeMenuItem(int index) {
    _menuItems.removeAt(index);
    notifyListeners();
  }

  void updateMenuItem(int index, MenuItem menuItem) {
    _menuItems[index] = menuItem;
    notifyListeners();
  }

  void removeMerchantBusinessImage(int index) {
    merchantBusinessImages[index] = null;
    notifyListeners();
  }

  void clearMerchantBusinessImages() {
    for (int i = 0; i < merchantBusinessImages.length; i++) {
      merchantBusinessImages[i] = null;
    }
    menuItems.clear();
    notifyListeners();
  }

  Future uploadMerchantInformation() async {
    setMerchantSignUpState = MerchantSignUpStateEnum.loading;
    notifyListeners();
    try {
      await uploadMerchantBusinessImagesToStorage();
      await uploadMerchantProfileImageToStorage();
      await updateMerchantFirebaseProfile();
      await uploadMerchantMenuImages();
      await FirebaseFirestore.instance
          .collection('merchants')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .set(toMap());
      await FirebaseFirestore.instance
          .collection('merchants')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .set(
        {
          'MenuItems': menuItemsToMap(),
        },
        SetOptions(merge: true), // Make sure existing data is preserved
      );
      clearMerchantBusinessImages();
      _merchantProfileImage = null;
      setMerchantSignUpState = MerchantSignUpStateEnum.success;
    } on SocketException {
      setMerchantSignUpState = MerchantSignUpStateEnum.error;
      showToast('Network error occurred, please check your internet connection',
          Colors.red, Colors.white, "SHORT");
    } catch (e) {
      setMerchantSignUpState = MerchantSignUpStateEnum.error;
      showToast(
          'An error occurred uploading your information, please try again',
          Colors.red,
          Colors.white,
          "SHORT");
    }
  }

  Future<void> uploadMerchantBusinessImagesToStorage() async {
    merchantBusinessImages
        .removeWhere((image) => image == null); //remove the null images.
    try {
      for (int i = 0; i < merchantBusinessImages.length; i++) {
        String imageUrl = await getFirebaseStorageUrl(
            merchantBusinessImages[i]!, 'FoodTruckImages');
        // Replace the local image path with the URL in the same list
        merchantBusinessImages[i] = imageUrl;
      }
    } on SocketException {
      showToast(
          'Check your Internet Connection', Colors.red, Colors.white, 'SHORT');
    } catch (e) {
      showToast('An error occurred, please try again', Colors.red, Colors.white,
          'SHORT');
    }
  }

  Future<void> uploadMerchantMenuImages() async {
    try {
      for (int i = 0; i < menuItems.length; i++) {
        String imageUrl = await getFirebaseStorageUrl(
            menuItems[i].itemImage, 'MenuItemImages');
        // Replace the local image path with the URL in the same list
        menuItems[i].itemImage = imageUrl;
      }
    } on SocketException {
      showToast(
          'Check your Internet Connection', Colors.red, Colors.white, 'SHORT');
    } catch (e) {
      showToast('An error occurred, please try again', Colors.red, Colors.white,
          'SHORT');
    }
  }

  Future uploadMerchantProfileImageToStorage() async {
    try {
      String imageUrl =
          await getFirebaseStorageUrl(merchantProfileImage!, 'ProfileImages');
      _merchantProfileImage = imageUrl;
    } on SocketException {
      showToast(
          'Check your Internet Connection', Colors.red, Colors.white, 'SHORT');
    } catch (e) {
      showToast('An error occurred, please try again', Colors.red, Colors.white,
          'SHORT');
    }
  }

  Future<String> getFirebaseStorageUrl(
      String image, String folderLocation) async {
    try {
      if (image.isNotEmpty && !image.contains('https')) {
        File imageFile = File(image); // Get the image path
        String imageName =
            basename(imageFile.path); // Get the basename from the path
        Reference storageReference = FirebaseStorage.instance.ref().child(
            'merchant_${FirebaseAuth.instance.currentUser!.uid}/$folderLocation/$imageName');
        await storageReference.putFile(imageFile); // Upload the image
        String imageUrl =
            await storageReference.getDownloadURL(); // Get the Download URL
        return imageUrl;
      }
    } catch (e) {
      showToast(
          'Check your Internet Connection', Colors.red, Colors.white, 'SHORT');
    }
    return '';
  }

  Future updateMerchantFirebaseProfile() async {
    if (FirebaseAuth.instance.currentUser != null) {
      if (merchantProfileImage != null) {
        FirebaseAuth.instance.currentUser!.updatePhotoURL(merchantProfileImage);
      }
      if (merchantEmail != null) {
        FirebaseAuth.instance.currentUser!.updateEmail(merchantEmail!);
      }
      FirebaseAuth.instance.currentUser!
          .updateDisplayName(merchantBusinessName);
    }
  }

  static goLive(String uid, bool goLive) {
    FirebaseFirestore.instance
        .collection('merchants')
        .where('uid', isEqualTo: uid)
        .get() // Use get() instead of snapshots()
        .then((snapshot) {
      if (snapshot.docs.isNotEmpty) {
        // Check if there are any matching documents
        var docRef =
            snapshot.docs.first.reference; // Get the document reference
        docRef.update({'isLive': goLive}); // Update the document
      }
    }).catchError((error) {
      showToast(error, Colors.red, Colors.white10, "Long");
    });
    return null;
  }

  void merchantSignOut() {
    try {
      FirebaseAuth.instance.signOut();
    } catch (e) {
      showToast(
          "An error occurred signing out", Colors.red, Colors.white, "LONG");
    }
  }

  Map<String, dynamic> toMap() {
    //convert function to map
    return {
      'ProfileImage': merchantProfileImage,
      'Email': merchantEmail,
      'BusinessName': merchantBusinessName,
      'BusinessPhoneNumber': merchantBusinessPhoneNumber,
      'BusinessImages': merchantBusinessImages,
      'uid': FirebaseAuth.instance.currentUser!.uid,
      'isLive': false,
      'CurrentRating': 5,
      'Ratings': {FirebaseAuth.instance.currentUser!.uid: 5},
      'Tags': [],
    };
  }

  static bool isImageUrl(String image) {
    // Basic validation to check if the string starts with "http" or "https"
    // We are checking if the image is a URL or form asset so we can use the widget accordingly
    final uri = Uri.tryParse(image);
    return uri != null &&
        uri.hasAbsolutePath &&
        (uri.scheme == 'http' || uri.scheme == 'https');
  }

  List<Map<String, dynamic>> menuItemsToMap() {
    final menuItemsInMapForm = menuItems.map((menuItem) {
      return {
        'ItemName': menuItem.itemName,
        'ItemDescription': menuItem.description,
        'ItemPrice': menuItem.price,
        'ItemImage': menuItem.itemImage,
      };
    }).toList();
    return menuItemsInMapForm;
  }
}
