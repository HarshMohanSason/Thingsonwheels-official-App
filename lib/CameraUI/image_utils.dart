
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

class ImageUtils {
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
                  backgroundColor: WidgetStateProperty.all<Color>(Colors.orange),
                  overlayColor: WidgetStateProperty.all<Color>(Colors.white.withOpacity(0.1)),
                  padding: WidgetStateProperty.all<EdgeInsetsGeometry>(const EdgeInsets.all(16)),
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
}
