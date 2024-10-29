import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:thingsonwheels/Merchant%20Sign%20Up/merchant_structure.dart';
import 'package:thingsonwheels/Reusable%20Widgets/image_add_empty_container.dart';
import 'package:thingsonwheels/main.dart';

class MerchantBusinessImageUpload extends StatefulWidget {
  const MerchantBusinessImageUpload({Key? key}) : super(key: key);

  @override
  State<MerchantBusinessImageUpload> createState() =>
      MerchantBusinessImageUploadState();
}

class MerchantBusinessImageUploadState extends State<MerchantBusinessImageUpload> {
  late MerchantStructure merchantStructureProvider;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    merchantStructureProvider = context.watch<MerchantStructure>();
  }

 /* Future<void> signUpMerchant() async {
    merchantStructureProvider.setMerchantSignUpState =
        MerchantSignUpStateEnum.loading;
    if (merchantStructureProvider.merchantBusinessImages.isNotEmpty &&
        merchantStructureProvider.merchantBusinessImages[0] != null) {
      await merchantStructureProvider.uploadMerchantInformation();

      // Handle success or error states
      if (!mounted) return; // Ensuring that the  widget is still mounted
      switch (merchantStructureProvider.merchantSignUpState) {
        case MerchantSignUpStateEnum.success:
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const HomeScreen()),
          );
          break;

        case MerchantSignUpStateEnum.error:
          Navigator.pop(context);
          showToast('An error occurred during sign-up', Colors.red,
              Colors.white, "SHORT");
          break;

        default:
          break;
      }
    } else {
      // Show error if no business image is provided
      showToast('You need to have at least one main image for your business',
          Colors.red, Colors.white, "SHORT");
    }
  }

  */

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: screenHeight + 150,
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Add Business Images",
              style: TextStyle(
                  color: const Color(0xFF505050),
                  fontSize: screenWidth / 15,
                  fontWeight: FontWeight.bold),
            ),
            const SizedBox(
              height: 15,
            ),
            Text(
              "2 or more photos are better than 1, Add more photos to increase the visibility of your business profile. Add Images of better quality",
              style: TextStyle(
                color: Colors.black,
                fontSize: screenWidth / 28,
              ),
            ),
            const SizedBox(
              height: 50,
            ),
            ImageAddEmptyContainer(
                iconSize: screenWidth / 5,
                width: screenWidth - 40,
                height: screenWidth / 2,
                imageIndex: merchantStructureProvider.merchantBusinessImages
                    .elementAt(0) // Access image if index exists
                ),
            const SizedBox(
              height: 15,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ImageAddEmptyContainer(
                    iconSize: screenWidth / 5,
                    width: screenWidth / 3.5,
                    height: screenWidth / 3.5,
                    imageIndex: merchantStructureProvider.merchantBusinessImages
                        .elementAt(1)),
                ImageAddEmptyContainer(
                  iconSize: screenWidth / 5,
                  width: screenWidth / 3.5,
                  height: screenWidth / 3.5,
                  imageIndex: merchantStructureProvider.merchantBusinessImages
                      .elementAt(2),
                ),
                ImageAddEmptyContainer(
                    iconSize: screenWidth / 5,
                    width: screenWidth / 3.5,
                    height: screenWidth / 3.5,
                    imageIndex: merchantStructureProvider.merchantBusinessImages
                        .elementAt(3)),
              ],
            ),
            const SizedBox(
              height: 15,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ImageAddEmptyContainer(
                    iconSize: screenWidth / 5,
                    width: screenWidth / 3.5,
                    height: screenWidth / 3.5,
                    imageIndex: merchantStructureProvider.merchantBusinessImages
                        .elementAt(4)),
                ImageAddEmptyContainer(
                  iconSize: screenWidth / 5,
                  width: screenWidth / 3.5,
                  height: screenWidth / 3.5,
                  imageIndex: merchantStructureProvider.merchantBusinessImages
                      .elementAt(5),
                ),
                ImageAddEmptyContainer(
                    iconSize: screenWidth / 5,
                    width: screenWidth / 3.5,
                    height: screenWidth / 3.5,
                    imageIndex: merchantStructureProvider.merchantBusinessImages
                        .elementAt(6)),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
