import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:thingsonwheels/Image%20Upload/camera_ui.dart';
import 'package:thingsonwheels/Merchant%20Sign%20Up/merchant_structure.dart';
import 'package:thingsonwheels/Social%20Media/social_media_post_upload_ui.dart';
import 'package:thingsonwheels/main.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:image_picker/image_picker.dart';
import '../Reusable Widgets/toast_widget.dart';

enum ImageUploadType {
  profilePicture,
  businessImage,
  menuItem,
  socialMediaPost,
}

class ImageUploadHelper extends ChangeNotifier {
  void chooseFromCameraOrGalleryUI(
    BuildContext context,
    MerchantStructure merchantStructureProvider, {
    required ImageUploadType uploadType,
  }) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          height: screenHeight / 2,
          color: Colors.white,
          child: Column(
            children: [
              const SizedBox(
                height: 10,
              ),
              ListTile(
                leading: Icon(
                  Icons.camera_alt,
                  size: screenWidth / 7,
                  color: Colors.black,
                ),
                title: Text(
                  'Camera',
                  style: TextStyle(
                      fontSize: screenWidth / 18, color: Colors.black),
                ),
                onTap: () async {
                  await availableCameras().then((value) => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) => CameraUi(
                                cameras: value,
                                imageUploadType: uploadType,
                              ))));
                },
              ),
              const Divider(
                thickness: 1,
                indent: 2,
                color: Colors.black,
              ),
              ListTile(
                leading: Icon(
                  Icons.photo_album,
                  size: screenWidth / 7,
                  color: Colors.black,
                ),
                title: Text(
                  'Gallery',
                  style: TextStyle(
                    fontSize: screenWidth / 18,
                  ),
                ),
                onTap: () {
                  addImageFromGallery(context,
                      merchantStructure: merchantStructureProvider,
                      uploadType: uploadType);
                  Navigator.pop(context); // Close the modal
                },
              ),
            ],
          ),
        );
      },
    );
  }

  static void handleException(
    BuildContext context,
    String title,
    String content,
    VoidCallback openSettingsAction,
  ) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Center(child: Text(title)),
          content: Text(
            content,
            style: const TextStyle(color: Colors.black),
          ),
          actions: <Widget>[
            Center(
              child: TextButton(
                onPressed: () {
                  openSettingsAction();
                  Navigator.of(context).pop();
                },
                style: ButtonStyle(
                  backgroundColor: WidgetStateProperty.all<Color>(Colors.red),
                  overlayColor: WidgetStateProperty.all<Color>(
                      Colors.white.withOpacity(0.1)),
                  padding: WidgetStateProperty.all<EdgeInsetsGeometry>(
                      const EdgeInsets.all(16)),
                  alignment: Alignment.center,
                ),
                child: const Text(
                  'Open Settings',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  static void handleCameraException(BuildContext context) {
    handleException(
      context,
      'Camera Access Needed',
      'Thingsonwheels needs camera access to take and upload images for your merchant profile. '
          'Please enable camera access in your device settings.',
      () {
        openAppSettings();
      },
    );
  }

  static void handleGalleryError(BuildContext context) {
    handleException(
      context,
      'Gallery Access Needed',
      'Thingsonwheels needs to access your photo library for uploading images to your merchant profile '
          'Please enable camera access in your device settings.',
      () {
        openAppSettings();
      },
    );
  }

  static Future<void> addImageFromGallery(BuildContext context,
      {required ImageUploadType uploadType,
      MerchantStructure? merchantStructure,
      MenuItem? menuItemProvider}) async {
    final ImagePicker picker = ImagePicker();
    try {
      switch (uploadType) {
        case ImageUploadType.profilePicture:
          var pickedImage = await picker.pickImage(source: ImageSource.gallery);
          if (pickedImage != null && merchantStructure != null) {
            merchantStructure.setMerchantProfileImage = pickedImage.path;
          }
          break;

        case ImageUploadType.businessImage:
          var pickedImages = await picker.pickMultiImage();
          if (pickedImages.isNotEmpty && merchantStructure != null) {
            for (int i = 0;
                i < pickedImages.length &&
                    i < merchantStructure.merchantBusinessImages.length;
                i++) {
              merchantStructure.setMerchantBusinessImages =
                  pickedImages[i].path;
            }
          }
          break;

        case ImageUploadType.socialMediaPost:
          var pickedImage = await picker.pickImage(source: ImageSource.gallery);
          if (pickedImage != null && context.mounted) {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        SocialMediaPostUploadUi(postImage: pickedImage.path)));
          }
        case ImageUploadType.menuItem:
          var pickedImage = await picker.pickImage(source: ImageSource.gallery);
          if (pickedImage != null && context.mounted) {
            menuItemProvider!.itemImage = pickedImage.path;
          }
          break;
      }
    } on PlatformException {
      if (context.mounted) {
        handleGalleryError(context);
      }
    } catch (e) {
      showToast('Error occurred, please try again', Colors.red, Colors.white,
          'SHORT');
    }
  }
}
