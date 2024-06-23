import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class UnderMaintenanceScreen extends StatelessWidget {
  
  Future<bool> isUnderMaintenance() async
  {
   var snapshot = await FirebaseFirestore.instance.collection('underMaintenance').doc('underMaintenanceDoc').get();
   return snapshot.data()!['isUnderMaint'];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.orange[300]!, Colors.orange[700]!],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Icon(
                Icons.build,
                size: 80,
                color: Colors.white,
              ),
              SizedBox(height: 20),
              Text(
                "Under Maintenance",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              SizedBox(height: 10),
              Text(
                "We'll be back soon!",
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
