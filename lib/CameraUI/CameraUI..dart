
import 'package:croppy/croppy.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:camera/camera.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:thingsonwheels/MerchantsOnTow/ImageEditSection.dart';
import 'package:thingsonwheels/MerchantsOnTow/ImageUploadSection.dart';
import 'dart:io';
import 'dart:ui';
import '../MerchantsOnTow/MerchantOnTowService.dart';
import '../main.dart';
import 'package:path_provider/path_provider.dart';

class CameraUI extends StatefulWidget {
  final List<String?>? imagesToUpdate;
  final List<CameraDescription>?
      cameras; //list to get the available cameras when the camera icon is pressed

  const CameraUI({Key? key, required this.cameras, this.imagesToUpdate}) : super(key: key);

  @override
  State<CameraUI> createState() => _CameraUIState();
}

class _CameraUIState extends State<CameraUI> {
  //final AddListing _addListing = const AddListing();
  late CameraController _cameraController; //controller for the device camera
  bool isPictureTaken = false;
  late XFile pictureTaken;
  late CameraDescription _currentCamera = widget.cameras![0];

  //Create a type future function to initialize the camera using the camera controller
  Future initCamera(CameraDescription cameraDescription) async {
    //Initialize the selected camera

    _cameraController = CameraController(
        cameraDescription, ResolutionPreset.high,
        imageFormatGroup:
            ImageFormatGroup.bgra8888); //Create a camera Controller

    try {
      await _cameraController.initialize().then((_) {
        if (mounted) {
          setState(() {});
        }
      });
    } on CameraException catch (e) {
      debugPrint('Camera error $e');
    }

    await _cameraController
        .lockCaptureOrientation(DeviceOrientation.portraitUp);
  }

  Future<XFile?> croppedImageToXFile(CropImageResult? image) async {
    try {
      if (image == null) {
        return null;
      }

      var imageData =
          await image.uiImage.toByteData(format: ImageByteFormat.png);

      if (imageData != null) {
        var unit8val = imageData.buffer.asUint8List();
        var tempDir = await getTemporaryDirectory();
        var timestamp = DateTime.now().millisecondsSinceEpoch;
        var filePath = "${tempDir.path}/temp_croppedImage_$timestamp.png";

        // Delete existing file if it exists
        if (await File(filePath).exists()) {
          await File(filePath).delete();
        }
        File file = await File(filePath).create();
        file.writeAsBytesSync(unit8val);
        return XFile(file.path);
      }
    } catch (e) {
      rethrow;
    }
    return null;
  }

  @override
  void initState() {
    super.initState();
    // initialize the rear camera
    initCamera(
        _currentCamera); //initialize the first camera from the list. Default camera is the rear camera
  }

  @override
  void dispose() {
    // Dispose of the controller when the widget is disposed.
    _cameraController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    return PopScope(
      canPop: false,
      child: Scaffold(
        backgroundColor: Colors.black,
        body: cameraPortrait(
            context), //call the camera_portrait widget to build the camera.

        //   Expanded(child: bottomIcons(context)),
      ),
    );
  }

  Widget bottomIcons(BuildContext context) {

    return const Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Spacer(),
      ],
    );
  }

  Widget cameraPortrait(BuildContext context) {
    final imageListProvider = context.watch<MerchantsOnTOWService>();
    return Column(
      children: [
        SizedBox(
            width: screenWidth,
            height: screenHeight - 150,
            child: Center(child: CameraPreview(_cameraController))),
        // Show the camera preview

        Padding(
          padding: const EdgeInsets.only(top: 30),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Align(
                alignment: Alignment.bottomLeft,
                child: IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: const Icon(Icons.arrow_back,
                      color: Colors.white, size: 30),
                ),
              ),
              const Spacer(),
              Align(
                alignment: Alignment.bottomCenter,
                child: InkWell(
                  onTap: () async {
                    pictureTaken = await _cameraController.takePicture(); //take the picture
                    setState(() {
                      isPictureTaken = true;
                      Transform.rotate(
                        angle: 0,
                        child: Image.file(File(pictureTaken.path)),
                      );
                    });
                    if (isPictureTaken && mounted)
                    {
                      try {
                        Future<CropImageResult?> croppedImage = Platform.isIOS
                            ? showCupertinoImageCropper(
                                context,
                                imageProvider:
                                    FileImage(File(pictureTaken.path)),
                              )
                            : showMaterialImageCropper(context,
                                imageProvider:
                                    FileImage(File(pictureTaken.path)));

                        XFile? finalImage = await croppedImage.then((value) => croppedImageToXFile(value));

                        if (finalImage != null && mounted) {
                          if( widget.imagesToUpdate == null)
                          {
                              imageListProvider.addImage(finalImage.path);
                              Navigator.push(context, MaterialPageRoute(builder: (context)=> ImageUploadSection()));
                          }
                          else
                            {
                              setState(() {
                                int index = widget.imagesToUpdate!.indexWhere((element) => element == null);
                                if (index != -1) {
                                  widget.imagesToUpdate![index] = finalImage.path;
                                  Navigator.push(context, MaterialPageRoute(builder: (context) => ImageEditSection(imageUrls: widget.imagesToUpdate!)));
                                }
                                else
                                  {
                                    widget.imagesToUpdate!.add(finalImage.path);
                                    Navigator.push(context, MaterialPageRoute(builder: (context) => ImageEditSection(imageUrls: widget.imagesToUpdate!)));
                                  }
                              });
                            }

                        } else {
                          Fluttertoast.showToast(
                            msg: 'No image found',
                            toastLength: Toast.LENGTH_SHORT,
                            gravity: ToastGravity.CENTER,
                            backgroundColor: Colors.red,
                            textColor: Colors.white,
                          );
                        }
                      } catch (e) {
                        Fluttertoast.showToast(
                          msg: 'Error adding the image, try again',
                          toastLength: Toast.LENGTH_SHORT,
                          gravity: ToastGravity.CENTER,
                          backgroundColor: Colors.white,
                          textColor: Colors.black,
                        );
                      }
                    }
                  },
                  child: const Icon(Icons.circle_sharp,
                      color: Colors.white, size: 80),
                ),
              ),
              const Spacer(),
              Align(
                alignment: Alignment.bottomRight,
                child: IconButton(
                  onPressed: () {
                    setState(() {
                      if (_currentCamera == widget.cameras![0]) {
                        //if the rear camera is selected
                        _currentCamera =
                            widget.cameras![1]; //select the front camera
                      } else {
                        _currentCamera =
                            widget.cameras![0]; //else select the rear camera
                      }
                      initCamera(_currentCamera); //initialize the camera
                    });
                  },
                  icon: const Icon(Icons.cameraswitch,
                      color: Colors.white, size: 30),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
