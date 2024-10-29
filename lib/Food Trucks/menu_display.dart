import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:thingsonwheels/CheckOut/view_cart.dart';
import 'package:thingsonwheels/Food%20Trucks/display_menu_tiles.dart';
import 'package:thingsonwheels/Food%20Trucks/food_truck_structure.dart';
import 'package:thingsonwheels/Food%20Trucks/is_live_button.dart';
import 'package:thingsonwheels/IconFiles/app_icons_icons.dart';
import 'package:thingsonwheels/Reusable%20Widgets/custom_search_bar.dart';
import 'package:thingsonwheels/Reusable%20Widgets/display_rating.dart';
import 'package:thingsonwheels/Social%20Media/social_media_post_structure.dart';
import '../CheckOut/checkout_state.dart';
import '../main.dart';

class MenuDisplay extends StatefulWidget {
  const MenuDisplay({super.key, required this.foodTruckStructure});

  final FoodTruckStructure foodTruckStructure;

  @override
  MenuDisplayState createState() => MenuDisplayState();
}

class MenuDisplayState extends State<MenuDisplay> {
  @override
  Widget build(BuildContext context) {
    final checkOutState = Provider.of<CheckoutState>(context);
    return PopScope(
      canPop: Platform.isIOS ? false : true,
      child: Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
              automaticallyImplyLeading: false, // Hide default back arrow
              backgroundColor: Colors.white, // AppBar background color
              elevation: 0, // Remove shadow
              flexibleSpace: SafeArea(
                  child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: Icon(
                        AppIcons.keyboard_backspace,
                        color: Colors.black,
                        size: screenWidth / 25,
                      ))
                ],
              ))),
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: SizedBox(
                          width: screenWidth / 4.5,
                          child: IsLiveButton(
                              docID: widget.foodTruckStructure.docID)),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          widget.foodTruckStructure.foodTruckName,
                          style: TextStyle(
                              fontSize: screenWidth / 18,
                              fontWeight: FontWeight.bold,
                              color: const Color(0xFF505050)),
                        ),
                        Column(
                          children: [
                            DisplayRating(
                                currentRating:
                                    widget.foodTruckStructure.currentRating),
                            const SizedBox(
                              height: 3,
                            ),
                            Text(
                              SocialMediaPostStructure.formatWithCount(
                                  widget.foodTruckStructure.ratings.length,
                                  'rating'),
                              style: TextStyle(
                                  fontSize: screenWidth / 40,
                                  color: const Color(0xFF969696)),
                            ),
                          ],
                        )
                      ],
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    Stack(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 50),
                          child: ListView.builder(
                            itemCount:
                                widget.foodTruckStructure.menuItems.length,
                            primary: false,
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemBuilder: (context, index) {
                              return Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 20),
                                child: DisplayMenuTiles(
                                  menuItem: widget
                                      .foodTruckStructure.menuItems[index],
                                ),
                              );
                            },
                          ),
                        ),
                        CustomSearchBar(
                          menuItems: widget.foodTruckStructure.menuItems,
                        ),
                      ],
                    )
                  ]),
            ),
          ),
          bottomSheet: checkOutState.totalPrice > 0.0
              ? Container(
                  padding: const EdgeInsets.all(15),
                  color: Colors.red,
                  height: screenWidth / 4,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Column(children: [
                        Text(
                          '${SocialMediaPostStructure.formatWithCount(checkOutState.totalQuantity, 'Item')} added',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: screenWidth / 25,
                              fontWeight: FontWeight.bold),
                        ),
                        Text(
                          "Total: \$${checkOutState.totalPrice}",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: screenWidth / 25,
                              fontWeight: FontWeight.bold),
                        )
                      ]),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const ViewCart()));
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              Icons.shopping_cart_outlined,
                              color: Colors.red,
                              size: screenWidth / 16,
                            ),
                            const SizedBox(
                              width: 5,
                            ),
                            Text('View Cart',
                                style: TextStyle(
                                    fontSize: screenWidth / 28,
                                    color: Colors.red,
                                    fontWeight: FontWeight.bold)),
                          ],
                        ),
                      )
                    ],
                  ),
                )
              : null),
    );
  }
}
