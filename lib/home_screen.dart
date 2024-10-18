import 'package:flutter/material.dart';
import 'package:thingsonwheels/AppSettings/app_settings_app_bar.dart';
import 'package:thingsonwheels/AppSettings/app_settings_home.dart';
import 'package:thingsonwheels/Food%20Trucks/food_truck_home_screen.dart';
import 'package:thingsonwheels/Reusable%20Widgets/home_screen_app_bar.dart';
import 'package:thingsonwheels/Social%20Media/social_media_home_screen.dart';
import 'package:thingsonwheels/main.dart';
import 'IconFiles/app_icons_icons.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  HomeScreenState createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;
  static List<Widget> screens = [
    const HomeScreen(),
    const SocialMediaHomeScreen(),
    const AppSettingsHome()
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
        canPop: false,
        child: Scaffold(
          appBar: PreferredSize(
              preferredSize: Size.fromHeight(screenWidth / 5),
              child: _selectedIndex > 1
                  ? const AppSettingsAppBar()
                  : const HomeScreenAppBar()),
          backgroundColor: Colors.grey.shade50,
          body: IndexedStack(
            index: _selectedIndex,
            children: const [
              SingleChildScrollView(child: FoodTruckHomeScreen()),
              SocialMediaHomeScreen(),
              AppSettingsHome()
            ],
          ),
          bottomNavigationBar: BottomNavigationBar(
            type: BottomNavigationBarType.fixed,
            // To fix more than 3 items
            currentIndex: _selectedIndex,
            selectedItemColor: Colors.red,
            unselectedItemColor: Colors.black,
            // Currently selected index
            onTap: _onItemTapped,

            // Handle taps
            items: <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                icon: Icon(
                  AppIcons.home_1,
                  size: screenWidth / 18,
                ),
                label: '',
              ),
              BottomNavigationBarItem(
                  icon: Icon(AppIcons.reels, size: screenWidth / 16),
                  label: ''),
              BottomNavigationBarItem(
                icon: Icon(Icons.person_outlined, size: screenWidth / 15),
                label: '',
              ),
            ],
          ),
        ));
  }
}
