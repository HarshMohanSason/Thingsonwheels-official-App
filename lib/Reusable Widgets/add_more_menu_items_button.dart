import 'package:flutter/material.dart';
import 'package:icons_flutter/icons_flutter.dart';
import 'package:provider/provider.dart';
import 'package:thingsonwheels/CheckOut/checkout_state.dart';
import '../Merchant Sign Up/merchant_structure.dart';

class AddMoreMenuItemsButton extends StatelessWidget {
  final MenuItem menuItem;
  final double height;
  final double width;
  final double amountTextSize;
  final Color buttonColor;
  final Color iconsColor;
  final Color borderColor;

  const AddMoreMenuItemsButton(
      {super.key,
      required this.menuItem,
      required this.height,
      required this.width,
      required this.amountTextSize,
      required this.buttonColor,
      required this.iconsColor,
      required this.borderColor});

  @override
  Widget build(BuildContext context) {
    final checkoutState = Provider.of<CheckoutState>(context);
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: buttonColor,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: borderColor, // Border color
          width: 1, // Border width
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center, // Center vertically
          children: [
            InkWell(
              onTap: () {
                checkoutState.removeItem(menuItem);
              },
              child: Icon(
                FontAwesome.minus,
                color: iconsColor,
                size: 11, // Increase icon size for better visibility
              ),
            ),
            const Spacer(),
            Text(
              checkoutState.itemsWithQuantity[menuItem].toString(),
              style: TextStyle(
                color: iconsColor,
                fontSize: amountTextSize,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Spacer(),
            InkWell(
              onTap: () {
                checkoutState.addItem(menuItem);
              },
              child: Icon(
                FontAwesome.plus,
                color: iconsColor,
                size: 11, // Increase icon size for better visibility
              ),
            ),
          ],
        ),
      ),
    );
  }
}
