import 'package:flutter/material.dart';
import 'package:icons_flutter/icons_flutter.dart';
import 'package:provider/provider.dart';
import 'package:thingsonwheels/Image%20Upload/image_upload_helper.dart';
import 'package:thingsonwheels/Merchant%20Sign%20Up/merchant_structure.dart';
import '../main.dart';
import 'custom_alert_dialog.dart';

class ImageAddEmptyContainer extends StatefulWidget {
  const ImageAddEmptyContainer(
      {super.key,
      required this.iconSize,
      required this.width,
      required this.height,
      required this.imageIndex});

  final double iconSize;
  final double width;
  final double height;
  final String? imageIndex;

  @override
  State<ImageAddEmptyContainer> createState() => _ImageAddEmptyContainerState();
}

class _ImageAddEmptyContainerState extends State<ImageAddEmptyContainer> {
  @override
  Widget build(BuildContext context) {
    final classProvider = Provider.of<MerchantStructure>(context);
    ImageUploadHelper imageUploadHelper = ImageUploadHelper();
    return GestureDetector(
      onTap: () {
        imageUploadHelper.chooseFromCameraOrGalleryUI(
            context, classProvider,
            uploadType: ImageUploadType.businessImage);
      },
      child: Stack(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(15),
            child: Container(
              color: const Color(0xFFD9D9D9),
              width: widget.width,
              height: widget.height,
              child: Center(
                child: widget.imageIndex == null
                    ? Icon(
                        FontAwesome.image,
                        color: Colors.grey.shade500,
                        size: screenWidth / 10,
                      )
                    : Image(
                        image: AssetImage(widget.imageIndex!),
                        fit: BoxFit.cover,
                      ),
              ),
            ),
          ),
          Positioned(
              right: 0,
              top: 0,
              child: GestureDetector(
                onTap: () {
                  if (widget.imageIndex == null) {
                    imageUploadHelper.chooseFromCameraOrGalleryUI(
                        context, classProvider,
                        uploadType: ImageUploadType.profilePicture);
                  } else {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return CreateAlertDialog(
                            icon: Icons.question_mark_rounded,
                            leftButtonText: 'Cancel',
                            dialogTheme: Colors.red,
                            rightButtonText: 'Delete',
                            titleText: 'Are you sure? ',
                            contentText:
                                'Do you really want to delete this image?',
                            classProvider: classProvider,
                            imageUploadType: ImageUploadType.businessImage,
                            imageIndexToBeDeleted:
                                classProvider.merchantBusinessImages
                                .indexOf(widget.imageIndex));
                      },
                    );
                  }
                },
                child: widget.imageIndex != null
                    ? CircleAvatar(
                        backgroundColor: Colors.grey.shade200,
                        radius: screenWidth / 19,
                        child: Icon(Icons.edit_rounded,
                            color: Colors.black, size: screenWidth / 19))
                    : Container(),
              )),
        ],
      ),
    );
  }
}
