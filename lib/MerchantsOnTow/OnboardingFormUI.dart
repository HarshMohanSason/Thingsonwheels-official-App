
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:thingsonwheels/AppSettings/AppSettingsUI.dart';
import 'package:thingsonwheels/MerchantsOnTow/ImageUploadSection.dart';
import 'package:thingsonwheels/UserLogin/IntroLoginScreenUI.dart';
import '../main.dart';
import 'MerchantOnTowService.dart';

class OnboardingFormUI extends StatefulWidget {
  const OnboardingFormUI({super.key});

  @override
  OnboardingFormUIState createState() => OnboardingFormUIState();
}

class OnboardingFormUIState extends State<OnboardingFormUI> {
  final _formKey = GlobalKey<FormState>();
  final List<String> _cities = ['Fresno', 'Santa Maria'];

  @override
  Widget build(BuildContext context) {
    final merchantTowDetails = Provider.of<MerchantsOnTOWService>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        leading:
        InkWell(
            child: Align(
              alignment: Alignment.topLeft,
              child: Icon(
                Icons.arrow_back,
                size: screenWidth / 12,
              ),
            ),
            onTap: () async {

              var readContext = context.read<MerchantsOnTOWService>();

                return showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                          elevation: 5,
                          shadowColor: Colors.black,
                          backgroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                                12), // Adjust the circular border radius
                          ),
                          content: SafeArea(
                            child: SizedBox(
                              height: screenHeight / 4,
                              child: Column(
                                children: [
                                  Icon(Icons.error_outline,
                                      color: Colors.red, size: screenWidth / 5.5),
                                  Padding(
                                    padding: EdgeInsets.only(top: screenWidth / 27),
                                    child: Text(
                                      'Are you sure you want to cancel the registration process?',
                                      style: TextStyle(fontSize: screenWidth / 28),
                                    ),
                                  ),
                                  const Spacer(),
                                  Padding(
                                    padding: EdgeInsets.only(bottom: screenWidth / 17),
                                    child: Row(
                                      children: [
                                        ElevatedButton(
                                            onPressed: () {
                                              Navigator.pop(
                                                  context); //get out of the widget
                                            },
                                            style: ButtonStyle(
                                              shape: WidgetStateProperty.all<
                                                  RoundedRectangleBorder>(
                                                RoundedRectangleBorder(
                                                  borderRadius: BorderRadius.circular(10.0),
                                                  side: const BorderSide(
                                                    color: Colors.red, // Red border color
                                                    width:
                                                    1.0, // Adjust the border width as needed
                                                  ),
                                                ),
                                              ),
                                              backgroundColor:
                                              WidgetStateProperty.all<Color>(
                                                  Colors.white),
                                              // White background color
                                              fixedSize: WidgetStateProperty.all<Size>(
                                                Size(screenWidth / 3.5, screenWidth / 43.2),
                                              ),
                                            ),
                                            child: const Text(
                                              'Cancel',
                                              style: TextStyle(
                                                color: Colors.black,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 12,
                                              ),
                                            )),
                                        const Spacer(),
                                        ElevatedButton(
                                            onPressed: () {
                                              if(readContext.isMerchantSignUp == true) {
                                                  Navigator.push(context, MaterialPageRoute(builder: (context) =>
                                                              const IntroLoginScreenUI()));
                                              }
                                              else
                                                {
                                                  Navigator.push(context, MaterialPageRoute(builder: (context) =>
                                                     const AppSettings()));
                                                }
                                            },
                                            style: ButtonStyle(
                                              shape: WidgetStateProperty.all<
                                                  RoundedRectangleBorder>(
                                                  RoundedRectangleBorder(
                                                      borderRadius:
                                                      BorderRadius.circular(10.0))),
                                              backgroundColor:
                                              WidgetStateProperty.all(Colors.red),
                                              fixedSize: WidgetStateProperty.all(Size(
                                                  screenWidth / 3.5, screenWidth / 43.2)),
                                            ),
                                            child: const Text(
                                              'Go Back',
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 12,
                                              ),
                                            )),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ));
                    });
              }
            ),
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                  padding: const EdgeInsets.only(left: 20),
                  child: RichText(
                      text: TextSpan(
                    text: "Merchant OnBoarding",
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold, // Default text color
                      fontSize: screenHeight / 32, // Default text size
                    ),
                  ))),
              Padding(
                padding: const EdgeInsets.only(top: 30, left: 20),
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
                        onSaved: (value) =>
                            merchantTowDetails.setMerchantName(value!)),
                    const SizedBox(height: 20),
                    TextFormField(
                      decoration:
                          const InputDecoration(labelText: 'Merchant Email'),
                      validator: (value) {
                        final emailRegExp = RegExp(
                          r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
                        );

                        if (value != null && value.isNotEmpty && !emailRegExp.hasMatch(value)) {
                          return "Please enter a valid email address";
                        }

                        return null; // Return null if the value is empty or valid
                      },
                      onSaved: (value) => merchantTowDetails.setMerchantEmail(value ?? ''),
                    ),
                    const SizedBox(height: 20),
                    TextFormField(
                      decoration:
                          const InputDecoration(labelText: 'Business Name'),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter business name';
                        }
                        return null;
                      },
                      onSaved: (value) =>
                          merchantTowDetails.setMerchantBusinessName(value!),
                    ),
                    const SizedBox(height: 20),
                    TextFormField(
                      decoration:
                          const InputDecoration(labelText: 'Your Address'),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter at least temporary business address';
                        }
                        return null;
                      },
                      onSaved: (value) =>
                          merchantTowDetails.setMerchantAddress(value!),
                    ),
                    const SizedBox(height: 40),
                    DropdownButtonFormField<String>(
                      decoration: const InputDecoration(
                        labelText: 'Your City',
                        border: OutlineInputBorder(),
                      ),
                      items: _cities.map((String city) {
                        return DropdownMenuItem<String>(
                          value: city,
                          child: Text(city),
                        );
                      }).toList(),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please select a city';
                        }
                        return null;
                      },
                      onChanged: (value) {
                        setState(() {
                         merchantTowDetails.setMerchantCity(value!);
                        });
                      },
                      onSaved: (value) {
                        merchantTowDetails.setMerchantCity(value!);
                      },
                    ),
                   const SizedBox(height: 20),
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
                      onSaved: (value) =>
                          merchantTowDetails.setMerchantBusinessMobileNum(value!),
                    ),
                    const SizedBox(height: 20),
                    TextFormField(
                      decoration: const InputDecoration(
                        labelText: 'Social Link',
                      ),
                      validator: (value) {
                        final urlRegExp = RegExp(
                          r'^(https?|ftp)://[^\s/$.?#].\S*$', // RegExp to match a URL
                          caseSensitive: false,
                        );

                        if (value != null && value.isNotEmpty && !urlRegExp.hasMatch(value)) {
                          return 'Please enter a valid URL';
                        }

                        return null; // Return null if the value is empty or valid
                      },
                      onSaved: (value) => merchantTowDetails.setSocialLink(value ?? ''),
                    ),
                  ],
                ),
              ),
              SizedBox(height: screenHeight/9),
              Padding(
                padding: const EdgeInsets.only(left: 10,bottom: 40),
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
                    backgroundColor: WidgetStateProperty.all(Colors.orange),
                    fixedSize: WidgetStateProperty.all<Size>(
                      Size(screenWidth - 20, 40),
                    ),
                    shape: WidgetStateProperty.all<RoundedRectangleBorder>(
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
      ),
    );
  }

}
