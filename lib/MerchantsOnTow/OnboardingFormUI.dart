
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
import 'package:thingsonwheels/MerchantsOnTow/ImageUploadSection.dart';
import '../main.dart';
import 'MerchantOnTowService.dart';

class OnboardingFormUI extends StatefulWidget {
  const OnboardingFormUI({super.key});

  @override
  _OnboardingFormUIState createState() => _OnboardingFormUIState();
}

class _OnboardingFormUIState extends State<OnboardingFormUI> {

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {

    final merchantTowDetails = Provider.of<MerchantsOnTOWService>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        leading: InkWell(
          onTap: () {
            Navigator.pop(context);
          },
          child: Icon(Icons.arrow_back, size: screenWidth / 14),
        ),
        title: Text(
          'Merchant Onboarding',
          style: TextStyle(
            fontSize: screenWidth / 17,
          ),
        ),
      ),
      body: Form(
        key: _formKey,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 20),
              child: Column(
                children: [
                  TextFormField(
                    decoration:
                        const InputDecoration(labelText: 'Merchant Name'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter merchant name';
                      }
                      return null;
                    },
                    onSaved: (value) => merchantTowDetails.setMerchantName(value!)
                  ),
                  TextFormField(
                    maxLength: 10,
                    decoration: const InputDecoration(
                        labelText: 'Merchant Contact Number'),
                    validator: (value) {
                      final nonNumericRegExp = RegExp(
                          r'^[0-9]+$'); //RegExp to match the phone number
                      if (value!.isEmpty) {
                        //return an error if the textForm is not empty
                        return 'Please enter a valid phone number';
                      }
                      //check if the number isWithin 0-9.
                      if (!nonNumericRegExp.hasMatch(value)) {
                        return 'Phone number must contain only digits'; //
                      }
                      if (value.length <
                          10) //Make sure the number is a total of 10 digits.
                          {
                        return 'Number should be a ten digit number';
                      }
                      return null;
                    },
                    onSaved: (value) => merchantTowDetails.setMerchantMobileNum(value!),
                  ),
                  TextFormField(
                    decoration:
                        const InputDecoration(labelText: 'Merchant Email'),
                    validator: (value) {
                      final emailRegExp = RegExp(
                          r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$'
                      );
                      if(!emailRegExp.hasMatch(value!))
                        {
                          return "Please enter a valid email address";
                        }
                      return null;
                    },
                    onSaved: (value) => merchantTowDetails.setMerchantAddress(value!),
                  ),
                  TextFormField(
                    decoration:
                        const InputDecoration(labelText: 'Business Name'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter business name';
                      }
                      return null;
                    },
                    onSaved: (value) => merchantTowDetails.setMerchantBusinessName(value!),
                  ),
                  TextFormField(
                    decoration:
                        const InputDecoration(labelText: 'Business Address'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter atleast temporary business address';
                      }
                      return null;
                    },
                    onSaved: (value) => merchantTowDetails.setMerchantAddress(value!),
                  ),
                  TextFormField(
                    maxLength: 10,
                    decoration: const InputDecoration(
                        labelText: 'Business Contact Number'),
                    validator: (value) {
                      final nonNumericRegExp = RegExp(
                          r'^[0-9]+$'); //RegExp to match the phone number
                      if (value!.isEmpty) {
                        //return an error if the textForm is not empty
                        return 'Please enter a valid phone number';
                      }
                      //check if the number isWithin 0-9.
                      if (!nonNumericRegExp.hasMatch(value)) {
                        return 'Phone number must contain only digits'; //
                      }
                      if (value.length <
                          10) //Make sure the number is a total of 10 digits.
                      {
                        return 'Number should be a ten digit number';
                      }

                      return null;
                    },
                    onSaved: (value) => merchantTowDetails.setMerchantBusinessMobileNum(value!),
                  ),
                ],
              ),
            ),
            const Spacer(),
            Padding(
              padding: EdgeInsets.only(bottom: 40),
              child: ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState!.save();

                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const ImageUploadSection()));

                  }
                },
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(Colors.orange),
                  fixedSize: MaterialStateProperty.all<Size>(
                    Size(screenWidth - 20, 40),
                  ),
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                  ),
                ),
                child: const Text(
                  'Next',
                  style: TextStyle(
                      fontSize: 18,
                      color: Colors.white,
                      fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

 /* Future<void> saveDataToFirebase() async {

    try {
      await FirebaseFirestore.instance.collection('Merchants').add({
        'merchantName': merchantName,
        'merchantMobileNum': merchantMobileNum,
        'merchantEmail': merchantEmail,
        'merchantBusinessName': merchantBusinessName,
        'merchantBusinessMobileNum': merchantBusinessMobileNum,
        'merchantBusinessAddr': merchantBusinessAddr,
      });


    }
    catch(e)
    {

    }

  }

  */
}
