
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../ResuableWidgets/toast_widget.dart';

class TowService {

  List<String>? truckImages;
  String truckName;
  String? truckAddress;
  String? truckPhoneNo;
  Map<String, dynamic> socialLink;
  bool isLive;
  String docID;

  TowService(
      {required this.truckImages, required this.truckName, required this.truckAddress,
        required this.truckPhoneNo, /*required this.truckTime,*/ required this.isLive, required this.socialLink, required this.docID});


  // Static function returning list of FoodTruck objects
  static Future<List<TowService>> getTOWMerchantInfo(String location) async {

    try {
      var allDocSnapshot = await FirebaseFirestore.instance.collection(
          'Merchants').where('merchantCity', isEqualTo: location).get();

      List<TowService> trucks = []; //list to hold the foodTruck objects

      if (allDocSnapshot.docs.isNotEmpty) {
        for (var snapshot in allDocSnapshot.docs) {
          TowService truck = TowService(
              truckImages: List<String>.from(
                  snapshot['merchantBusinessImages']),
              // truckTime: Map<String, dynamic>.from(snapshot['merchantBusinessMobileNum']),
              truckPhoneNo: snapshot['merchantBusinessMobileNum'],
              truckAddress: snapshot['merchantBusinessAddr'],
              truckName: snapshot['merchantBusinessName'],
              isLive: snapshot['isLive'],
              socialLink: snapshot['socialLink'],
              docID: snapshot.id
          );
          trucks.add(truck); // add the objects to the list
        }
      }

      return trucks;
    } on SocketException {
      showToast('Check your Internet Connection', Colors.red, Colors.white, 'SHORT');
    return [];
    }
    catch (e) {
      showToast('Error occurred, please try again', Colors.red, Colors.white, 'SHORT');
      return []; // Return an empty list in case of error
    }
  }

  static Stream<Map<String, bool>> getLiveStatusStream() {
    try {
      return FirebaseFirestore.instance.collection('Merchants')
          .snapshots()
          .map((querySnapshot) {
        Map<String, bool> liveStatusMap = {};
        for (var doc in querySnapshot.docs) {
          liveStatusMap[doc.id] = doc.data()['isLive'] ?? false;
        }
        return liveStatusMap;
      });
    }
    on SocketException
    {
      showToast('Check your Internet Connection', Colors.red, Colors.white, 'SHORT');
      rethrow;
    }
    catch (e) {
      rethrow;
    }
  }
}