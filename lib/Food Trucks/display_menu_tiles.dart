import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:thingsonwheels/Reusable%20Widgets/add_more_menu_items_button.dart';
import 'package:thingsonwheels/main.dart';
import '../CheckOut/checkout_state.dart';
import '../Merchant Sign Up/merchant_structure.dart';

class DisplayMenuTiles extends StatefulWidget {
  final MenuItem menuItem;

  const DisplayMenuTiles({super.key, required this.menuItem});

  @override
  State<DisplayMenuTiles> createState() => _DisplayMenuTilesState();
}

class _DisplayMenuTilesState extends State<DisplayMenuTiles> {
  late CheckoutState checkoutState;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    checkoutState = context.watch<CheckoutState>();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.menuItem.itemName,
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: screenWidth / 20,
                    color: const Color(
                      0xFF505050,
                    )),
              ),
              Text(
                widget.menuItem.description,
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(fontSize: screenWidth / 28),
              )
            ],
          ),
        ),
        const SizedBox(
          width: 20,
        ),
        Stack(
          clipBehavior: Clip.none, // Allow overflow
          alignment: Alignment.bottomCenter,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(15),
              child: CachedNetworkImage(
                imageUrl: widget.menuItem.itemImage,
                fit: BoxFit.cover,
                width: screenWidth / 2.5,
                height: screenWidth /
                    3.2, // Changed to cover to ensure it fills the area
              ),
            ),
            checkoutState.itemsWithQuantity[widget.menuItem] != null
                ? Positioned(
                    bottom: -20,
                    child: AddMoreMenuItemsButton(
                      amountTextSize: screenWidth/25,
                      menuItem: widget.menuItem,
                      width: screenWidth / 3.5,
                      height: screenWidth / 10.5, buttonColor: Colors.red, iconsColor: Colors.white, borderColor: Colors.red,
                    ))
                : Positioned(bottom: -20, child: _initialAddItemButton())
          ],
        ),
      ],
    );
  }

  Widget _initialAddItemButton() {
    return GestureDetector(
      onTap: () {
        checkoutState.addItem(widget.menuItem);
      },
      child: Container(
        width: screenWidth / 3.5, // Adjust size as needed
        height: screenWidth / 10.5, // Adjust height if needed
        decoration: BoxDecoration(
          color: const Color(0xFFFFF8F8), // Background color
          borderRadius: BorderRadius.circular(8), // Border radius of 8
          border: Border.all(
            color: Colors.red, // Border color
            width: 1, // Border width
          ),
        ),
        child: Stack(
          children: [
            // "Add" text centered
            Center(
              child: Text(
                'Add',
                style: TextStyle(
                  fontSize: screenWidth / 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.red, // Text color
                ),
              ),
            ),
            // Plus icon at the top right
            Positioned(
              top: 4,
              right: 4,
              child: Icon(
                Icons.add,
                size: screenWidth / 30,
                color: Colors.red, // Icon color
              ),
            ),
          ],
        ),
      ),
    );
  }
}
