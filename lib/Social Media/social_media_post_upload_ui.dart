import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:thingsonwheels/IconFiles/app_icons_icons.dart';
import 'package:thingsonwheels/Reusable%20Widgets/create_a_button.dart';
import 'package:thingsonwheels/Reusable%20Widgets/custom_text_form.dart';
import 'package:thingsonwheels/Reusable%20Widgets/text_form_validators.dart';
import 'package:thingsonwheels/Reusable%20Widgets/toast_widget.dart';
import 'package:thingsonwheels/Social%20Media/post_upload_state.dart';
import 'package:thingsonwheels/Social%20Media/social_media_post_structure.dart';
import 'package:thingsonwheels/home_screen.dart';
import '../main.dart';

class SocialMediaPostUploadUi extends StatefulWidget {
  const SocialMediaPostUploadUi({super.key, required this.postImage});

  final String postImage;

  @override
  SocialMediaPostUploadUiState createState() => SocialMediaPostUploadUiState();
}

class SocialMediaPostUploadUiState extends State<SocialMediaPostUploadUi> {
  final _captionKey = GlobalKey<FormState>();
  late PostUploadState postUploadStateProvider;
  TextEditingController captionController = TextEditingController();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    postUploadStateProvider = context.watch<PostUploadState>();
  }

  @override
  void dispose() {
    super.dispose();
    captionController.dispose();
  }

  void _startUploadingAPost(BuildContext context) async {
    if (_captionKey.currentState!.validate()) {
      postUploadStateProvider.uploadState = PostUploadStateEnum.loading;
      String postImage = await postUploadStateProvider.getImageUrlFromFirebaseStorage(widget.postImage);
      if (postImage.isNotEmpty) {
        SocialMediaPostStructure socialMediaPostStructure =
            SocialMediaPostStructure(
          caption:
              captionController.text.isNotEmpty ? captionController.text : null,
          userName: FirebaseAuth.instance.currentUser!.displayName!,
          userProfileImage: FirebaseAuth.instance.currentUser!.photoURL,
          postImage: postImage,
          likes: 0,
          comments: [],
        );
        await postUploadStateProvider.uploadPost(socialMediaPostStructure);
      }
      switch (postUploadStateProvider.uploadState) {
        case PostUploadStateEnum.success:
          if (context.mounted) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const HomeScreen()),
            );
            showToast("Your post has been uploaded!", Colors.green,
                Colors.white, "LONG");
          }
          break;

        case PostUploadStateEnum.error:
          if (context.mounted) {
            setState(() {
              return;
            });
          }
          break;
        default:
          break;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(screenWidth / 5),
        child: AppBar(
          automaticallyImplyLeading: false, // Hide default back arrow
          backgroundColor: Colors.red, // AppBar background color
          elevation: 0, // Remove shadow
          flexibleSpace: SafeArea(
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                // Align items vertically
                children: [
                  GestureDetector(
                    onTap: () {},
                    child: Icon(
                      AppIcons.keyboard_backspace,
                      color: Colors.white,
                      size: screenWidth / 20,
                    ),
                  ),
                  Expanded(
                    child: Align(
                      alignment: Alignment.center, // Center the title
                      child: Text(
                        "Post an Image",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: screenWidth / 17,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(left: 20, right: 20),
          child: Form(
            key: _captionKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(
                  height: 20,
                ),
                Container(
                  height: screenHeight / 3.5,
                  width: screenWidth - 40,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: const Color(0xFFD9D9D9)),
                  child: Image.asset(
                    widget.postImage,
                    fit: BoxFit.contain,
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                CustomTextForms(
                  keyBoardType: TextInputType.name,
                  hintText: 'Enter a caption',
                  hideText: false,
                  validator: TextFormValidators.validateCaption,
                  controller: captionController,
                )
              ],
            ),
          ),
        ),
      ),
      bottomSheet: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.white, // Background color of the container
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2), // Shadow color
              blurRadius: 30, // Blur radius of the shadow
              offset: const Offset(0, 5), // Offset of the shadow
            ),
          ],
        ),
        padding: EdgeInsets.only(
            top: 15, bottom: screenWidth / 8, left: 20, right: 20),
        child: GestureDetector(
          onTap: () async {
            _startUploadingAPost(context);
          },
          child:
              postUploadStateProvider.uploadState == PostUploadStateEnum.loading
                  ? Image.asset(
                      'assets/GIFs/loading_indicator.gif',
                      scale: 13,
                    )
                  : CreateAButton(
                      width: screenWidth - 40,
                      height: screenWidth / 8,
                      buttonColor: Colors.red,
                      buttonText: 'Post',
                      textSize: screenWidth / 22,
                      textColor: Colors.white,
                      borderRadius: 30),
        ),
      ),
    );
  }
}
