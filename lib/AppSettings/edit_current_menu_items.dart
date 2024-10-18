import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:thingsonwheels/IconFiles/app_icons_icons.dart';
import 'package:thingsonwheels/Reusable%20Widgets/add_menu_items_pop_up.dart';
import 'package:thingsonwheels/Reusable%20Widgets/menu_item_tiles.dart';
import '../Merchant Sign Up/merchant_structure.dart';
import '../main.dart';

class EditCurrentMenuItems extends StatefulWidget {
  const EditCurrentMenuItems({super.key, required this.menuItems});

  final List<MenuItem> menuItems;

  @override
  EditCurrentMenuItemState createState() => EditCurrentMenuItemState();
}

class EditCurrentMenuItemState extends State<EditCurrentMenuItems> {
  @override
  Widget build(BuildContext context) {

   var merchantStructure = Provider.of<MerchantStructure>(context);
   var menuItem = Provider.of<MenuItem>(context);
   AddMenuItemsPopUp addMenuItemsPopUp = AddMenuItemsPopUp();

    return PopScope(
      canPop: Platform.isIOS ? false : true,
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(screenWidth / 6),
          child: AppBar(
              automaticallyImplyLeading: false, // Hide default back arrow
              backgroundColor: Colors.red, // AppBar background color
              elevation: 0, // Remove shadow
              flexibleSpace: SafeArea(
                child: Padding(
                  padding: const EdgeInsets.only(top: 15),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      IconButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        icon: Icon(
                          AppIcons.keyboard_backspace,
                          color: Colors.white,
                          size: screenWidth / 25,
                        ),
                      ),
                      Text(
                        "Edit menu items",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: screenWidth / 20,
                        ),
                      ),
                      // IconButton aligned to the right
                      IconButton(
                          onPressed: () {
                          menuItem.itemImage = '';
                          addMenuItemsPopUp.addMenuItemInformationWidget(context);
                          },
                          icon: Icon(
                            Icons.add,
                            color: Colors.white,
                            size: screenWidth / 15,
                          )),
                    ],
                  ),
                ),
              )),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Column(
              children: [
                const SizedBox(
                  height: 30,
                ),
                for (int i = 0; i <merchantStructure.menuItems.length; i++) ...[
                  MenuItemTiles(
                      menuItem: merchantStructure.menuItems[i], isMoreVert: true, index: i)
                ]
              ],
            ),
          ),
        ),
      ),
    );
  }
}
