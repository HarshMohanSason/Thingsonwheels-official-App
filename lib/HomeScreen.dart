
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:thingsonwheels/AppSettings/AppSettingsUI.dart';
import 'package:thingsonwheels/FoodTruckDisplay/FoodTruckTileUI.dart';
import 'package:thingsonwheels/ResuableWidgets/ThingsOnWheelsAnimation.dart';
import 'package:thingsonwheels/main.dart';
import 'InternetProvider.dart';

class HomeScreen extends StatefulWidget {

  const HomeScreen({super.key});

  @override
  HomeScreenState createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen>
{
  @override
  Widget build(BuildContext context) {

    return PopScope(
      canPop: false,
      child: Consumer<InternetProvider>(
        builder: (context, internetProvider, _) {
          if (internetProvider.connectionStatus == ConnectionStatus.disconnected) {
            return Scaffold(
              backgroundColor: Colors.white,
              body: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('No internet connection', style: TextStyle(
                      fontSize: screenWidth/15, fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),),
                    ElevatedButton(
                      onPressed: () {
                        internetProvider.retryInternetConnection();
                      },
                      child: Text('Retry', style: TextStyle(
                        fontSize: screenWidth/20, fontWeight: FontWeight.bold,
                        color: Colors.orange,
                      ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          } else {
            // Return your original Scaffold if the internet connection is not disconnected
            return Scaffold(
              backgroundColor: Colors.white,
              body: SafeArea(
                child: Column(
                  children: [
                    Row(
                      children: [
                        SizedBox(
                          width: screenWidth/3,
                          child: Align(
                              child: TOWLogoAnimation(fontSize: screenWidth/22)),
                        ),
                        InkWell(

                          onTap: () async {
                            displayToastMessagePopUp(context);
                        },
                          child: Padding(
                            padding:  EdgeInsets.only(left: screenWidth/17),
                            child: Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: Colors.orange[200], // Example light orange color// Example background color
                                borderRadius: BorderRadius.circular(25), // Example border radius
                              ),
                              child:  Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(Icons.location_pin, color: Colors.white, size: screenWidth/17,), // Example icon
                                  const SizedBox(width: 8),
                                   Text(
                                    "Fresno",
                                    style: TextStyle(color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: screenWidth/26,
                                    ), // Example text style
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        const  Spacer(),
                        InkWell(
                          onTap: () {
                            Navigator.push(context, MaterialPageRoute(builder: (context) => const AppSettings()));
                          },
                          child: Icon(Icons.settings, size: screenWidth / 14),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    const Expanded(child: FoodTruckTileUI()),
                  ],
                ),
              ),
            );
          }
        },
      ),
    );
  }

  Future<void> displayToastMessagePopUp(BuildContext context) {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30.0),
          ),
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    TOWLogoAnimation(
                      fontSize: MediaQuery.of(context).size.width / 13,
                    ),
                   const  Spacer(),
                    IconButton(
                      onPressed: () {
                        Navigator.of(context).pop(); // Close the dialog
                      },
                      icon: Icon(
                        Icons.cancel,
                        color: colorTheme,
                        size: MediaQuery.of(context).size.width / 15,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: MediaQuery.of(context).size.height * 0.05),
                Text(
                  "Currently we are operating in Fresno, we will be coming to other locations soon!!  Submit a food truck in app settings. Thanks for downloading and supporting us.",
                  style: TextStyle(
                    fontSize: MediaQuery.of(context).size.width / 20,
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }



}