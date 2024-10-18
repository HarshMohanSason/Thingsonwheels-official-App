import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:thingsonwheels/Merchant%20Sign%20Up/merchant_structure.dart';
import 'package:thingsonwheels/Reusable%20Widgets/custom_text_form.dart';
import 'package:thingsonwheels/Reusable%20Widgets/text_form_validators.dart';
import 'package:thingsonwheels/Image%20Upload/image_upload_helper.dart';
import 'package:thingsonwheels/main.dart';

import '../Reusable Widgets/custom_alert_dialog.dart';

class MerchantSignUpFormUi extends StatefulWidget {
  const MerchantSignUpFormUi({required this.merchantFormKey, super.key});

  final GlobalKey<FormState> merchantFormKey;

  @override
  MerchantSignUpFormUiState createState() => MerchantSignUpFormUiState();
}

class MerchantSignUpFormUiState extends State<MerchantSignUpFormUi> {
  late MerchantStructure merchantStructureProvider;
  late ImageUploadHelper imageUploadHelperProvider;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    merchantStructureProvider = context.watch<MerchantStructure>();
    imageUploadHelperProvider = context.watch<ImageUploadHelper>();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: screenHeight,
      child: Form(
        key: widget.merchantFormKey,
        child: Column(
          children: [
            Row(
              children: [
                Text(
                  "Welcome",
                  style: TextStyle(
                      color: const Color(0xFF505050),
                      fontSize: screenWidth / 12,
                      fontWeight: FontWeight.bold),
                ),
                const SizedBox(
                  width: 10,
                ),
                Icon(
                  Icons.waving_hand_outlined,
                  color: const Color(0xFF505050),
                  size: screenWidth / 13,
                )
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            Text(
              "Enter details to complete your on boarding",
              style: TextStyle(
                color: Colors.black,
                fontSize: screenWidth / 22,
              ),
            ),
            const SizedBox(
              height: 30,
            ),
            Stack(
              children: [
                CircleAvatar(
                  radius: screenWidth / 6,
                  backgroundImage:
                      merchantStructureProvider.merchantProfileImage != null
                          ? AssetImage(
                              merchantStructureProvider.merchantProfileImage!)
                          : null,
                  child: merchantStructureProvider.merchantProfileImage == null
                      ? Icon(
                          Icons.person,
                          color: Colors.red,
                          size: screenWidth / 8,
                        )
                      : null,
                ),
                Positioned(
                    right: 0,
                    bottom: 0,
                    child: GestureDetector(
                      onTap: () {
                        if (merchantStructureProvider.merchantProfileImage ==
                            null) {
                          imageUploadHelperProvider.chooseFromCameraOrGalleryUI(
                              context,
                                  merchantStructureProvider,
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
                                classProvider: merchantStructureProvider,
                              );
                            },
                          );
                        }
                      },
                      child: CircleAvatar(
                          backgroundColor: Colors.grey.shade200,
                          radius: screenWidth / 19,
                          child: Icon(Icons.edit_rounded,
                              color: Colors.black, size: screenWidth / 19)),
                    )),
              ],
            ),
            const SizedBox(
              height: 60,
            ),
            CustomTextForms(
                initialValue: merchantStructureProvider.merchantBusinessName,
                hintText: 'Enter your business name',
                labelText: 'Name',
                hideText: false,
                validator: TextFormValidators.validateBusinessName,
                onSaved: (value) =>
                    merchantStructureProvider.setMerchantBusinessName = value!),
            const SizedBox(
              height: 30,
            ),
            CustomTextForms(
              initialValue: merchantStructureProvider.merchantEmail,
              hintText: 'Enter your business email',
              labelText: 'Business Email',
              hideText: false,
              validator: TextFormValidators.validateEmail,
              onSaved: (value) =>
                  merchantStructureProvider.setMerchantEmail = value!,
            ),
            const SizedBox(
              height: 30,
            ),
            CustomTextForms(
              initialValue: merchantStructureProvider.merchantAddress,
              hintText: 'Enter your business address',
              labelText: 'Business Address',
              hideText: false,
              validator: TextFormValidators.validateBusinessAddress,
              onSaved: (value) =>
                  merchantStructureProvider.setMerchantBusinessAddress = value!,
            ),
            const SizedBox(
              height: 30,
            ),
            CustomTextForms(
              initialValue:
                  merchantStructureProvider.merchantBusinessPhoneNumber,
              hintText: 'Enter your business contact number',
              labelText: 'Contact Number',
              maxLength: 10,
              hideText: false,
              validator: TextFormValidators.validatePhoneNumber,
              onSaved: (value) => merchantStructureProvider
                  .setMerchantBusinessPhoneNumber = value!,
            ),
          ],
        ),
      ),
    );
  }
}
