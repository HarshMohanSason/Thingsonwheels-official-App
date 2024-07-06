
import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:thingsonwheels/TowDisplay/live_indicator_button_ui.dart';
import 'package:thingsonwheels/TowDisplay/zoomed_in_image_display.dart';
import 'package:url_launcher/url_launcher_string.dart';
import '../main.dart';
import 'tow_service.dart';
import 'package:page_view_indicators/circle_page_indicator.dart';

class TowDetailedDisplayUI extends StatefulWidget {
  final TowService foodTruck;

  const TowDetailedDisplayUI({super.key, required this.foodTruck});

  @override
  TowDetailedDisplayUIState createState() =>
      TowDetailedDisplayUIState();
}

class TowDetailedDisplayUIState extends State<TowDetailedDisplayUI> {
  final _currentPageNotifier = ValueNotifier<int>(0);

  void launchMap(String address) async {
    String mapUrl;

    if (Platform.isIOS) {
      // Launch Apple Maps
      mapUrl = "http://maps.apple.com/?q=$address";
    } else {
      // Launch Google Maps
      mapUrl = "https://www.google.com/maps/search/?api=1&query=$address";
    }

    if (await canLaunchUrlString(mapUrl)) {
      await launchUrlString(mapUrl);
    } else {
      Fluttertoast.showToast(
        msg: 'Could not launch the link',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: screenWidth / 25, // Adjust text size as needed
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: Platform.isAndroid ? true: false,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Padding(
            padding: const EdgeInsets.only(left: 16.0, right: 16, bottom: 16, top: 40),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(top: 10),
                  child: InkWell(
                    onTap: () => Navigator.pop(context),
                    child: Icon(
                      Icons.arrow_back,
                      size: screenWidth / 14,
                      color: Colors.black,
                    ),
                  ),
                ),
                const SizedBox(height: 50),
                _buildDetailedFoodTruckUI(widget.foodTruck),
                const SizedBox(height: 20),
                Center(child: circleIndicator()),
                const SizedBox(height: 30),
                Row(
                  children: [
                    Text(
                      widget.foodTruck.truckName,
                      style: TextStyle(
                        fontSize: screenWidth / 14, // Adjusted font size
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Spacer(),
                    StreamBuilder(
                      stream: TowService.getLiveStatusStream(),
                      builder: (BuildContext context,
                          AsyncSnapshot<Map<String, bool>> snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting ||
                            snapshot.connectionState == ConnectionState.none) {
                          return const LiveIndicator(isLive: false, size: 22);
                        } else {
                          return LiveIndicator(
                            isLive: snapshot.data![widget.foodTruck.docID]!,
                            size: 22,
                          );
                        }
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 60),
                _buildContactRow(),
                const SizedBox(height: 60),
                if (widget.foodTruck.socialLink.isNotEmpty)
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _buildSocialMediaLink(
                          'facebook', widget.foodTruck.socialLink['facebook']),
                      const SizedBox(width: 10),
                      _buildSocialMediaLink('instagram',
                          widget.foodTruck.socialLink['instagram']),
                      const SizedBox(width: 10),
                      _buildSocialMediaLink(
                          'tiktok', widget.foodTruck.socialLink['tiktok'])
                    ],
                  ),

              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDetailedFoodTruckUI(TowService foodTruck) {
    List<String> imageUrls = foodTruck.truckImages!;
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 5,
            blurRadius: 7,
            offset: const Offset(0, 3), // changes position of shadow
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(15),
        child: Container(
          color: Colors.white,
          width: screenWidth,
          height: screenHeight / 2.5,
          child: PageView.builder(
            onPageChanged: (page) {
              setState(() {
                _currentPageNotifier.value = page;
              });
            },
            itemCount: imageUrls.length,
            itemBuilder: (context, index) {
              String imageUrl = imageUrls[index];
              return InkWell
                (onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => FullImageView(imageUrls: foodTruck.truckImages!, currImageIndex: index,))),
                  child: buildImageWidget(imageUrl));
            },
          ),
        ),
      ),
    );
  }

  Widget buildImageWidget(String imagePath) {
    if (imagePath.isNotEmpty) {
      return FittedBox(
        fit: BoxFit.cover,
        child: CachedNetworkImage(
          imageUrl:
          imagePath,
        ),
      );
    } else {
      return Container(
        color: Colors.grey,
      );
    }
  }

  Widget circleIndicator() {
    return CirclePageIndicator(
      selectedDotColor: Colors.black,
      dotColor: Colors.grey,
      size: screenWidth / 30,
      selectedSize: screenWidth / 26,
      itemCount: widget.foodTruck.truckImages!.length,
      currentPageNotifier: _currentPageNotifier,
    );
  }

  Widget _buildContactRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildIconButton(Icons.phone,
            "No phone number available, check social media".tr(), () {
              if (widget.foodTruck.truckPhoneNo!.isNotEmpty) {
                launchUrlString(
                    'tel:+1${widget.foodTruck.truckPhoneNo.toString()}');
              }
            }),
        const SizedBox(width: 20),
        _buildIconButton(Icons.location_on,
            "Location varies, check social media for daily updates".tr(), () {
              if (widget.foodTruck.truckAddress!.isNotEmpty) {
                launchMap(widget.foodTruck.truckAddress!);
              }
            }),
      ],
    );
  }

  Widget _buildIconButton(IconData icon, String toastMessage,
      VoidCallback onTap) {
    return InkWell(
      onTap: () {
        onTap();
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: LinearGradient(
            colors: [Colors.orange.shade400, Colors.orange.shade600],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              spreadRadius: 4,
              blurRadius: 8,
              offset: const Offset(2, 4), // changes position of shadow
            ),
          ],
        ),
        child: Icon(
          icon,
          size: screenHeight / 30,
          color: Colors.white,
        ),
      ),
    );
  }

  Widget _buildSocialMediaLink(String socialMediaType, String? socialLink) {
    IconData icon;
    Color color = Colors.black;

    // Determine icon based on social media type
    switch (socialMediaType) {
      case 'facebook':
        icon = FontAwesomeIcons.facebook;
        color = Colors.blue;
        break;
      case 'instagram':
        icon = FontAwesomeIcons.instagram;
        color = Colors.pink;
        break;
      case 'tiktok':
        icon = FontAwesomeIcons.tiktok;
        color = Colors.black;
        break;
      default:
        icon = Icons.link; // Default icon if social media type is unknown
    }

    return socialLink != null && socialLink.isNotEmpty
        ? InkWell(
      onTap: () async {
        if (await canLaunchUrlString(socialLink)) {
          await launchUrlString(socialLink);
        } else {
          Fluttertoast.showToast(
            msg: 'Could not launch the link'.tr(),
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            backgroundColor: Colors.red,
            textColor: Colors.white,
          );
        }
      },
      child: Icon(
        icon,
        size: screenWidth / 12,
        color: color,
      ),
    )
        : Container();
  }
}
