
/*
import 'package:flutter/material.dart';
import 'package:location/location.dart';
import 'package:thingsonwheels/MerchantsOnTow/MerchantProfileScreen.dart';
import '../ResuableWidgets/GetLocation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class GoLiveScreen extends StatefulWidget {
  @override
  _GoLiveScreenState createState() => _GoLiveScreenState();
}

class _GoLiveScreenState extends State<GoLiveScreen> {
  //LocationData? _currentLocation;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(title: Text("Merchant Live Location")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
              onPressed: () async {
                _currentLocation = await LocationService.getLocation();
                if (_currentLocation != null) {
                  await _saveLocationToFirebase(_currentLocation!);
                  // ToDo: Update notifications logic here
                }
              },
              child: Text("Go Live"),
            ),
            ElevatedButton(
              onPressed: () {
                // Navigator.push(
                //
                //   //ToDo: get merchant details and redirect to edit profile screen
                // );
              },
              child: Text("Edit Profile"),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _saveLocationToFirebase(LocationData locationData) async {
    //ToDo: validation of merchant and location
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    await firestore.collection('merchants_live_location').doc('merchantId').set({
      'latitude': locationData.latitude,
      'longitude': locationData.longitude,
      'isLive': true,
      'timestamp':'',
    });
  }
}

 */
