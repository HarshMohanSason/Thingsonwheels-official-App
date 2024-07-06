import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:thingsonwheels/AppSettings/app_settings_ui.dart';
import 'package:thingsonwheels/TowDisplay/tow_tile_ui.dart';
import 'package:thingsonwheels/Location/location_selector.dart';
import 'package:thingsonwheels/ResuableWidgets/under_maintenance_ui.dart';
import 'package:thingsonwheels/ResuableWidgets/internet_provider.dart';
import 'package:thingsonwheels/main.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  HomeScreenState createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> {
  final UnderMaintenanceScreen underMaintenanceScreen = const UnderMaintenanceScreen();
  late InternetProvider internetProvider;

  @override
  void initState() {
    super.initState();
    internetProvider = InternetProvider();
    internetProvider.checkInternetConnection(); // Check initial connection
  }

  @override
  void dispose() {
    internetProvider.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: StreamBuilder<ConnectionStatus>(
        stream: internetProvider.connectionStatusStream,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(
                color: Colors.black,
                strokeWidth: 4,
              ),
            );
          } else if (snapshot.data == ConnectionStatus.disconnected) {
            return Scaffold(
              backgroundColor: Colors.white,
              body: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'No internet connection'.tr(),
                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    InkWell(
                      onTap: () {
                        internetProvider.retryInternetConnection();
                      },
                      child: Icon(Icons.refresh, color: colorTheme, size: 30),
                    ),
                    const SizedBox(width: 8),
                  ],
                ),
              ),
            );
          } else {
            return StreamBuilder<bool>(
              stream: underMaintenanceScreen.isUnderMaintenance(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(
                      color: Colors.black,
                      strokeWidth: 7,
                    ),
                  );
                } else if (snapshot.hasError) {
                  return Center(
                    child: Text('Error: ${snapshot.error}'),
                  );
                } else if (snapshot.hasData && snapshot.data == true) {
                  return const UnderMaintenanceScreen();
                } else {
                  return Scaffold(
                    backgroundColor: Colors.white,
                    body: SafeArea(
                      child: Stack( // Use a Stack for layering
                        children: [
                          Positioned.fill(
                            child: Opacity(
                              opacity: 0.08, // Adjust opacity as needed
                              child: Image.asset(
                                'assets/images/launch_screen.png', // Replace with your image path
                                fit: BoxFit.contain
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 10),
                            child: Column(
                              children: [
                                Row(
                                  children: [
                                    const Spacer(),
                                    const LocationSelector(),
                                    const Spacer(),
                                    InkWell(
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => const AppSettings(),
                                          ),
                                        );
                                      },
                                      child: Icon(
                                        Icons.settings,
                                        size: MediaQuery.of(context).size.width / 14,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 20),
                                const Expanded(child: TowTileUI()),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }
              },
            );
          }
        },
      ),
    );
  }
}
