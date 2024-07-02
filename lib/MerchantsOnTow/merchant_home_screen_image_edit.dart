
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:camera/camera.dart';
import 'package:thingsonwheels/MerchantsOnTow/merchant_home_screen.dart';
import '../CameraUI/camera_ui.dart';
import '../main.dart';
import 'package:dotted_border/dotted_border.dart';

class ImageEditSection extends StatefulWidget {

  final List<String?> originalImageUrls;
  const ImageEditSection({Key? key, required List<String?> imageUrls}) : originalImageUrls = imageUrls, super(key: key);

  @override
  ImageEditSectionState createState() => ImageEditSectionState();
}

class ImageEditSectionState extends State<ImageEditSection> {
  late List<String?> newSavedImageUrls;

  @override
  void initState()
  {
    super.initState();
    newSavedImageUrls = List.from(widget.originalImageUrls);
  }

  void addImage(String imagePath) {
    int index = newSavedImageUrls.indexWhere((element) => element == null);
    if (index != -1) {
      newSavedImageUrls[index] = imagePath;
    }
    else
      {
        newSavedImageUrls.add(imagePath);
      }
  }
  bool areListsEqual(List<String?> list1, List<String?> list2) {
    if (list1.length != list2.length) {
      return false;
    }

    for (int i = 0; i < list1.length; i++) {
      if (list1[i] != list2[i]) {
        return false;
      }
    }
    return true;
  }


   saveImageChanges() {
    try{

      Navigator.push(context, MaterialPageRoute(builder: (context)=> MerchantProfileScreen(updatedImages: newSavedImageUrls,)));
    }
    catch(e)
    {
      Fluttertoast.showToast(
        msg: 'Error saving the images, try again',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        backgroundColor: Colors.red,
        textColor: Colors.white,
      );
    }
  }

  Future<void> addImageFromGallery() async {

    final ImagePicker picker = ImagePicker();
    try {
      var pickedImages = await picker.pickMultiImage();
      if (pickedImages.isNotEmpty) {
        // Update only non-null elements in the images list
        for (int i = 0; i < pickedImages.length && i< widget.originalImageUrls.length; i++) {
          setState(() {
            addImage(pickedImages[i].path);
          });
        }
      }
    } catch (e) {
      Fluttertoast.showToast(
        msg: 'Error adding images',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        backgroundColor: Colors.white,
        textColor: Colors.black,
      );
    }
  }

  @override
  Widget build(BuildContext context) {

    return PopScope(
      canPop: Platform.isIOS ? false: true,
      child: Scaffold(
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: screenHeight / 15),
            InkWell(
                child: Align(
                  alignment: Alignment.topLeft,
                  child: Icon(
                    Icons.arrow_back,
                    size: screenWidth / 12,
                  ),
                ),
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context)=>  const MerchantProfileScreen()));
                }),
            Padding(
              padding: const EdgeInsets.only(top: 20,left: 15),
              child: RichText(
                  text: TextSpan(
                      text: 'Edit your current images'.tr(),
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold, // Default text color
                        fontSize: screenHeight / 30, // Default text size
                      ))),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 40, left: 40, right: 40),
              child: Row(
                children: [
                  if (newSavedImageUrls.isNotEmpty)
                    imageContainer(
                        newSavedImageUrls.isNotEmpty ? newSavedImageUrls.elementAt(0) : null,
                        0
                    ),
                  const Spacer(),
                  imageContainer(
                      newSavedImageUrls.length > 1 ? newSavedImageUrls.elementAt(1) : null,
                      1
                  ),
                ],
              ),
            ),
            const SizedBox(height: 40),
            Padding(
              padding: const EdgeInsets.only(left: 40, right: 40),
              child: Row(
                children: [
                  imageContainer(
                      newSavedImageUrls.length > 2 ? newSavedImageUrls.elementAt(2) : null,
                      2
                  ),
                  const Spacer(),
                  imageContainer(
                      newSavedImageUrls.length > 3 ? newSavedImageUrls.elementAt(3) : null,
                      3
                  ),
                ],
              ),
            ),
            const Spacer(),
            Padding(
              padding: const EdgeInsets.only(bottom: 40),
              child: ElevatedButton(
                style: ButtonStyle(
                  backgroundColor: WidgetStateProperty.all(Colors.orange),
                  fixedSize: WidgetStateProperty.all<Size>(
                    Size(screenWidth - 20, 40),
                  ),
                  shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                  ),
                ),
                onPressed: () async {
                 if(areListsEqual(widget.originalImageUrls, newSavedImageUrls))
                 {
                   Fluttertoast.showToast(
                     msg: 'Make some changes first in order to save them'.tr(),
                     toastLength: Toast.LENGTH_SHORT,
                     gravity: ToastGravity.CENTER,
                     backgroundColor: Colors.red,
                     textColor: Colors.white,
                   );
                 }
                 if(newSavedImageUrls.elementAt(0) == null )
                   {
                     Fluttertoast.showToast(
                       msg: 'The main image cannot be empty'.tr(),
                       toastLength: Toast.LENGTH_SHORT,
                       gravity: ToastGravity.CENTER,
                       backgroundColor: Colors.red,
                       textColor: Colors.white,
                     );
                   }
                 else
                   {
                      saveImageChanges();
                   }
                },
                child:  Text(
                  'Save Changes'.tr(),
                  style: const TextStyle(
                      fontSize: 18,
                      color: Colors.white,
                      fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future uploadOrTakeImage(BuildContext context) //Widget to display the option to display and upload image
  {
    var boxHeight = screenHeight / 5; //Adjust the size
    var cameraIconSize = boxHeight / 2.9; //Adjust the size of the Icons
    var textSize = cameraIconSize / 2.9; //Size for the text
    // var gapBetweenIcons = boxHeight;  //gap between two icons

    return showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return Container(
              color: Colors.white,
              height: screenHeight, //height of the container to each device
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  InkWell(
                    onTap: () async {
                      try {
                        await availableCameras().then((value) => Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (_) => CameraUI(cameras: value, imagesToUpdate: newSavedImageUrls,))));
                      } catch (e) //Handle the case when no camera can be loaded
                          {
                        Fluttertoast.showToast(
                          msg: 'Unable to load camera from the device'.tr(),
                          toastLength: Toast.LENGTH_SHORT,
                          gravity: ToastGravity.CENTER,
                          backgroundColor: Colors.white,
                          textColor: Colors.black,
                        );
                      }
                    },
                    child: Padding(
                      padding: const EdgeInsets.only(top: 5),
                      child: Row(
                        //Using a row Widget to place each icon in a row fashion
                        children: [
                          IconButton(
                              onPressed: null,
                              icon: Icon(Icons.camera_alt,
                                  size: cameraIconSize, color: Colors.black87)),
                          Padding(
                            padding: const EdgeInsets.only(left: 5),
                            child: Text(
                              'Camera'.tr(),
                              style: TextStyle(
                                fontSize: textSize,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Divider(thickness: 2, indent: screenWidth / 30),
                  InkWell(
                    onTap: () async {
                      addImageFromGallery();
                    },
                    child: Row(children: [
                      IconButton(
                          onPressed: null,
                          icon: Icon(Icons.image_rounded,
                              size: cameraIconSize, color: Colors.black87)),
                      Padding(
                        padding: const EdgeInsets.only(left: 5),
                        child: Text(
                          'Gallery'.tr(),
                          style: TextStyle(
                            fontSize: textSize,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ]),
                  ),
                  Divider(thickness: 2, indent: screenWidth / 30),
                ],
              ));
        });
  }

  Widget imageContainer(String? imageFile, int index) {
    return imageFile == null
        ? DottedBorder(
      color: Colors.grey,
      strokeWidth: index == 0? 3: 2,
      dashPattern: const [18, 18],
      child: Stack(
        children: [
          Container(
            width: screenWidth / 3,
            height: screenHeight / 5,
            color: Colors.grey[200],
            child: FittedBox(
              fit: BoxFit.contain,
              child: imageFile != null
                  ? FittedBox(
                fit: BoxFit.contain,
                child: _buildImageWidget(imageFile),
              )
                  : const SizedBox(), // Display nothing if no image is selected
            ),
          ),
          Positioned(
            bottom: 0,
            right: 0,
            child: InkWell(
              onTap: () async {
                try {
                  uploadOrTakeImage(context);
                } catch (e) {
                  Fluttertoast.showToast(
                    msg: 'Error occurred, please try again'.tr(),
                    toastLength: Toast.LENGTH_SHORT,
                    gravity: ToastGravity.CENTER,
                    backgroundColor: Colors.white,
                    textColor: Colors.black,
                  );
                }
              },
              child: Icon(
                Icons.add_circle,
                color: Colors.orange,
                size: screenWidth / 14,
              ),
            ),
          ),
        ],
      ),
    )
        : Stack(
      children: [
        Container(
          width: screenWidth / 3,
          height: screenHeight / 5,
          color: Colors.grey[200],
          child: FittedBox(fit: BoxFit.contain, child: _buildImageWidget(imageFile)),
        ),
        Positioned(
          top: 0,
          right: 0,
          child: InkWell(
            onTap: () async {
              deleteOrCancel(context, index);
            },
            child: Icon(
              Icons.edit,
              color: Colors.orange,
              size: screenWidth / 14,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildImageWidget(String? imageFile) {
    if (imageFile != null && imageFile.startsWith("https://")) {
      // It's a network image
      return CachedNetworkImage(imageUrl: imageFile);
    } else {
      // It's a local file
      return Image.file(File(imageFile!));
    }
  }
  /* Widget to make the delete or cancel popup */
  Future deleteOrCancel(BuildContext context, int index) {

    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
              elevation: 5,
              shadowColor: Colors.black,
              backgroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(
                    12), // Adjust the circular border radius
              ),
              content: SafeArea(
                child: SizedBox(
                  height: screenHeight / 4,
                  child: Column(
                    children: [
                      Icon(Icons.error_outline,
                          color: Colors.red, size: screenWidth / 5.5),
                      Padding(
                        padding: EdgeInsets.only(top: screenWidth / 27),
                        child: Text(
                          '${'Do you want to delete this image'.tr()}?',
                          style: TextStyle(fontSize: screenWidth / 28),
                        ),
                      ),
                      const Spacer(),
                      Padding(
                        padding: EdgeInsets.only(bottom: screenWidth / 17),
                        child: Row(
                          children: [
                            ElevatedButton(
                                onPressed: () {
                                  Navigator.pop(
                                      context); //get out of the widget
                                },
                                style: ButtonStyle(
                                  shape: WidgetStateProperty.all<
                                      RoundedRectangleBorder>(
                                    RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10.0),
                                      side: const BorderSide(
                                        color: Colors.red, // Red border color
                                        width:
                                        1.0, // Adjust the border width as needed
                                      ),
                                    ),
                                  ),
                                  backgroundColor:
                                  WidgetStateProperty.all<Color>(
                                      Colors.white),
                                  // White background color
                                  fixedSize: WidgetStateProperty.all<Size>(
                                    Size(screenWidth / 3.5, screenWidth / 43.2),
                                  ),
                                ),
                                child: Text(
                                  'Cancel'.tr(),
                                  style: const TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 12,
                                  ),
                                )),
                            const Spacer(),
                            ElevatedButton(
                                onPressed: () {
                                  setState(() {
                                    newSavedImageUrls[index] = null;
                                    Navigator.pop(context);
                                  });
                                },
                                style: ButtonStyle(
                                  shape: WidgetStateProperty.all<
                                      RoundedRectangleBorder>(
                                      RoundedRectangleBorder(
                                          borderRadius:
                                          BorderRadius.circular(10.0))),
                                  backgroundColor:
                                  WidgetStateProperty.all(Colors.red),
                                  fixedSize: WidgetStateProperty.all(Size(
                                      screenWidth / 3.5, screenWidth / 43.2)),
                                ),
                                child:  Text(
                                  'delete'.tr(),
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 12,
                                  ),
                                )),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ));
        });
  }

}
