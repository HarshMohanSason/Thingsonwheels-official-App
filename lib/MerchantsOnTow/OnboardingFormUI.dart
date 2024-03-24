import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'MerchantProfileScreen.dart';


class OnboardingFormUI extends StatefulWidget {
  const OnboardingFormUI({super.key});

  @override
  _OnboardingFormUIState createState() => _OnboardingFormUIState();

}

class _OnboardingFormUIState extends State<OnboardingFormUI>{

  final _formkey  = GlobalKey<FormState>();
  final dbRef = FirebaseFirestore.instance; // Database reference
  static const  String _NullThenEmpty="EMPTY";
  String merchantName="";
  String merchantBusinessName="";
  String merchantBusinessAddr="";
  String merchantBusinessMobileNum="";
  String merchantMobileNum="";
  String merchantEmail="";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Merchant Onboarding'),
      ),
      body: Form(
        key: _formkey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              TextFormField(
                decoration: const InputDecoration(labelText: 'Merchant Name'),
                validator: (value){
                  if(value==null  || value.isEmpty){
                    return 'Please enter merchant name';
                  }
                  return null;
                },
                onSaved: (value)  =>  merchantName=value!,
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Merchant Contact Number'),
                validator: (value){
                  if(value==null  || value.isEmpty){
                    return 'Please enter your personal contact number';
                  }
                  return null;
                },
                onSaved: (value)  =>  merchantMobileNum=value!,
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Merchant Email'),
                validator: (value){
                  value ??= _NullThenEmpty;
                  return null;
                },
                onSaved: (value)  =>  merchantEmail=value!,
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Business Name'),
                validator: (value){
                  if(value==null  || value.isEmpty){
                    return 'Please enter business name';
                  }
                  return null;
                },
                onSaved: (value)  =>  merchantBusinessName=value!,
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Business Address'),
                validator: (value){
                  if(value==null  || value.isEmpty){
                    return 'Please enter atleast temporary business address';
                  }
                  return null;
                },
                onSaved: (value)  =>  merchantBusinessAddr=value!,
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Business Contact Number'),
                validator: (value){
                  if(value==null  || value.isEmpty){
                    return 'Please enter contact number for your business';
                  }
                  return null;
                },
                onSaved: (value)  =>  merchantBusinessMobileNum=value!,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                  onPressed: (){
                    if(_formkey.currentState!.validate()){
                      _formkey.currentState!.save();
                      //ToDo: SAVE DATA TO FIREBASE
                      saveDataToFirebase();

                      //Navigating to next screen
                      Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context)  => MerchantProfileScreen(
                            merchantName: merchantName,
                            merchantMobileNum: merchantMobileNum,
                            merchantEmail:merchantEmail,
                            merchantBusinessName: merchantBusinessName,
                            merchantBusinessMobileNum: merchantBusinessMobileNum,
                            merchantBusinessAddr: merchantBusinessAddr,
                          ) ),
                      );
                    }
                  },
                  child: const Text('Submit'),
              ),
            ],
          ),
        ),
      ),
    );

  }
  void saveDataToFirebase() {
    // dbRef.child('merchantsOnboarding').push().set({
    //   'merchantName': merchantName,
    //   'merchantMobileNum': merchantMobileNum,
    //   'merchantEmail':merchantEmail,
    //   'merchantBusinessName': merchantBusinessName,
    //   'merchantBusinessMobileNum': merchantBusinessMobileNum,
    //   'merchantBusinessAddr': merchantBusinessAddr,
    // });

  }
}