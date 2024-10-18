import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:thingsonwheels/Food%20Trucks/food_truck_structure.dart';
import 'package:thingsonwheels/Merchant%20Sign%20Up/merchant_structure.dart';
import 'package:thingsonwheels/Reusable%20Widgets/menu_item_tiles.dart';
import 'package:thingsonwheels/main.dart';

import 'edit_current_menu_items.dart';

class AppSettingsHome extends StatefulWidget {
  const AppSettingsHome({super.key});

  @override
  AppSettingsHomeState createState() => AppSettingsHomeState();
}

class AppSettingsHomeState extends State<AppSettingsHome> {
   FoodTruckStructure? currentUserInfo;

  @override
  void initState() {
    super.initState();
    initFuture();
  }

  Future initFuture() async {
    currentUserInfo = await FoodTruckStructure.getFoodTruckOwnerInfo(FirebaseAuth.instance.currentUser!.uid);
    setState(() {}); // Update the UI after loading
  }

  @override
  Widget build(BuildContext context) {
    var merchantStructureProvider = Provider.of<MerchantStructure>(context);
    return SafeArea(
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.max,
                children: [
                  CircleAvatar(
                    radius: screenWidth / 7,
                    backgroundImage: CachedNetworkImageProvider(
                      FirebaseAuth.instance.currentUser!.photoURL!,
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(top: 20, left: 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(FirebaseAuth.instance.currentUser!.displayName!,
                              style: TextStyle(
                                  fontSize: screenWidth / 21.6,
                                  color: const Color(0xFF505050),
                                  fontWeight: FontWeight.bold),
                              softWrap: false,
                              overflow: TextOverflow.ellipsis),
                          // Add ellipsis i),
                          // Text(FirebaseAuth.instance.currentUser!.email.toString())
                        ],
                      ),
                    ),
                  )
                ],
              ),
              const Divider(
                thickness: 1,
                color: Color(0xFFECECEC),
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                mainAxisSize: MainAxisSize.max,
                children: [
                  Text(
                    "FoodTruck live status",
                    style: TextStyle(fontSize: screenWidth / 23),
                  ),
                  StreamBuilder<bool>(
                    stream: FoodTruckStructure.getIsLiveStatus(
                        FirebaseAuth.instance.currentUser!.uid), // Stream<bool>
                    builder: (context, snapshot) {
                      var isToggled =
                          snapshot.data ?? false; // Default to false if null
                      return IconButton(
                        icon: Icon(
                          isToggled ? Icons.toggle_on : Icons.toggle_off,
                          color: isToggled ? Colors.green : Colors.grey,
                          size: screenWidth / 9,
                        ),
                        onPressed: () {
                          setState(() {
                            isToggled = !isToggled;
                            MerchantStructure.goLive(
                                FirebaseAuth.instance.currentUser!.uid,
                                isToggled);
                          });
                        },
                      );
                    },
                  ),
                ],
              ),
              const Divider(
                thickness: 1,
                color: Color(0xFFECECEC),
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                mainAxisSize: MainAxisSize.max,
                children: [
                  Text(
                    "Profile Images",
                    style: TextStyle(fontSize: screenWidth / 25),
                  ),
                  IconButton(
                    icon: Icon(
                      Icons.edit,
                      color: const Color(0xFF4D4D4D),
                      size: screenWidth / 20,
                    ),
                    onPressed: () {
                     // Navigator.push(context, MaterialPageRoute(builder: (context)=> EditCurrentMenuItems(menuItems: currentUserInfo!.menuItems,)));
                    },
                  )
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              Wrap(
                spacing: 10.0, // Space between the images
                runSpacing: 10.0, // Space between rows
                children: [
                  for (int i = 0;
                      i < currentUserInfo!.tileImages.length;
                      i++) ...[
                    createImageDisplay(i),

                  ],
                ],
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                mainAxisSize: MainAxisSize.max,
                children: [
                  Text(
                    "Menu",
                    style: TextStyle(fontSize: screenWidth / 25),
                  ),
                  IconButton(
                    icon: Icon(
                      Icons.edit,
                      color: const Color(0xFF4D4D4D),
                      size: screenWidth / 20,
                    ),
                    onPressed: () {
                      merchantStructureProvider.setMenuItemImagesForEditing(currentUserInfo!.menuItems);
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => EditCurrentMenuItems(
                                    menuItems: currentUserInfo!.menuItems,
                                  )));
                    },
                  )
                ],
              ),
              for (int i = 0; i < 2; i++) ...[
                    MenuItemTiles(
                    menuItem: currentUserInfo!.menuItems[i],
                    isMoreVert: false,
                    index: i),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget createImageDisplay(int index) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: CachedNetworkImage(
          width: screenWidth / 3.5,
          height: screenWidth / 4,
          fit: BoxFit.cover,
          imageUrl: currentUserInfo!.tileImages[index]!),
    );
  }
}
