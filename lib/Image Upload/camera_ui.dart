import 'dart:io';
import 'dart:ui';
import 'package:camera/camera.dart';
import 'package:croppy/croppy.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:thingsonwheels/Merchant%20Sign%20Up/merchant_sign_up_flow.dart';
import 'package:thingsonwheels/Reusable%20Widgets/toast_widget.dart';
import 'package:thingsonwheels/Social%20Media/social_media_post_upload_ui.dart';
import '../Merchant Sign Up/merchant_structure.dart';
import '../main.dart';
import 'image_upload_helper.dart';
import 'package:path_provider/path_provider.dart';

class CameraUi extends StatefulWidget {
  const CameraUi(
      {super.key, required this.cameras, required this.imageUploadType});

  final List<CameraDescription>? cameras;
  final ImageUploadType imageUploadType;

  @override
  CameraUiState createState() => CameraUiState();
}

class CameraUiState extends State<CameraUi> {
  late CameraController _cameraController; //controller for the device camera
  bool isPictureTaken = false;
  late XFile pictureTaken;
  late CameraDescription _currentCamera = widget.cameras![0];
  late MerchantStructure merchantStructureProvider;

  //Create a type future function to initialize the camera using the camera controller
  Future initCamera(CameraDescription cameraDescription) async {
    _cameraController = CameraController(
        enableAudio: false,
        cameraDescription,
        ResolutionPreset.high,
        imageFormatGroup:
            ImageFormatGroup.bgra8888); //Create a camera Controller

    try {
      await _cameraController.initialize().then((_) {
        if (mounted) {
          setState(() {});
        }
      });
    } on CameraException {
      if (mounted) {
        ImageUploadHelper.handleCameraException(context);
      }
    }
    await _cameraController
        .lockCaptureOrientation(DeviceOrientation.portraitUp);
  }

  //Function to crop the image to XFile
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
      showToast('An error occurred saving the cropped image, please try again',
          Colors.red, Colors.white, "SHORT");
    }
    return null;
  }

  @override
  void initState() {
    super.initState();
    initCamera(
        _currentCamera); //initialize the first camera from the list. Default camera is the rear camera
  }

  @override
  void dispose() {
    _cameraController.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    merchantStructureProvider = context.watch<MerchantStructure>();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: Platform.isAndroid ? true : false,
      child: Scaffold(
        backgroundColor: Colors.black,
        body: cameraPortrait(context),
      ),
    );
  }

  Widget cameraPortrait(BuildContext context) {
    final menuItem = Provider.of<MenuItem>(context);
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
                  icon: Icon(Icons.arrow_back,
                      color: Colors.white, size: screenWidth / 14),
                ),
              ),
              const Spacer(),
              Align(
                alignment: Alignment.bottomCenter,
                child: InkWell(
                  onTap: () async {
                    pictureTaken = await _cameraController
                        .takePicture(); //take the picture
                    setState(() {
                      isPictureTaken = true;
                      Transform.rotate(
                        angle: 0,
                        child: Image.file(File(pictureTaken.path)),
                      );
                    });
                    if (isPictureTaken && context.mounted) {
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

                        XFile? finalImage = await croppedImage
                            .then((value) => croppedImageToXFile(value));

                        if (finalImage != null && context.mounted) {
                          switch (widget.imageUploadType) {
                            case ImageUploadType.profilePicture:
                              merchantStructureProvider
                                  .setMerchantProfileImage = finalImage.path;
                              Navigator.pop(context);
                              Navigator.pop(context);
                              break;

                            case ImageUploadType.businessImage:
                              merchantStructureProvider
                                  .setMerchantBusinessImages = finalImage.path;
                              Navigator.pop(context);
                              break;

                            case ImageUploadType.socialMediaPost:
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          SocialMediaPostUploadUi(
                                              postImage: finalImage.path)));
                            case ImageUploadType.menuItem:
                             menuItem.itemImage = finalImage.path;
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          const MerchantSignUpFlow()));
                            default:
                              return;
                          }
                        } else {
                          return;
                        }
                      } catch (e) {
                        showToast('Error adding the image, try again',
                            Colors.red, Colors.white, "SHORT");
                      }
                    }
                  },
                  child: Icon(Icons.circle_sharp,
                      color: Colors.white, size: screenWidth / 5.4),
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
                  icon: Icon(Icons.cameraswitch,
                      color: Colors.white, size: screenWidth / 14.4),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
