import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:page_view_indicators/circle_page_indicator.dart';
import 'package:thingsonwheels/AppSettings/app_settings_ui.dart';
import 'package:thingsonwheels/MerchantsOnTow/merchant_home_screen_full_image_display.dart';
import '../main.dart';
import 'merchant_home_screen_image_edit.dart';
import 'live_indicator_button_ui.dart';
import 'merchant_service.dart';

class MerchantProfileScreen extends StatefulWidget {
  final List<String?>? updatedImages;

  const MerchantProfileScreen({Key? key, this.updatedImages}) : super(key: key);

  @override
  MerchantProfileScreenState createState() => MerchantProfileScreenState();
}

class MerchantProfileScreenState extends State<MerchantProfileScreen> {
  bool updateLoading = false;
  final _currentPageNotifier = ValueNotifier<int>(0);
  late Future<Map<String, dynamic>> merchantInfoFuture;
  final ScrollController _scrollController = ScrollController();
  bool isEditing = false;
  TextEditingController businessContactEditor = TextEditingController();
  TextEditingController emailEditor = TextEditingController();
  TextEditingController addressEditor = TextEditingController();
  TextEditingController facebookLinkEditor = TextEditingController();
  TextEditingController tiktokLinkEditor = TextEditingController();
  TextEditingController instagramLinkEditor = TextEditingController();
  final _formKey = GlobalKey<FormState>(); // GlobalKey for the Form
  final MerchantsOnTOWService merchantsOnTOWService = MerchantsOnTOWService();
  bool goLiveButtonPressed = false;
  String merchantCity = '';
  final List<String> _cities = ['Fresno', 'Santa Maria'];

  @override
  void initState() {
    super.initState();
    merchantInfoFuture = getMerchantInfo();
  }

  @override
  void dispose() {
    merchantsOnTOWService.dispose();
    _currentPageNotifier.dispose();
    _scrollController.dispose();
    businessContactEditor.dispose();
    emailEditor.dispose();
    facebookLinkEditor.dispose();
    tiktokLinkEditor.dispose();
    instagramLinkEditor.dispose();
    super.dispose();
  }

  bool areListsEqual(List<String?> list1, List<String?> list2) {
    if (list1.length != list2.length) return false;
    for (int i = 0; i < list1.length; i++) {
      if (list1[i] != list2[i]) return false;
    }
    return true;
  }

  Future<Map<String, dynamic>> getMerchantInfo() async {
    return await merchantsOnTOWService.getMerchantInfo();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: Platform.isIOS ? false : true,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          leading: InkWell(
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => const AppSettings()));
            },
            child: Icon(
              size: screenWidth / 12,
              Icons.change_circle,
              color: colorTheme,
            ),
          ),
        ),
        body: FutureBuilder<Map<String, dynamic>>(
          future: merchantInfoFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                  child: CircularProgressIndicator(
                color: Colors.black,
                strokeWidth: 7,
              ));
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else {
              var merchantInfo = snapshot.data!;
              return RefreshIndicator(
                color: Colors.white,
                backgroundColor: colorTheme,
                onRefresh: () async {
                  await Future.delayed(const Duration(seconds: 2));

                  if (mounted) {
                    setState(() {
                      merchantInfoFuture =
                          merchantsOnTOWService.getMerchantInfo();
                    });
                  }
                  return Future(() => merchantInfoFuture);
                },
                child: SingleChildScrollView(
                  controller: _scrollController,
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        RichText(
                          text: TextSpan(
                            text:
                                '${merchantInfo['merchantName']}\'s${' '}${'Profile'.tr()}',
                            style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: MediaQuery.of(context).size.height / 37,
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        StreamBuilder(
                            stream: merchantsOnTOWService.getIsLiveStream(),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return const Center(
                                    child: CircularProgressIndicator(
                                  color: Colors.black87,
                                ));
                              }
                              if (snapshot.hasError) {
                                return const Center(
                                    child: Text(
                                        "Error fetching live information"));
                              } else if (snapshot.hasData) {
                                return LiveIndicatorButtonProfile(
                                    isLive: snapshot.data!,
                                    onTap: () async {
                                      setState(() {
                                        goLiveButtonPressed =
                                            !goLiveButtonPressed;
                                      });

                                      if (goLiveButtonPressed) {
                                        await merchantsOnTOWService.goLive();
                                      } else {
                                        await merchantsOnTOWService.goOffLive();
                                      }
                                    });
                              } else {
                                return const SizedBox.shrink();
                              }
                            }),
                        _buildMerchantBusinessImages(merchantInfo),
                        Padding(
                            padding: const EdgeInsets.only(top: 20),
                            child: circleIndicator(
                                merchantInfo['merchantBusinessImages'].length)),
                        const SizedBox(height: 50),
                        ListTile(
                          title: Text(
                            'Business Contact Number'.tr(),
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          subtitle: TextFormField(
                            maxLength: 10,
                            controller: businessContactEditor,
                            decoration: InputDecoration(
                              hintText:
                                  merchantInfo['merchantBusinessMobileNum'],
                              prefixIcon: const Icon(Icons.phone),
                              border: const OutlineInputBorder(),
                            ),
                            validator: (value) {
                              if (value!.isEmpty) {
                                return null; // Return null to indicate no error when the field is empty
                              }
                              final nonNumericRegExp = RegExp(
                                  r'^[0-9]+$'); //RegExp to match the phone number
                              //check if the number isWithin 0-9.
                              if (!nonNumericRegExp.hasMatch(value)) {
                                return 'Phone number must contain only digits'
                                    .tr(); //
                              }
                              if (value.length <
                                  10) //Make sure the number is a total of 10 digits.
                              {
                                return 'Number should be a ten digit number'
                                    .tr();
                              }
                              return null;
                            },
                          ),
                        ),
                        ListTile(
                          title: Text(
                            'Business Email'.tr(),
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          subtitle: TextFormField(
                            controller: emailEditor,
                            decoration: InputDecoration(
                              hintText: merchantInfo['merchantEmail'],
                              // Assuming you have 'merchantBusinessEmail' in your data
                              prefixIcon: const Icon(Icons.email),
                              border: const OutlineInputBorder(),
                            ),
                            validator: (value) {
                              if (value!.isEmpty) {
                                return null; // Return null to indicate no error when the field is empty
                              }
                              final emailRegExp = RegExp(
                                  r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');
                              if (!emailRegExp.hasMatch(value)) {
                                return "Please enter a valid email address"
                                    .tr();
                              }
                              return null; // Return null if validation passes
                            },
                          ),
                        ),
                        ListTile(
                          title: Text(
                            'Business Address'.tr(),
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          subtitle: TextField(
                            controller: addressEditor,
                            decoration: InputDecoration(
                              hintText: merchantInfo['merchantBusinessAddr'],
                              prefixIcon: const Icon(Icons.location_on),
                              border: const OutlineInputBorder(),
                            ),
                          ),
                        ),
                        ListTile(
                          title: const Text(
                            'Facebook',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          subtitle: TextFormField(
                            controller: facebookLinkEditor,
                            decoration: InputDecoration(
                              hintText: merchantInfo['socialLink']
                                      ['facebook'].toString().isEmpty ?
                                  'enter_facebook_link'.tr(): merchantInfo['socialLink']
                              ['facebook'],
                              prefixIcon: const Icon(Icons.facebook),
                              border: const OutlineInputBorder(),
                            ),
                            validator: (value) {
                              if (value!.isEmpty) {
                                return null; // No validation error if field is empty
                              }
                              // Optionally, you can add more specific validation rules for social links
                              // Example: Check if it starts with http:// or https://
                              if (!value.startsWith('http://') &&
                                  !value.startsWith('https://')) {
                                return 'Please enter a valid URL'.tr();
                              }
                              return null; // Return null if validation passes
                            },
                          ),
                        ),
                        ListTile(
                          title: const Text(
                            'Instagram',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          subtitle: TextFormField(
                            controller: instagramLinkEditor,
                            decoration: InputDecoration(
                              hintText: merchantInfo['socialLink']
                              ['instagram'].toString().isEmpty ?
                              'enter_instagram_link'.tr(): merchantInfo['socialLink']
                              ['instagram'],
                              prefixIcon: const Icon(FontAwesomeIcons.instagram),
                              border: const OutlineInputBorder(),
                            ),
                            validator: (value) {
                              if (value!.isEmpty) {
                                return null; // No validation error if field is empty
                              }
                              // Optionally, you can add more specific validation rules for social links
                              // Example: Check if it starts with http:// or https://
                              if (!value.startsWith('http://') &&
                                  !value.startsWith('https://')) {
                                return 'Please enter a valid URL'.tr();
                              }
                              return null; // Return null if validation passes
                            },
                          ),
                        ),
                        ListTile(
                          title: const Text(
                            'Tiktok',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          subtitle: TextFormField(
                            controller: tiktokLinkEditor,
                            decoration: InputDecoration(
                              hintText: merchantInfo['socialLink']
                                      ['tiktok'].toString().isEmpty ?
                                  'enter_tiktok_link'.tr() :  merchantInfo['socialLink']
                              ['tiktok'],
                              prefixIcon: const Icon(Icons.tiktok),
                              border: const OutlineInputBorder(),
                            ),
                            validator: (value) {
                              if (value!.isEmpty) {
                                return null; // No validation error if field is empty
                              }
                              // Optionally, you can add more specific validation rules for social links
                              // Example: Check if it starts with http:// or https://
                              if (!value.startsWith('http://') &&
                                  !value.startsWith('https://')) {
                                return 'Please enter a valid URL'.tr();
                              }
                              return null; // Return null if validation passes
                            },
                          ),
                        ),

                        Padding(
                          padding: const EdgeInsets.only(
                              top: 25, left: 17, right: 23),
                          child: DropdownButtonFormField<String>(
                            decoration: InputDecoration(
                              labelText: 'Your City'.tr(),
                              labelStyle: const TextStyle(
                                  color: Colors.black,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold),
                              border: const OutlineInputBorder(),
                            ),
                            items: _cities.map((String city) {
                              return DropdownMenuItem<String>(
                                value: city,
                                child: Text(city),
                              );
                            }).toList(),
                            validator: (value) {
                              return null;
                            },
                            onChanged: (value) {
                              setState(() {
                                merchantCity = value!;
                              });
                            },
                          ),
                        ),
                        const SizedBox(height: 20),
                        ElevatedButton(
                          style: ButtonStyle(
                            backgroundColor:
                                WidgetStateProperty.all(Colors.orange),
                            shape:
                                WidgetStateProperty.all<RoundedRectangleBorder>(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12.0),
                              ),
                            ),
                          ),
                          onPressed: () async {
                            String? contactNum =
                                businessContactEditor.text.isNotEmpty
                                    ? businessContactEditor.text
                                    : null;
                            String? merchantEmail = emailEditor.text.isNotEmpty
                                ? emailEditor.text
                                : null;
                            String? facebookLink = facebookLinkEditor.text.isNotEmpty ? facebookLinkEditor.text : null;
                            String? tiktokLink = tiktokLinkEditor.text.isNotEmpty ? tiktokLinkEditor.text : null;
                            String? instagramLink = instagramLinkEditor.text.isNotEmpty ? instagramLinkEditor.text : null;

                            String? address = addressEditor.text.isNotEmpty
                                ? addressEditor.text
                                : null;

                            String? currentAddress = merchantInfo['merchantBusinessAddr'];
                            String? currentContactNum = merchantInfo['merchantBusinessMobileNum'];
                            String? currentMerchantEmail = merchantInfo['merchantEmail'];
                            String? currentInstagramLink = merchantInfo['socialLink']['instagram'];
                            String? currentFacebookLink = merchantInfo['socialLink']['facebook'];
                            String? currentTikTokLink = merchantInfo['socialLink']['tiktok'];
                            List<String?> currentImageUrls = merchantInfo['merchantBusinessImages'].cast<String?>();

                            List<String?> newImageUrls = currentImageUrls;
                            if (widget.updatedImages != null) {
                              newImageUrls = await merchantsOnTOWService
                                  .newImageUpload(widget.updatedImages!);
                            }

                            bool imagesChanged = !areListsEqual(currentImageUrls, newImageUrls);

                            Map<String, dynamic> updates = {};

                            if (contactNum != null &&
                                contactNum != currentContactNum) {
                              updates['merchantBusinessMobileNum'] = contactNum;
                            }
                            if (merchantEmail != null &&
                                merchantEmail != currentMerchantEmail) {
                              updates['merchantEmail'] = merchantEmail;
                            }
                            if (merchantCity.isNotEmpty &&
                                merchantCity != merchantInfo['merchantCity']) {
                              updates['merchantCity'] = merchantCity;
                            }


                            if (facebookLink != null && facebookLink != currentFacebookLink) {
                              updates['facebook'] = facebookLink;
                            }
                            if (instagramLink != null && instagramLink != currentInstagramLink) {
                              updates['instagram'] = instagramLink;
                            }
                            if (tiktokLink != null && tiktokLink != currentTikTokLink) {
                              updates['tiktok'] = tiktokLink;
                            }

                            if (address != null && address != currentAddress) {
                              updates['merchantBusinessAddr'] = address;
                            }
                            if (imagesChanged) {
                              updates['merchantBusinessImages'] = newImageUrls;
                            }

                            if (updates.isEmpty) {
                              // No changes detected
                              Fluttertoast.showToast(
                                msg: 'Make some changes in order ot save them.'
                                    .tr(),
                                toastLength: Toast.LENGTH_SHORT,
                                gravity: ToastGravity.CENTER,
                                backgroundColor: Colors.lightBlue,
                                textColor: Colors.white,
                              );
                            } else {
                              // Changes detected, proceed with update
                              if (context.mounted) {
                                showDialog(
                                  context: context,
                                  barrierDismissible: false,
                                  builder: (BuildContext dialogContext) {
                                    return Center(
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          const CircularProgressIndicator(
                                            color: Colors.white,
                                            strokeWidth: 6,
                                          ),
                                          DefaultTextStyle(
                                            style: TextStyle(
                                                fontSize: screenWidth / 28),
                                            child: const Text(
                                              'Saving changes...',
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                );
                              }

                              // Validate form fields
                              if (_formKey.currentState!.validate()) {
                                bool isUploaded = await merchantsOnTOWService.updateMerchantInfo(updates);

                                if (isUploaded) {
                                  Fluttertoast.showToast(
                                    msg: 'Your info was successfully updated.',
                                    toastLength: Toast.LENGTH_SHORT,
                                    gravity: ToastGravity.CENTER,
                                    backgroundColor: Colors.green,
                                    textColor: Colors.white,
                                  );
                                } else {
                                  Fluttertoast.showToast(
                                    msg:
                                        'Failed to update your info. Please try again',
                                    toastLength: Toast.LENGTH_SHORT,
                                    gravity: ToastGravity.CENTER,
                                    backgroundColor: Colors.red,
                                    textColor: Colors.white,
                                  );
                                }
                                setState(() {
                                  isUploaded = false;
                                  updates = <String, dynamic>{};
                                  Navigator.of(context).pop();
                                });
                              }
                              else {
                                setState(() {
                                  updates = {};
                                  Navigator.of(context).pop();
                                });
                              }
                            }
                          },
                          child: Text(
                            'Save Changes'.tr(),
                            style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                        const SizedBox(height: 30),
                      ],
                    ),
                  ),
                ),
              );
            }
          },
        ),
      ),
    );
  }

  Widget _buildMerchantBusinessImages(Map<String, dynamic> merchantImages) {
    List<String?> imageUrls =
        (merchantImages['merchantBusinessImages'] as List<dynamic>)
            .map((e) => e as String?)
            .toList();

    return Column(
      children: [
        Align(
            alignment: Alignment.topRight,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: InkWell(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ImageEditSection(
                                imageUrls: imageUrls,
                              )));
                },
                child: Icon(
                  Icons.edit,
                  color: colorTheme,
                  size: 30,
                ),
              ),
            )),
        SizedBox(
            width: screenWidth,
            height: screenHeight - 550,
            child: PageView.builder(
              onPageChanged: (page) {
                setState(() {
                  _currentPageNotifier.value = page;
                });
              },
              itemCount: imageUrls.length,
              itemBuilder: (context, index) {
                String? imageUrl = imageUrls[index];
                return GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  DetailedMerchantImageDisplay(
                                      image: imageUrl!)));
                    },
                    child: buildImageWidget(imageUrl));
              },
            )),
      ],
    );
  }

  Widget buildImageWidget(String? imagePath) {
    if (imagePath != null) {
      return FittedBox(
          fit: BoxFit.contain,
          child: CachedNetworkImage(
            imageUrl: imagePath,
          ));
    } else {
      return Container(
        color: Colors.grey,
      );
    }
  }

  Widget circleIndicator(int countOfImages) {
    return CirclePageIndicator(
      selectedDotColor: Colors.black,
      dotColor: Colors.black,
      size: screenWidth / 30,
      selectedSize: screenWidth / 26,
      itemCount: countOfImages,
      currentPageNotifier: _currentPageNotifier,
    );
  }
}
