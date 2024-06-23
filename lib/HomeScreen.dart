
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:thingsonwheels/AppSettings/AppSettingsUI.dart';
import 'package:thingsonwheels/FoodTruckDisplay/FoodTruckTileUI.dart';
import 'package:thingsonwheels/Location/LocationSelector.dart';
import 'package:thingsonwheels/ResuableWidgets/UnderMaintenanceScreen.dart';
import 'package:thingsonwheels/main.dart';
import 'ResuableWidgets/InternetProvider.dart';

class HomeScreen extends StatefulWidget {


  const HomeScreen({super.key});

  @override
  HomeScreenState createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen>
{
  final UnderMaintenanceScreen underMaintenanceScreen = UnderMaintenanceScreen();
  bool isUnderMaintenance = false;

  @override
  void initState()
  {
    super.initState();
    isUnderMaint();
  }

  Future<void> isUnderMaint() async
  {
      isUnderMaintenance = await underMaintenanceScreen.isUnderMaintenance();
  }


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
                        color: Colors.white,
                      ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }
          else if(isUnderMaintenance)
            {
              return FutureBuilder(
                  future: isUnderMaint(),
                builder: (context, snapshot)
              {
                return UnderMaintenanceScreen();
              }
              );}
          else {
            // Return your original Scaffold if the internet connection is not disconnected
            return Scaffold(
              backgroundColor: Colors.white,
              body: SafeArea(
                child: Padding(
                  padding: EdgeInsets.only(top: 10),
                  child: Column(

                    children: [
                      Row(
                        children: [
                         /* SizedBox(
                            width: screenWidth/3,
                            child: Align(
                                child: TOWLogoAnimation(fontSize: screenWidth/22)),
                          ),
                          */
                          const Spacer(),
                          const LocationSelector(),
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
              ),
            );
          }
        },
      ),
    );
  }


}