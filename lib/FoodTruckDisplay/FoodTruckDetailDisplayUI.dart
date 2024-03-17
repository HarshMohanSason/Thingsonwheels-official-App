
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:url_launcher/url_launcher_string.dart';
import '../main.dart';
import 'FoodTruck.dart';
import 'package:page_view_indicators/circle_page_indicator.dart';

class FoodTruckDetailDisplayUI extends StatefulWidget {
  final FoodTruck foodTruck;

  const FoodTruckDetailDisplayUI({super.key, required this.foodTruck});

  @override
  FoodTruckDetailDisplayUIState createState() =>
      FoodTruckDetailDisplayUIState();
}

class FoodTruckDetailDisplayUIState extends State<FoodTruckDetailDisplayUI> {
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
      throw 'Could not launch $mapUrl';
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Scaffold(
          appBar: AppBar(
              backgroundColor: colorTheme,
              leading: InkWell(
                  onTap: () => Navigator.pop(context),
                  child: Icon(Icons.arrow_back,
                      size: screenWidth / 14, color: Colors.black))),
          backgroundColor: Colors.white,
          body: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Stack(children: [
                    _buildDetailedFoodTruckUI(widget.foodTruck),
                  ]),
                  Padding(
                    padding: const EdgeInsets.only(left: 15),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 10),
                        Center(child: circleIndicator()),
                        const SizedBox(height: 20),
                        Text(
                          widget.foodTruck.truckName,
                          style: TextStyle(
                            fontSize: screenWidth / 14, // Adjusted font size
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            InkWell(
                              onTap: () {
                                if(widget.foodTruck.truckPhoneNo!.isNotEmpty) {
                                  launchUrlString('tel:+1${widget.foodTruck.truckPhoneNo
                                      .toString()}');
                                }
                                else
                                  {
                                    Fluttertoast.showToast(
                                      msg: "No phone number available, check social media",
                                      toastLength: Toast.LENGTH_SHORT,
                                      gravity: ToastGravity.CENTER,
                                      backgroundColor: Colors.white,
                                      textColor: Colors.black,
                                    );
                                  }
                              },
                              child: Container(
                                padding: const EdgeInsets.all(8), // Adjust padding as needed
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.orange.withOpacity(0.5), // Adjust opacity as needed
                                ),
                                child: Icon(Icons.phone, size: screenWidth / 12),
                              ),
                            ),
                            const SizedBox(width: 20),
                            InkWell(
                              onTap: () {
                                if (widget.foodTruck.truckAddress!.isNotEmpty) {
                                  launchMap(widget.foodTruck.truckAddress!);
                                } else {
                                  Fluttertoast.showToast(
                                    msg: "Location varies, check social media for daily updates",
                                    toastLength: Toast.LENGTH_SHORT,
                                    gravity: ToastGravity.CENTER,
                                    backgroundColor: Colors.white,
                                    textColor: Colors.black,
                                  );
                                }
                              },
                              child: Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.orange.withOpacity(0.5),
                                ),
                                child: Icon(Icons.location_on, size: screenWidth / 12),
                              ),
                            ),
                            const SizedBox(width: 20),
                            InkWell(
                              onTap: () {
                                if(widget.foodTruck.truckTime!.isEmpty)
                                  {
                                    Fluttertoast.showToast(
                                      msg: "Timings vary, check social media for more information",
                                      toastLength: Toast.LENGTH_SHORT,
                                      gravity: ToastGravity.CENTER,
                                      backgroundColor: Colors.white,
                                      textColor: Colors.black,
                                    );
                                  }
                                else {
                                  buildShowTimingsDialog(context);
                                }
                              },
                              child: Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.orange.withOpacity(0.5),
                                ),
                                child: Icon(Icons.access_time, size: screenWidth / 12),
                              ),
                            ),

                          ],
                        ),

                        const SizedBox(height: 40),


                        if (widget.foodTruck.socialLink!.isNotEmpty) ...[
                          Column(
                            children: [
                              InkWell(
                                onTap: () async {
                                  if (await canLaunchUrlString(
                                      widget.foodTruck.socialLink!)) {
                                    await launchUrlString(
                                        widget.foodTruck.socialLink!);
                                  } else {
                                    throw 'Could not launch the link';
                                  }
                                },
                                child: Text(
                                  "Link to Social Media",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: screenWidth / 18,
                                    color: Colors.lightBlue,
                                  ),
                                ),
                              ),
                              const Divider(),
                            ],
                          ),
                        ],
                        const SizedBox(height: 30), // Adjusted height
                        Center(
                          child: Text(
                            widget.foodTruck.isAvailable
                                ? "Available to serve (check updated timings above)"
                                : "Not Available",
                            style: TextStyle(
                              color: widget.foodTruck.isAvailable
                                  ? Colors.green.shade700
                                  : Colors.red,
                              fontWeight: FontWeight.bold,
                              fontSize: screenWidth / 22, // Adjusted font size
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),

          ),
                  ),
    );
  }

  Widget _buildDetailedFoodTruckUI(FoodTruck foodTruck) {
    List<String> imageUrls = foodTruck.truckImages!;
    return Container(
        color: Colors.white,
        width: screenWidth,
        height: screenHeight - 450,
        child: PageView.builder(
          onPageChanged: (page) {
            setState(() {
              _currentPageNotifier.value = page;
            });
          },
          itemCount: imageUrls.length,
          itemBuilder: (context, index) {
            String imageUrl = imageUrls[index];
            return buildImageWidget(imageUrl);
          },
        ));
  }

  Widget buildImageWidget(String imagePath) {
    if (imagePath.isNotEmpty) {
      return FittedBox(
        fit: BoxFit.contain,
        child: Image.network(
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
      dotColor: Colors.black,
      size: screenWidth / 30,
      selectedSize: screenWidth / 26,
      itemCount: widget.foodTruck.truckImages!.length,
      currentPageNotifier: _currentPageNotifier,
    );
  }
  Future<void> buildShowTimingsDialog(BuildContext context) async {
    // Converting the map entries to a list
    List<MapEntry<String, dynamic>> entries = widget.foodTruck.truckTime!.entries.toList();

    List<String> daysOfWeek = ['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday'];

    // Sort the entries by the using the index of the day in the daysOfWeek list
    entries.sort((a, b) => daysOfWeek.indexOf(a.key).compareTo(daysOfWeek.indexOf(b.key)));

    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.0)),
      ),
      builder: (BuildContext context) {
        return Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    "Timings",
                    style: TextStyle(
                      fontSize: screenWidth / 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Spacer(),
                  IconButton(
                    onPressed: () {
                      Navigator.of(context).pop(); // Close the dialog
                    },
                    icon: Icon(
                      Icons.cancel,
                      color: colorTheme,
                      size: MediaQuery.of(context).size.width / 15,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20.0),
              ListView.builder(
                shrinkWrap: true,
                itemCount: entries.length,
                itemBuilder: (context, index) {
                  var entry = entries[index];
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: Row(
                      children: [
                        Text(
                          "${entry.key}:",
                          style: TextStyle(
                            fontSize: screenWidth / 23,
                          ),
                        ),
                        const Spacer(),
                        Text(
                          entry.value.toString(), // Adjust to display value properly
                          style: TextStyle(
                            fontSize: screenWidth / 23,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }

}


