import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:page_view_indicators/circle_page_indicator.dart';
import 'package:thingsonwheels/AppSettings/AppSettingsUI.dart';
import 'package:thingsonwheels/MerchantsOnTow/DetailedMerchantImageDisplay.dart';
import '../main.dart';
import 'ImageEditSection.dart';
import 'LiveIndicatorButtonProfileScreen.dart';
import 'MerchantOnTowService.dart';

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
  TextEditingController cityEditor = TextEditingController();
  TextEditingController merchantNameEditor = TextEditingController();
  TextEditingController socialLinkEditor = TextEditingController();
  final _formKey = GlobalKey<FormState>(); // GlobalKey for the Form
  final MerchantsOnTOWService merchantsOnTOWService = MerchantsOnTOWService();
  bool goLiveButtonPressed = false;

  @override
  void initState() {
    super.initState();
    merchantInfoFuture = getMerchantInfo();
  }

  @override
  void dispose() {

    _currentPageNotifier.dispose();
    _scrollController.dispose();
    merchantNameEditor.dispose();
    merchantsOnTOWService.dispose();
    businessContactEditor.dispose();
    emailEditor.dispose();
    socialLinkEditor.dispose();
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
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: InkWell(
          onTap: ()
          {
            Navigator.push(context, MaterialPageRoute(builder: (context)=> AppSettings()));
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
            return const Center(child: CircularProgressIndicator(
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
                      isEditing
                          ? TextField(
                              controller: merchantNameEditor,
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                hintText: 'Enter new name',
                                hintStyle: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                  fontSize:
                                      MediaQuery.of(context).size.height / 37,
                                ),
                              ),
                              style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                                fontSize: MediaQuery.of(context).size.height / 37,
                              ),
                              onSubmitted: (value) {
                                setState(() {
                                  isEditing = false;
                                });
                                // Handle the submitted value if needed
                              },
                            )
                          : GestureDetector(
                              onTap: () {
                                setState(() {
                                  isEditing = true;
                                  merchantNameEditor.text =
                                      merchantInfo['merchantName'];
                                });
                              },
                              child: RichText(
                                text: TextSpan(
                                  text:
                                      '${merchantInfo['merchantName']}\'s Profile',
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                    fontSize:
                                        MediaQuery.of(context).size.height / 37,
                                  ),
                                ),
                              ),
                            ),
                      const SizedBox(height: 20),
                      StreamBuilder(
                          stream: merchantsOnTOWService.getIsLiveStream(),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState == ConnectionState.waiting) {
                              return const Center(child: CircularProgressIndicator());
                            }
                            if (snapshot.hasError) {
                              return const Center(
                                  child: Text("Error fetching live information"));
                            } else if (snapshot.hasData ) {
                              return  LiveIndicatorButtonProfile(
                                isLive: snapshot.data!,
                                onTap: () async {
                                  bool isGoingLive = !goLiveButtonPressed;
                                  _scrollController.animateTo(0,
                                      duration: const Duration(milliseconds: 500),
                                      curve: Curves.easeInOut);
                                  if (isGoingLive) {
                                    await merchantsOnTOWService.goLive();
                                  } else {
                                    await merchantsOnTOWService.goOffLive();
                                  }
                                  setState(() {
                                    goLiveButtonPressed = isGoingLive;
                                  });
                                },
                              );
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
                        title: const Text(
                          'Business Contact',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        subtitle: TextFormField(
                          maxLength: 10,
                          controller: businessContactEditor,
                          decoration: InputDecoration(
                            hintText: merchantInfo['merchantBusinessMobileNum'],
                            prefixIcon: const Icon(Icons.phone),
                            border: const OutlineInputBorder(),
                          ),
                          validator: (value) {
                            final nonNumericRegExp = RegExp(
                                r'^[0-9]+$'); //RegExp to match the phone number
                            if (value!.isEmpty) {
                              //return an error if the textForm is not empty
                              return 'Please enter a valid phone number';
                            }
                            //check if the number isWithin 0-9.
                            if (!nonNumericRegExp.hasMatch(value)) {
                              return 'Phone number must contain only digits'; //
                            }
                            if (value.length <
                                10) //Make sure the number is a total of 10 digits.
                            {
                              return 'Number should be a ten digit number';
                            }
                            return null;
                          },
                        ),
                      ),
                      ListTile(
                        title: const Text(
                          'Business Email',
                          style: TextStyle(
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
                            final emailRegExp = RegExp(
                                r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');
                            if (!emailRegExp.hasMatch(value!)) {
                              return "Please enter a valid email address";
                            }
                            return null;
                          },
                        ),
                      ),
                      ListTile(
                        title: const Text(
                          'Business Address',
                          style: TextStyle(
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
                          'Social Link',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        subtitle: TextField(
                          controller: socialLinkEditor, // You need to define this controller
                          decoration: InputDecoration(
                            hintText: merchantInfo['socialLink'], // Assuming you have this field
                            prefixIcon: const Icon(Icons.link),
                            border: const OutlineInputBorder(),
                          ),
                        ),
                      ),
                      ListTile(
                        title: const Text(
                          'City',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        subtitle: TextField(
                          controller: cityEditor,
                          decoration: InputDecoration(
                            hintText: merchantInfo['merchantCity'],
                            prefixIcon: const Icon(Icons.location_city),
                            border: const OutlineInputBorder(),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      ElevatedButton(
                        style: ButtonStyle(
                          backgroundColor: WidgetStateProperty.all(Colors.orange),
                          shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12.0),
                            ),
                          ),
                        ),
                        onPressed: () async {
                            String? merchantBusinessName =
                            merchantNameEditor.text.isNotEmpty
                                ? merchantNameEditor.text
                                : null;
                            String? contactNum =
                            businessContactEditor.text.isNotEmpty
                                ? businessContactEditor.text
                                : null;
                            String? merchantEmail = emailEditor.text.isNotEmpty
                                ? emailEditor.text
                                : null;
                            String? merchantCity =
                            cityEditor.text.isNotEmpty ? cityEditor.text : null;
                            String? socialLink = socialLinkEditor.text.isNotEmpty ? socialLinkEditor.text : null;

                            // Fetch current values (assuming you have them available)
                            String? currentBusinessName = merchantInfo['merchantBusinessName'];
                            String? currentContactNum = merchantInfo['merchantBusinessMobileNum'];
                            String? currentMerchantEmail = merchantInfo['merchantEmail'];
                            String? currentMerchantCity = merchantInfo['merchantCity'];
                            String? currentSocialLink = merchantInfo['socialLink'];
                            List<String?> currentImageUrls = merchantInfo['merchantBusinessImages'].cast<String?>();
                            List<String?> newImageUrls = [];
                            if (widget.updatedImages != null) {
                              newImageUrls =
                              await merchantsOnTOWService.newImageUpload(
                                  widget.updatedImages!);
                            }
                            bool imagesChanged = areListsEqual(
                                currentImageUrls, newImageUrls);

                            Map<String, dynamic> updates = {};
                            if (merchantBusinessName != null &&
                                merchantBusinessName != currentBusinessName) {
                              updates['merchantBusinessName'] =
                                  merchantBusinessName;
                            }
                            if (contactNum != null &&
                                contactNum != currentContactNum) {
                              updates['merchantBusinessMobileNum'] = contactNum;
                            }
                            if (merchantEmail != null &&
                                merchantEmail != currentMerchantEmail) {
                              updates['merchantEmail'] = merchantEmail;
                            }
                            if (merchantCity != null &&
                                merchantCity != currentMerchantCity) {
                              updates['merchantCity'] = merchantCity;
                            }
                            if(socialLink != null && socialLink != currentSocialLink)
                              {
                                updates['socialLink'] = socialLink;
                              }

                            if (!imagesChanged) {
                              updates['merchantBusinessImages'] = newImageUrls;
                            }

                            if (updates.isEmpty) {
                              Fluttertoast.showToast(
                                msg: 'Make some changes in order to save them',
                                toastLength: Toast.LENGTH_LONG,
                                gravity: ToastGravity.CENTER,
                                backgroundColor: Colors.red,
                                textColor: Colors.white,
                                fontSize: 16.0,
                              );
                            }
                            else {
                              showDialog(
                                  context: context,
                                  barrierDismissible: false,
                                  builder: (BuildContext context) {
                                    return Center(
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment
                                            .center,
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
                                              'Save changes...',
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          )
                                        ],
                                      ),
                                    );
                                  });
                              bool isUploaded = await merchantsOnTOWService
                                  .updateMerchantInfo(updates);
                              if (isUploaded) {
                                Fluttertoast.showToast(
                                  msg: 'Your Info was submitted. Refresh to see them ',
                                  toastLength: Toast.LENGTH_SHORT,
                                  gravity: ToastGravity.CENTER,
                                  backgroundColor: Colors.green,
                                  textColor: Colors.white,
                                );
                                if (mounted) {
                                  Navigator.pop(context);
                                }
                              } else {
                                Fluttertoast.showToast(
                                  msg: 'Error uploading the info, please try again',
                                  toastLength: Toast.LENGTH_SHORT,
                                  gravity: ToastGravity.CENTER,
                                  backgroundColor: Colors.red,
                                  textColor: Colors.white,
                                );
                                if (mounted) {
                                  Navigator.pop(context);
                                }
                                setState(() {
                                  isUploaded = false;
                                });
                              }
                            }
                        },
                        child: const Text(
                          'Save Changes',
                          style: TextStyle(
                              color: Colors.white, fontWeight: FontWeight.bold),
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
    );
  }

  Widget _buildMerchantBusinessImages(Map<String, dynamic> merchantImages) {
    List<String?> imageUrls = (merchantImages['merchantBusinessImages'] as List<dynamic>).map((e) => e as String?).toList();

    return Column(
      children: [
        Align(
            alignment: Alignment.topRight,
            child: Padding(
              padding: EdgeInsets.only(bottom: 10),
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
            imageUrl:
            imagePath,
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
