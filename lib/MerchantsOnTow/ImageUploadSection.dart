
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:camera/camera.dart';
import 'package:provider/provider.dart';
import '../CameraUI/CameraUI..dart';
import '../main.dart';
import 'package:dotted_border/dotted_border.dart';
import 'MerchantOnTowService.dart';
import 'MerchantProfileScreen.dart';

class ImageUploadSection extends StatefulWidget {
  const ImageUploadSection({Key? key}) : super(key: key);

  @override
  ImageUploadSectionState createState() => ImageUploadSectionState();
}

class ImageUploadSectionState extends State<ImageUploadSection> {

  bool isUploaded = false;

  Future<void> addImageFromGallery(BuildContext context) async {
    final imageListProvider = Provider.of<MerchantsOnTOWService>(context, listen: false);
    final ImagePicker picker = ImagePicker();
    try {
      var pickedImages = await picker.pickMultiImage();
      if (pickedImages.isNotEmpty) {
        // Update only non-null elements in the images list
        for (int i = 0; i < pickedImages.length && i< imageListProvider.businessImages.length; i++) {
          imageListProvider.addImage(pickedImages[i].path);
        }
      }
    } catch (e) {
      //print(e);
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
    final merchantProvider = context.watch<MerchantsOnTOWService>();
    return Scaffold(
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
          Text(
            "Add Images of your business",
            style: TextStyle(
              fontSize: screenWidth / 15,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 40, left: 40, right: 40),
            child: Row(
              children: [
                if (merchantProvider.businessImages.isNotEmpty)
                  imageContainer(merchantProvider.businessImages.elementAt(0), 0),
                const Spacer(),
                  imageContainer(merchantProvider.businessImages.elementAt(1), 1),
              ],
            ),
          ),
         const  SizedBox(height: 40),
          Padding(
            padding: const EdgeInsets.only(left: 40, right: 40),
            child: Row(
              children: [
                imageContainer(merchantProvider.businessImages.elementAt(2), 2),
                const Spacer(),
                imageContainer(merchantProvider.businessImages.elementAt(3), 3)
              ],
            ),
          ),
          const Spacer(),
          Padding(
            padding: const EdgeInsets.only(bottom: 40),
            child: ElevatedButton(
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(Colors.orange),
                fixedSize: MaterialStateProperty.all<Size>(
                  Size(screenWidth - 20, 40),
                ),
                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                ),
              ),
              onPressed: () async {
                if (merchantProvider.businessImages.isEmpty ||
                    merchantProvider.businessImages.elementAt(0) == null) {
                  Fluttertoast.showToast(
                    msg: 'You need at least one image to register',
                    toastLength: Toast.LENGTH_SHORT,
                    gravity: ToastGravity.CENTER,
                    backgroundColor: Colors.white,
                    textColor: Colors.black,
                  );
                }
                else{
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
                            style: TextStyle(fontSize: screenWidth / 28),
                            child: const Text('Uploading...' ,
                            style: TextStyle(
                              fontWeight: FontWeight.bold
                            ),),
                          )
                        ],
                      ),
                    );
              });
                isUploaded = await merchantProvider.uploadMerchantInfoToDB();
                if(isUploaded && mounted)
                  {
                    Fluttertoast.showToast(
                      msg: 'Your Info was submitted',
                      toastLength: Toast.LENGTH_SHORT,
                      gravity: ToastGravity.CENTER,
                      backgroundColor: Colors.green,
                      textColor: Colors.white,
                    );
                    Navigator.push(context, MaterialPageRoute(builder: (context)=> const MerchantProfileScreen()));
                  }
                else
                  {
                    Fluttertoast.showToast(
                      msg: 'Error uploading the info, please try again',
                      toastLength: Toast.LENGTH_SHORT,
                      gravity: ToastGravity.CENTER,
                      backgroundColor: Colors.red,
                      textColor: Colors.white,
                    );
                    if(mounted)
                      {
                        Navigator.pop(context);
                      }

                   setState(() {
                     isUploaded = false;
                   });
                  }
                  }
              },

              child: const Text(
                'Register',
                style: TextStyle(
                    fontSize: 18,
                    color: Colors.white,
                    fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future uploadOrTakeImage(BuildContext context) //Widget to display the option to display and upload image
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
                        Fluttertoast.showToast(
                          msg: 'Unable to load camera from the device',
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
                              'Camera',
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
                          'Gallery',
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
            strokeWidth: 2,
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
                        Fluttertoast.showToast(
                          msg: 'Error occurred, try again',
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
                child: FittedBox(fit: BoxFit.contain, child: Image.file(File(imageFile))),
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
    final merchantTowProvider = Provider.of<MerchantsOnTOWService>(context, listen: false);
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
                          'Do you want to delete this image?',
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
                                  shape: MaterialStateProperty.all<
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
                                      MaterialStateProperty.all<Color>(
                                          Colors.white),
                                  // White background color
                                  fixedSize: MaterialStateProperty.all<Size>(
                                    Size(screenWidth / 3.5, screenWidth / 43.2),
                                  ),
                                ),
                                child: const Text(
                                  'Cancel',
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 12,
                                  ),
                                )),
                            const Spacer(),
                            ElevatedButton(
                                onPressed: () {
                                  setState(() {
                                    merchantTowProvider.businessImages[index] = null;
                                    Navigator.pop(context);
                                  });
                                },
                                style: ButtonStyle(
                                  shape: MaterialStateProperty.all<
                                          RoundedRectangleBorder>(
                                      RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(10.0))),
                                  backgroundColor:
                                      MaterialStateProperty.all(Colors.red),
                                  fixedSize: MaterialStateProperty.all(Size(
                                      screenWidth / 3.5, screenWidth / 43.2)),
                                ),
                                child: const Text(
                                  'Delete',
                                  style: TextStyle(
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
