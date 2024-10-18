import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:thingsonwheels/Reusable%20Widgets/text_form_validators.dart';
import 'package:thingsonwheels/Reusable%20Widgets/toast_widget.dart';
import '../Image Upload/camera_ui.dart';
import '../Image Upload/image_upload_helper.dart';
import '../Merchant Sign Up/merchant_structure.dart';
import '../main.dart';
import 'create_a_button.dart';
import 'custom_text_form.dart';
import 'labeled_image_container.dart';

class AddMenuItemsPopUp {
  AddMenuItemsPopUp();

  final GlobalKey<FormState> merchantMenuItem =GlobalKey<FormState>();

  Future<dynamic> addMenuItemInformationWidget(BuildContext context,
      {MenuItem? menuItem, int? index}) {
    final menuItemProvider = Provider.of<MenuItem>(context, listen: false);
    final merchantStructureProvider = Provider.of<MerchantStructure>(context, listen: false);
    return showDialog(
      context: context,
      barrierDismissible: false, // Prevent closing by tapping outside
      builder: (context) {
        return Form(
          key: merchantMenuItem,
          child: Dialog(
            backgroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const SizedBox(height: 15), // Spacing below close icon
                    Row(
                      children: [
                        Text(
                          'Add a new item',
                          style: TextStyle(
                            fontSize: screenWidth / 19,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const Spacer(),
                        IconButton(
                          icon: const Icon(Icons.close, color: Colors.black),
                          onPressed: () => Navigator.pop(context),
                        ),
                      ],
                    ),

                    const SizedBox(height: 20),
                    CustomTextForms(
                        initialValue: menuItem?.itemName,
                        keyBoardType: TextInputType.name,
                        labelText: 'Name of the Dish',
                        hintText: 'Tamales',
                        hideText: false,
                        validator: TextFormValidators.validateMenuItemName,
                        onSaved: (value) => menuItemProvider.itemName = value!),
                    const SizedBox(height: 20),
                    CustomTextForms(
                        initialValue: menuItem?.description,
                        keyBoardType: TextInputType.text,
                        maxLines: 4,
                        labelText: 'Description',
                        hintText: 'A short description of your dish',
                        hideText: false,
                        validator: TextFormValidators.validateItemDescription,
                        onSaved: (value) =>
                            menuItemProvider.description = value!),
                    const SizedBox(height: 20),
                    CustomTextForms(
                        initialValue: menuItem?.price.toString(),
                        labelText: 'Price',
                        hintText: '\$0.00',
                        hideText: false,
                        keyBoardType: const TextInputType.numberWithOptions(
                            decimal: true),
                        validator: TextFormValidators.validateItemPrice,
                        onSaved: (value) =>
                            menuItemProvider.price = double.parse(value!)),
                    const SizedBox(height: 20),
                    LabeledImageContainer(
                      labelText: 'Image',
                      button1Text: 'Capture Image',
                      button2Text: 'Browse Gallery',
                      onButton1Pressed: () async {
                        await availableCameras().then((value) => Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (_) => CameraUi(
                                      cameras: value,
                                      imageUploadType: ImageUploadType.menuItem,
                                    ))));
                      },
                      onButton2Pressed: () async {
                        await ImageUploadHelper.addImageFromGallery(
                          context,
                          uploadType: ImageUploadType.menuItem,
                          merchantStructure: merchantStructureProvider,
                          menuItemProvider: menuItemProvider,
                        );
                      },
                    ),
                    const SizedBox(height: 20),
                    Row(
                      children: [
                        GestureDetector(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: CreateAButton(
                              width: screenWidth / 3,
                              height: screenWidth / 10,
                              buttonColor: Colors.white,
                              buttonText: 'Cancel',
                              borderColor: Colors.red,
                              textColor: Colors.red,
                              borderRadius: 20),
                        ),
                        const Spacer(),
                        GestureDetector(
                          onTap: () {
                            // Check if the item image is provided, show a toast if it's missing.
                            if (menuItemProvider.itemImage.isEmpty) {
                              showToast(
                                  "An item image is required for a menu Item",
                                  // Toast message
                                  Colors.red, // Text color
                                  Colors.white, // Background color
                                  "SHORT" // Duration of the toast
                                  );
                            }
// Validate the form and ensure the item image is not empty before proceeding.
                            else if (merchantMenuItem.currentState!
                                    .validate() &&
                                menuItemProvider.itemImage.isNotEmpty) {
                              // Save the form state to persist user input.
                              merchantMenuItem.currentState!.save();

                              // Create a new MenuItem object with the provided data.
                              final newMenuItem = MenuItem(
                                itemName: menuItemProvider.itemName,
                                // Item name entered by user
                                description: menuItemProvider.description,
                                // Item description
                                price: menuItemProvider.price,
                                // Item price
                                itemImage: menuItemProvider
                                    .itemImage, // Image path for the item
                              );

                              // If 'index' is not null, update the existing item in the list.
                              if (index != null) {
                                merchantStructureProvider.updateMenuItem(
                                    index, newMenuItem);
                              }
                              // If 'index' is null, it means we are adding a new item to the list.
                              else {
                                merchantStructureProvider.menuItems
                                    .add(newMenuItem);
                              }

                              menuItemProvider.itemImage = '';
                              merchantMenuItem.currentState!.reset();

                              Navigator.pop(context);
                            }
                          },
                          child: CreateAButton(
                              width: screenWidth / 3,
                              height: screenWidth / 10,
                              buttonColor: Colors.red,
                              buttonText: 'Done',
                              textColor: Colors.white,
                              borderRadius: 20),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
