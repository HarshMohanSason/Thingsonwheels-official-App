import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:thingsonwheels/Merchant%20Sign%20Up/merchant_structure.dart';
import 'package:thingsonwheels/Reusable%20Widgets/add_menu_items_pop_up.dart';
import 'package:thingsonwheels/Reusable%20Widgets/menu_item_tiles.dart';
import '../main.dart';

class AddMenuItems extends StatefulWidget {
  const AddMenuItems({
    super.key,
  });

  @override
  AddMenuItemsState createState() => AddMenuItemsState();
}

class AddMenuItemsState extends State<AddMenuItems> {
  late MerchantStructure merchantStructureProvider;
  late MenuItem menuItemProvider;
  AddMenuItemsPopUp addMenuItemsPopUp = AddMenuItemsPopUp();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    merchantStructureProvider = context.watch<MerchantStructure>();
    menuItemProvider = context.watch<MenuItem>();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: screenWidth,
          child: Row(
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 10, right: 10),
                child: Text(
                  "Add Menu Items",
                  style: TextStyle(
                      color: const Color(0xFF505050),
                      fontSize: screenWidth / 15,
                      fontWeight: FontWeight.bold),
                ),
              ),
              const Spacer(),
              GestureDetector(
                onTap: () async {
                  if (menuItemProvider.itemImage.isNotEmpty) {
                    menuItemProvider.itemImage =
                        ''; //make sure the image section is empty when adding a new image
                  }
                  addMenuItemsPopUp.addMenuItemInformationWidget(context);
                },
                child: CircleAvatar(
                  backgroundColor: Colors.red,
                  radius: screenWidth / 13,
                  child: Icon(Icons.add,
                      color: Colors.white, size: screenWidth / 10),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(
          height: 50,
        ),
        Padding(
          padding: const EdgeInsets.only(left: 10, right: 10),
          child: Text(
            "A well-crafted menu speaks volumes! Add enticing photos and detailed menu items to attract more customers and showcase the uniqueness of your offerings",
            style: TextStyle(
              color: Colors.black,
              fontSize: screenWidth / 28,
            ),
          ),
        ),
        const SizedBox(
          height: 30,
        ),
        //Not using a ListViewBuilder because it causes pixel overflow issues, scroll issues and is a bit slower
        Column(
          children: [
            for (int i = 0; i < merchantStructureProvider.menuItems.length; i++)
              MenuItemTiles(
                  menuItem: merchantStructureProvider.menuItems[i],
                  isMoreVert: true,
                  index: i)
          ],
        ),
      ],
    );
  }
}
