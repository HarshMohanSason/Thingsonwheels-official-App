import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:icons_flutter/icons_flutter.dart';
import 'package:provider/provider.dart';
import 'package:thingsonwheels/CheckOut/checkout_state.dart';
import 'package:thingsonwheels/CheckOut/payment_confirmation.dart';
import 'package:thingsonwheels/CheckOut/view_detailed_bill.dart';
import 'package:thingsonwheels/Merchant%20Sign%20Up/merchant_structure.dart';
import 'package:thingsonwheels/Reusable%20Widgets/add_more_menu_items_button.dart';
import 'package:thingsonwheels/Reusable%20Widgets/create_a_button.dart';
import 'package:thingsonwheels/main.dart';

import '../IconFiles/app_icons_icons.dart';

class ViewCart extends StatefulWidget {
  const ViewCart({super.key});

  @override
  State<StatefulWidget> createState() => _ViewCartState();
}

class _ViewCartState extends State<ViewCart> {
  late CheckoutState checkOutState;

  @override
  void didChangeDependencies() {
    checkOutState = context.watch<CheckoutState>();
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: Platform.isIOS ? false : true,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: PreferredSize(
            preferredSize: Size.fromHeight(screenWidth / 5),
            child: AppBar(
                automaticallyImplyLeading: false, // Hide default back arrow
                backgroundColor: Colors.red, // AppBar background color
                elevation: 0, // Remove shadow
                flexibleSpace: SafeArea(
                  child: Padding(
                    padding: EdgeInsets.only(top: screenWidth / 14),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        IconButton(
                            onPressed: () => Navigator.pop(context),
                            icon: Icon(
                              AppIcons.keyboard_backspace,
                              size: screenWidth / 23,
                              color: Colors.white,
                            )),
                        const Spacer(),
                        Text(
                          "Your cart",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: screenWidth / 18,
                          ),
                        ),
                        const Spacer(),
                      ],
                    ),
                  ),
                ))),
        body: SingleChildScrollView(
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Review Cart",
                    style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: screenWidth / 23,
                        color: const Color(0xFF282C3F)),
                  ),
                  ListView.builder(
                      itemCount: checkOutState.itemsWithQuantity.length,
                      primary: false,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemBuilder: (BuildContext context, int index) {
                        final itemsWithQuantity =
                            checkOutState.itemsWithQuantity.entries.toList();

                        final menuItem = itemsWithQuantity[index].key;
                        final quantity = itemsWithQuantity[index].value;

                        // Return the card widget for each item
                        return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 5),
                            child: checkOutTile(context, menuItem, quantity));
                      })
                ],
              ),
            ),
          ),
        ),
        bottomSheet: Container(
          height: screenWidth / 2.5,
          color: Colors.white,
          child: Column(
            children: [
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                height: screenWidth / 10,
                color: const Color(0xFFE0FDE5),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "To Pay : \$${checkOutState.totalPrice}",
                      style: TextStyle(
                          color: const Color(0xFF059526),
                          fontWeight: FontWeight.bold,
                          fontSize: screenWidth / 28),
                    ),
                    GestureDetector(
                      onTap: () {
                        _showDetailedBill(context);
                      },
                      child: Row(
                        children: [
                          Text(
                            "View Detailed Bill",
                            style: TextStyle(
                                color: Colors.red,
                                fontWeight: FontWeight.bold,
                                fontSize: screenWidth / 28),
                          ),
                          const Icon(
                            Icons.arrow_right,
                            color: Colors.red,
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: screenWidth / 10),
              Stack(
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  const PaymentConfirmation()));
                    },
                    child: CreateAButton(
                      width: screenWidth - 40,
                      height: screenWidth / 9,
                      buttonColor: Colors.red,
                      textSize: screenWidth / 25,
                      buttonText: "Proceed to Pay",
                      textColor: Colors.white,
                      borderRadius: 30,
                      icon: LineariconsFree.arrow_right,
                      iconSize: screenWidth / 20,
                      iconColor: Colors.white,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget checkOutTile(BuildContext context, MenuItem menuItem, int quantity) {
    return Card(
      color: Colors.white,
      child: Row(
        children: [
          ClipRRect(
              borderRadius: BorderRadius.circular(8.0),
              child: CachedNetworkImage(
                imageUrl: menuItem.itemImage,
                width: screenWidth / 3.9,
                height: screenWidth / 5.02,
                fit: BoxFit.cover,
              )),
          const SizedBox(width: 10.0),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  menuItem.itemName,
                  style: TextStyle(
                    color: const Color(0xFF505050),
                    fontSize: screenWidth / 27,
                    fontWeight: FontWeight.bold,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 5.0),
                AddMoreMenuItemsButton(
                  amountTextSize: 16,
                  menuItem: menuItem,
                  height: screenWidth / 11,
                  width: screenWidth / 4,
                  buttonColor: Colors.white,
                  iconsColor: Colors.red,
                  borderColor: Colors.red,
                ) // Space between name and price
              ],
            ),
          ),
          Padding(
              padding: const EdgeInsets.only(right: 10),
              child: Text(
                "\$${quantity * menuItem.price}",
                style: TextStyle(
                    color: const Color(0xFF4D4D4D),
                    fontSize: screenWidth / 25,
                    fontWeight: FontWeight.bold),
              ))
          // Three dots icon in the top right corner
        ],
      ),
    );
  }

  // Function to show the Bottom Sheet
  void _showDetailedBill(BuildContext context) {
    showModalBottomSheet(
      backgroundColor: Colors.white,
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(40)),
      ),
      isScrollControlled: true, // Allow full-screen height if needed
      builder: (context) {
        return DraggableScrollableSheet(
          initialChildSize: 0.4, // Sheet starts at 40% height
          minChildSize: 0.2, // Minimum size the sheet can shrink to
          maxChildSize: 0.8, // Maximum size the sheet can expand to
          builder: (context, scrollController) {
            return Container(
              color: Colors.white,
              padding: const EdgeInsets.all(20),
              child: ListView(
                controller: scrollController,
                children: [
                  ListTile(
                    leading: Icon(Icons.receipt),
                    title: Text('Total Amount: \$${checkOutState.totalPrice}'),
                  ),
                  ListTile(
                    leading: Icon(Icons.payment),
                    title: Text('Payment Method: Credit Card'),
                  ),
                  ListTile(
                    leading: Icon(Icons.info),
                    title: Text('Payment Status: Completed'),
                  ),
                  ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Close'),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
