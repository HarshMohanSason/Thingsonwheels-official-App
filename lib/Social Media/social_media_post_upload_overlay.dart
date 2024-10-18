import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:icons_flutter/icons_flutter.dart';
import 'package:thingsonwheels/Image%20Upload/camera_ui.dart';
import 'package:thingsonwheels/Image%20Upload/image_upload_helper.dart';
import '../main.dart';

class SocialMediaPostUploadOverlay extends ModalRoute<void> {
  final VoidCallback closeOverlay;

  SocialMediaPostUploadOverlay({Key? key, required this.closeOverlay});

  @override
  Color? get barrierColor => Colors.black.withOpacity(0.4);

  @override
  bool get barrierDismissible => false; //dismiss the barrier

  @override
  String? get barrierLabel => null;

  @override
  Widget buildPage(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation) {
    return Material(
      type: MaterialType.transparency,
      child: SafeArea(
        child: _buildOverlayContent(context),
      ),
    );
  }

  Widget _buildOverlayContent(BuildContext context) {
    return Center(
      child: Stack(
        children: <Widget>[
          Positioned(
            bottom: screenWidth / 5.2,
            right: 20,
            child: Column(
              children: [
                GestureDetector(
                  onTap: () async {
                    await ImageUploadHelper.addImageFromGallery(context,
                        uploadType: ImageUploadType.socialMediaPost);
                  },
                  child: CircleAvatar(
                    backgroundColor: Colors.white,
                    radius: screenWidth / 17,
                    child: Icon(FontAwesome.image,
                        color: Colors.red, size: screenWidth / 18),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                GestureDetector(
                  onTap: () async {
                    await availableCameras().then((value) => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) => CameraUi(
                                  cameras: value,
                                  imageUploadType:
                                      ImageUploadType.socialMediaPost,
                                ))));
                  },
                  child: CircleAvatar(
                    backgroundColor: Colors.white,
                    radius: screenWidth / 17,
                    child: Icon(FontAwesome.camera,
                        color: Colors.red, size: screenWidth / 18),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.of(context).pop();
                    setState(closeOverlay);
                  },
                  child: CircleAvatar(
                    backgroundColor: Colors.red,
                    radius: screenWidth / 13,
                    child: Icon(WebSymbols.cancel,
                        color: Colors.white, size: screenWidth / 18),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  @override
  bool get maintainState => true;

  @override
  bool get opaque => false;

  @override
  Duration get transitionDuration => const Duration(milliseconds: 200);
}
