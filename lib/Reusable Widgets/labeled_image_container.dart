import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:icons_flutter/icons_flutter.dart';
import 'package:provider/provider.dart';
import 'package:thingsonwheels/Merchant%20Sign%20Up/merchant_structure.dart';
import 'package:thingsonwheels/Reusable%20Widgets/divider_with_text_in_middle.dart';
import 'package:thingsonwheels/main.dart';

class LabeledImageContainer extends StatelessWidget {
  final String labelText;
  final String button1Text;
  final String button2Text;
  final VoidCallback onButton1Pressed;
  final VoidCallback onButton2Pressed;

  const LabeledImageContainer({
    Key? key,
    required this.labelText,
    required this.button1Text,
    required this.button2Text,
    required this.onButton1Pressed,
    required this.onButton2Pressed,
  }) : super(key: key);


  @override
  Widget build(BuildContext context) {
    final MenuItem menuItem = Provider.of<MenuItem>(context);
    final MerchantStructure merchantStructure =
        Provider.of<MerchantStructure>(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 10.0),
          child: Text(
            labelText,
            style: TextStyle(
              fontSize: screenWidth / 27,
              // No background color applied here
            ),
          ),
        ),
        Container(
            padding: EdgeInsets.only(top: screenWidth / 20),
            width: double.infinity,
            height: screenHeight / 5,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey.shade300, width: 1.0),
              borderRadius: BorderRadius.circular(5.0),
            ),
            child: menuItem.itemImage.isNotEmpty
                ? menuItemImageDisplay(context, menuItem, merchantStructure)
                : imageOrGalleryMenuItemSelection()),
      ],
    );
  }

  Widget imageOrGalleryMenuItemSelection() {
    return Column(
      children: [
        ElevatedButton.icon(
          onPressed: onButton1Pressed,
          icon: const Icon(Icons.camera_outlined),
          label: Text(
            button1Text,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          style: ElevatedButton.styleFrom(
            foregroundColor: Colors.red,
            backgroundColor: Colors.white,
            // Text color
            side: const BorderSide(color: Colors.red),
            shape: RoundedRectangleBorder(
              borderRadius:
                  BorderRadius.circular(8.0), // Circular border radius
            ),
          ),
        ),
        const SizedBox(
          height: 5,
        ),
        DividerWithTextInMiddle(
          textInBetween: "OR",
          textSize: screenWidth / 30,
        ),
        const SizedBox(
          height: 5,
        ),
        ElevatedButton.icon(
          onPressed: onButton2Pressed,
          icon: const Icon(Icons.browse_gallery_outlined), // File icon
          label: Text(
            button2Text,
            style: const TextStyle(
              fontWeight: FontWeight.bold, // Set font weight to bold
            ),
          ),
          style: ElevatedButton.styleFrom(
            foregroundColor: Colors.red,
            backgroundColor: Colors.white,
            // Text color
            side: const BorderSide(color: Colors.red), // Border color
            shape: RoundedRectangleBorder(
              borderRadius:
                  BorderRadius.circular(8.0), // Circular border radius
            ),
          ),
        )
      ],
    );
  }

  Widget menuItemImageDisplay(BuildContext context, MenuItem menuItemProvider,
      MerchantStructure merchantProvider) {
    bool isUrl = MerchantStructure.isImageUrl(menuItemProvider.itemImage);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10),
      child: Stack(alignment: Alignment.center, children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(8.0),
          child: isUrl
              ? CachedNetworkImage(
                  imageUrl: menuItemProvider.itemImage,
                  fit: BoxFit.contain,
                )
              : Image.asset(
                  menuItemProvider.itemImage,
                  fit: BoxFit.contain,
                ),
        ),
        Positioned(
          top: 0,
          right: 10,
          child: CircleAvatar(
            radius: screenWidth / 30,
            backgroundColor: const Color(0xFFD9D9D9),
            child: IconButton(
                icon: const Icon(
                  WebSymbols.cancel,
                  color: Colors.black,
                  size: 10,
                ),
                onPressed: () {
                  menuItemProvider.itemImage = '';
                }),
          ),
        ),
      ]),
    );
  }
}
