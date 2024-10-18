import 'package:flutter/material.dart';
import 'package:thingsonwheels/Image%20Upload/image_upload_helper.dart';

import '../main.dart';

//Custom class to create custom alert dialog. Uses alert dialog from flutter in built but most of the stuff is amendable
class CreateAlertDialog extends StatelessWidget {
  const CreateAlertDialog(
      {super.key,
      required this.icon,
      required this.leftButtonText,
      required this.rightButtonText,
      required this.titleText,
      required this.contentText,
      required this.dialogTheme,
      this.classProvider,
      this.imageUploadType, this.imageIndexToBeDeleted
      });

  final IconData icon;
  final String leftButtonText;
  final String rightButtonText;
  final String titleText;
  final String contentText;
  final Color dialogTheme;
  final ImageUploadType? imageUploadType; //If user wants to delete a profile
  final int? imageIndexToBeDeleted;
  final dynamic classProvider; //Passing a dynamic provider to access properties for any class

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.white,
      title: Container(
        width: screenWidth / 6,
        height: screenWidth / 6,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: Colors.red, width: 5),
        ),
        child: Icon(
          icon,
          color: dialogTheme,
          size: screenWidth / 10,
        ),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(titleText, style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.black,
              fontSize: screenWidth/17
          ),),
          const SizedBox(height: 10,),
          Text(contentText, style: TextStyle(
              color: Colors.black,
              fontSize: screenWidth/29
          ),),
        ],
      ),
      actions: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: OutlinedButton(
                style: OutlinedButton.styleFrom(
                  side:  BorderSide(color: dialogTheme), // Red outline
                  backgroundColor: Colors.white, // Inside color white
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                onPressed: () {
                  Navigator.of(context).pop(); // Just close the dialog
                },
                child: Text(
                  leftButtonText,
                  style: TextStyle(color:dialogTheme,
                  ), // Red text color
                ),
              ),
            ),
            const SizedBox(width: 30,),
            Align(
              alignment: Alignment.centerRight,
              child: OutlinedButton(
                style: OutlinedButton.styleFrom(
                  side: BorderSide(color: dialogTheme), // Red outline
                  backgroundColor: dialogTheme,// Red background
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                onPressed: () {
                if(imageUploadType == ImageUploadType.businessImage)
                    {
                     classProvider.removeMerchantBusinessImage(imageIndexToBeDeleted);
                    }
                 else{
                  classProvider.setMerchantProfileImage = null;
                  }
                  Navigator.of(context).pop(); // Close the dialog
                },
                child:  Text(rightButtonText, style: const TextStyle(
                  color: Colors.white
                ),),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
