
import 'package:cloud_firestore/cloud_firestore.dart';

class FoodTruck {

  List<String>? truckImages;
  String truckName;
  String? truckAddress;
  String? truckPhoneNo;
  List<String>? truckTime;
  String? socialLink;
  bool isAvailable;


  FoodTruck({required this.truckImages, required this.truckName, required this.truckAddress,
  required this.truckPhoneNo, required this.truckTime, required this.isAvailable, required this.socialLink});


  // Static function returning list of FoodTruck objects
  static Future<List<FoodTruck>> getTruckDataFirestore() async {
    try {
      var allDocSnapshot = await FirebaseFirestore.instance.collection('FoodTrucks').get();

      List<FoodTruck> trucks = [];  //list to hold the foodTruck objects

      if (allDocSnapshot.docs.isNotEmpty) {
        for (var snapshot in allDocSnapshot.docs) {
          FoodTruck truck = FoodTruck(
            truckImages: List<String>.from(snapshot['truckImages']),
            truckTime: List<String>.from(snapshot['truckTime']),
            truckPhoneNo: snapshot['truckPhoneNo'],
            truckAddress: snapshot['truckAddress'],
            truckName: snapshot['truckName'],
            isAvailable: snapshot['isAvailable'],
            socialLink:  snapshot['socialMedia'],
          );
          trucks.add(truck); // add the objects to the list
        }
      }

      return trucks;
    } catch (e) {

      print('Error fetching data: $e');
      return []; // Return an empty list in case of error
    }
  }

}