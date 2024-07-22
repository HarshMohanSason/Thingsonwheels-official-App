import 'dart:io';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:camera/camera.dart';
import 'package:provider/provider.dart';
import 'package:thingsonwheels/UserLogin/PhoneLogin/phone_login_service.dart';
import '../CameraUI/camera_ui.dart';
import '../ResuableWidgets/toast_widget.dart';
import '../main.dart';
import 'package:dotted_border/dotted_border.dart';
import 'merchant_service.dart';
import 'merchant_home_screen.dart';

class ImageUploadSection extends StatefulWidget {
  const ImageUploadSection({Key? key}) : super(key: key);

  @override
  ImageUploadSectionState createState() => ImageUploadSectionState();
}

class ImageUploadSectionState extends State<ImageUploadSection> {
  bool isUploaded = false;
  late MerchantsOnTOWService merchantsOnTOWServiceProvider;
  late PhoneLoginService phoneLoginServiceProvider;

  @override
  didChangeDependencies() {
    super.didChangeDependencies();
    merchantsOnTOWServiceProvider = context.watch<MerchantsOnTOWService>();
    phoneLoginServiceProvider = context.watch<PhoneLoginService>();
  }

  Future<void> addImageFromGallery(BuildContext context) async {

    final ImagePicker picker = ImagePicker();
    try {
      var pickedImages = await picker.pickMultiImage();
      if (pickedImages.isNotEmpty) {
        // Update only non-null elements in the images list
        for (int i = 0; i < pickedImages.length && i< merchantsOnTOWServiceProvider.businessImages.length; i++) {
          merchantsOnTOWServiceProvider.addImage(pickedImages[i].path);
        }
      }
    } on PlatformException
    {
      showToast('Could not add the image, allow access for Thingsonwheels to upload images in settings', Colors.red, Colors.white, 'SHORT');
    }
    catch (e) {
      showToast('Error occurred, please try again', Colors.red, Colors.white, 'SHORT');
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: Platform.isIOS ? false : true,
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
                  Navigator.pop(context);
                }),
            Padding(
              padding: const EdgeInsets.only(top: 20, left: 15),
              child: RichText(
                  text: TextSpan(
                      text: 'Add images of your business'.tr(),
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
                    imageContainer(
                   merchantsOnTOWServiceProvider.businessImages.isNotEmpty ? merchantsOnTOWServiceProvider.businessImages.elementAt(0): null, 0),
                  const Spacer(),
                  imageContainer(
                      merchantsOnTOWServiceProvider.businessImages.isNotEmpty ? merchantsOnTOWServiceProvider.businessImages.elementAt(1): null, 1),
                ],
              ),
            ),
            const SizedBox(height: 40),
            Padding(
              padding: const EdgeInsets.only(left: 40, right: 40),
              child: Row(
                children: [
                  imageContainer(
                      merchantsOnTOWServiceProvider.businessImages.isNotEmpty ? merchantsOnTOWServiceProvider.businessImages.elementAt(2): null, 2),
                  const Spacer(),
                  imageContainer(
                      merchantsOnTOWServiceProvider.businessImages.isNotEmpty ? merchantsOnTOWServiceProvider.businessImages.elementAt(3): null, 3)
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
                  if (merchantsOnTOWServiceProvider.businessImages.elementAt(0) == null) {
                    showToast('The main image cannot be empty'.tr(), Colors.red,
                        Colors.white, 'SHORT');
                  }
                  if (await phoneLoginServiceProvider.checkMerchantExistsWithSameNumber() ==
                      true) {
                    showToast(
                        'You already have an account with us, please exit and login from main screen'.tr(),
                        Colors.red,
                        Colors.white,
                        'SHORT');
                  } else {
                    if (context.mounted) {
                      showDialog(
                          context: context,
                          barrierDismissible: false,
                          builder: (BuildContext context) {
                            return Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  const CircularProgressIndicator(
                                    color: Colors.white,
                                    strokeWidth: 6,
                                  ),
                                  DefaultTextStyle(
                                    style:
                                        TextStyle(fontSize: screenWidth / 28),
                                    child: Text(
                                      'Uploading'.tr(),
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                  )
                                ],
                              ),
                            );
                          });
                    }
                    isUploaded =
                        await merchantsOnTOWServiceProvider.uploadMerchantInfoToDB();
                    if (isUploaded) {
                      showToast('Your Info was submitted'.tr(), Colors.green,
                          Colors.white, 'SHORT');

                      if (context.mounted) {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    const MerchantProfileScreen()));
                      }
                    } else {
                      if (context.mounted) {
                        Navigator.pop(context);
                      }

                      setState(() {
                        isUploaded = false;
                      });
                    }
                  }
                },
                child: Text(
                  'Register'.tr(),
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

  Future uploadOrTakeImage(
      BuildContext
          context) //Widget to display the option to display and upload image
  {
    var parentContext = context;
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
                                builder: (_) => CameraUI(cameras: value))));
                      } catch (e) //Handle the case when no camera can be loaded
                      {
                        showToast('Unable to load camera from the device'.tr(),
                            Colors.red, Colors.white, 'SHORT');
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
                      addImageFromGallery(parentContext);
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
            strokeWidth: index == 0 ? 4 : 2,
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
                            child: Image.file(File(imageFile)),
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
                        showToast('Error occurred, please try again'.tr(),
                            Colors.black, Colors.white, 'SHORT');
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
                child: FittedBox(
                    fit: BoxFit.contain, child: Image.file(File(imageFile))),
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
                          'Do you want to delete this image?'.tr(),
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
                                    merchantsOnTOWServiceProvider.businessImages[index] =
                                        null;
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
                                child: Text(
                                  'Delete'.tr(),
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
