import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:thingsonwheels/Reusable%20Widgets/toast_widget.dart';

import '../Merchant Sign Up/merchant_structure.dart';

class FoodTruckStructure extends ChangeNotifier {
  final Map<String, int> ratings;
  final int currentRating;
  final List<String?> tileImages;
  final List<MenuItem> menuItems;
  final List<String> tags;
  final String profileImage;
  final String uid;
  final String docID;
  final String foodTruckName;
  final String foodTruckAddress;
  final String foodTruckPhoneNumber;
  final bool isLive;

  FoodTruckStructure(
      this.ratings,
      this.currentRating,
      this.tileImages,
      this.menuItems,
      this.tags,
      this.profileImage,
      this.uid,
      this.docID,
      this.foodTruckName,
      this.foodTruckAddress,
      this.foodTruckPhoneNumber,
      this.isLive);

  static Future<List<FoodTruckStructure>> getFoodTrucks() async {
    List<FoodTruckStructure> foodTruckInfo = [];
    try {
      var snapshot =
          await FirebaseFirestore.instance.collection('merchants').get();

      for (var doc in snapshot.docs) {
        FoodTruckStructure foodTruckStructure = FoodTruckStructure(
            Map<String, int>.from(doc['Ratings']),
            doc['CurrentRating'],
            List<String?>.from(doc['BusinessImages']),
            convertToMenuItem(doc['MenuItems']),
            List<String>.from(doc['Tags']),
            doc['ProfileImage'],
            doc['uid'],
            doc.id,
            doc['BusinessName'],
            doc['BusinessAddress'],
            doc['BusinessPhoneNumber'],
            doc['isLive']);
        foodTruckInfo.add(foodTruckStructure);
      }
    } on SocketException catch (e) {
      // e.toString();
    } catch (e) {
      print(e);
    }
    return foodTruckInfo;
  }

  static Future<FoodTruckStructure?> getFoodTruckOwnerInfo(String? uid) async {
    try {
      var snapshot = await FirebaseFirestore.instance
          .collection('merchants')
          .where('uid', isEqualTo: uid)
          .get();

      var doc = snapshot.docs.first;
      FoodTruckStructure foodTruckStructure = FoodTruckStructure(
          Map<String, int>.from(doc['Ratings']),
          doc['CurrentRating'],
          List<String?>.from(doc['BusinessImages']),
          convertToMenuItem(doc['MenuItems']),
          List<String>.from(doc['Tags']),
          doc['ProfileImage'],
          doc['uid'],
          doc.id,
          doc['BusinessName'],
          doc['BusinessAddress'],
          doc['BusinessPhoneNumber'],
          doc['isLive']);
      return foodTruckStructure;
    } on SocketException {
      showToast('Please check your internet connection', Colors.red, Colors.red,
          "Long");
    } catch (e) {
      showToast('An error occurred', Colors.red, Colors.red, "Long");
    }
    return null;
  }

  static Stream<bool> getIsLiveStatus(String docID) {
    try {
      return FirebaseFirestore.instance
          .collection('merchants')
          .doc(docID)
          .snapshots()
          .map((snapshot) {
        if (snapshot.exists) {
          return snapshot.data()!['isLive'] ?? false;
        } else {
          return false;
        }
      });
    } on SocketException {
      showToast('Please check your internet connection', Colors.red,
          Colors.white10, "SHORT");

      return Stream.value(false);
    } catch (e) {
      showToast('Error occurred fetching the live status', Colors.red,
          Colors.white10, "SHORT");

      return Stream.value(false);
    }
  }



  static List<MenuItem> convertToMenuItem(List<dynamic> list) {
    return list.map((eachMap) {
      return MenuItem(
        itemName: eachMap['ItemName'] as String,
        description: eachMap['ItemDescription'] as String,
        price: eachMap['ItemPrice'] as double,
        itemImage: eachMap['ItemImage'] as String,
      );
    }).toList();
  }
}
