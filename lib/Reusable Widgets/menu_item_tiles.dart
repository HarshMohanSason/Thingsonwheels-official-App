import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:thingsonwheels/Reusable%20Widgets/add_menu_items_pop_up.dart';
import '../Merchant Sign Up/merchant_structure.dart';
import '../main.dart';

class MenuItemTiles extends StatelessWidget {
  final MenuItem menuItem;
  final bool isMoreVert;
  final int index;


  const MenuItemTiles(
      {super.key,
      required this.menuItem,
      required this.isMoreVert,
      required this.index});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      margin: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8.0),
            child: MerchantStructure.isImageUrl(menuItem.itemImage)
                ? CachedNetworkImage(
                    imageUrl: menuItem.itemImage,
                    width: screenWidth / 3.9,
                    height: screenWidth / 5.02,
                    fit: BoxFit.cover,
                  )
                : Image.asset(
                    width: screenWidth / 3.9,
                    height: screenWidth / 5.02,
                    menuItem.itemImage,
                    fit: BoxFit.cover,
                  ),
          ),
          const SizedBox(width: 10.0),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  menuItem.itemName,
                  style: TextStyle(
                    color: const Color(0xFF505050),
                    fontSize: screenWidth / 30,
                    fontWeight: FontWeight.bold,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  menuItem.description,
                  style: const TextStyle(
                    color: Color(0xFFCFCFCF),
                    fontSize: 12,
                  ),
                  overflow: TextOverflow.ellipsis,
                  // Adds '...' if the text overflows
                  maxLines: 1, // Limits it to a single line
                ),
                const SizedBox(height: 5.0), // Space between name and price
                Text(
                  '\$${menuItem.price.toStringAsFixed(2)}',
                  style: TextStyle(
                    fontSize: screenWidth / 29,
                    color: const Color(0xFF4D4D4D),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          isMoreVert
              ? moreVertOption(context, menuItem, index)
              : Container() // Three dots icon in the top right corner
        ],
      ),
    );
  }

  Widget moreVertOption(
    BuildContext context,
    MenuItem item,
    int index,
  ) {
    AddMenuItemsPopUp addMenuItemsPopUp = AddMenuItemsPopUp();
    final menuItemProvider = Provider.of<MenuItem>(context, listen: false);
    final merchantStructureProvider = Provider.of<MerchantStructure>(context, listen: false);

    return PopupMenuButton<String>(
      icon: const Icon(
        Icons.more_vert,
        color: Colors.black,
      ),
      onSelected: (String result) {
        if (result == 'edit') {
          menuItemProvider.itemImage = merchantStructureProvider.menuItems[index].itemImage;
          addMenuItemsPopUp.addMenuItemInformationWidget(context, menuItem: item, index: index);
        } else if (result == 'delete') {
          merchantStructureProvider.removeMenuItem(index);
        }
      },
      itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
        PopupMenuItem<String>(
          value: 'edit',
          child: Row(
            children: [
              Icon(Icons.edit_outlined, size: screenWidth / 25),
              const SizedBox(
                width: 10,
              ),
              Text(
                "Edit",
                style: TextStyle(fontSize: screenWidth / 28),
              )
            ],
          ),
        ),
        PopupMenuItem<String>(
          value: 'delete',
          child: Row(
            children: [
              Icon(Icons.delete_outline, size: screenWidth / 25),
              const SizedBox(
                width: 10,
              ),
              Text(
                "Delete",
                style: TextStyle(
                  fontSize: screenWidth / 28,
                ),
              )
            ],
          ),
        ),
      ],
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
      // Optional: Add border radius
      color: Colors.white, //
    );
  }
}
