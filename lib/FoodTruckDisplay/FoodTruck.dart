
import 'package:cloud_firestore/cloud_firestore.dart';

class FoodTruck {

  List<String> truckImages;
  String truckName;
  String truckAddress;
  String truckPhoneNo;
  String truckTime;
  bool isAvailable;

  FoodTruck({required this.truckImages, required this.truckName, required this.truckAddress,
  required this.truckPhoneNo, required this.truckTime, required this.isAvailable});

  //function to convert object values to map in order to upload to
  Map<String, dynamic> toMap()
  {
    return ({

      'truckImages': truckImages,
      'truckName': truckName,
      'truckAddress': truckAddress,
      'truckPhoneNo': truckPhoneNo,
      'truckTime': truckTime,
      'isAvailable': isAvailable,
    });

  }

  // Static function returning list of FoodTruck objects
  static Future<List<FoodTruck>> getTruckDataFirestore() async {
    try {
      var allDocSnapshot = await FirebaseFirestore.instance.collection('FoodTrucks').get();

      List<FoodTruck> trucks = [];

      if (allDocSnapshot.docs.isNotEmpty) {
        for (var snapshot in allDocSnapshot.docs) {
          FoodTruck truck = FoodTruck(
            truckImages: List<String>.from(snapshot['truckImages']),
            truckTime: snapshot['truckTime'],
            truckPhoneNo: snapshot['truckPhoneNo'],
            truckAddress: snapshot['truckAddress'],
            truckName: snapshot['truckName'],
            isAvailable: snapshot['isAvailable'],
          );
          trucks.add(truck); // add the objects to the list
        }
      }

      return trucks;
    } catch (e) {
      // Handle exceptions gracefully
      print('Error fetching data: $e');
      return []; // Return an empty list in case of error
    }
  }

}