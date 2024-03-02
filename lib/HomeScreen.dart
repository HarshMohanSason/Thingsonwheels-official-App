
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:thingsonwheels/AppSettings/AppSettingsUI.dart';
import 'package:thingsonwheels/FoodTruckDisplay/FoodTruckTileUI.dart';
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
                        fontSize: screenWidth/15, fontWeight: FontWeight.bold,
                        color: Colors.white,
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
                        const Spacer(),
                        Row(
                          children: [
                            Icon(Icons.location_on, size: screenWidth / 13),
                            Text(
                              "Fresno",
                              style: TextStyle(
                                fontSize: screenWidth / 18,
                              ),
                            ),
                          ],
                        ),
                        const  Spacer(),
                        InkWell(
                          onTap: () {
                            Navigator.push(context, MaterialPageRoute(builder: (context) => const AppSettings()));
                          },
                          child: Icon(Icons.settings, size: screenWidth / 12),
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


}