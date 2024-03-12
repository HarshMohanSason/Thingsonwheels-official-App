
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
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
                          children: [
                            Icon(Icons.phone, size: screenWidth / 10), // Adjusted icon size
                            Flexible(
                              child: Text(
                                widget.foodTruck.truckPhoneNo!,
                                style: TextStyle(
                                  fontSize: screenWidth / 16, // Adjusted font size
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        Row(
                          children: [
                            Icon(Icons.location_on, size: screenWidth / 10), // Adjusted icon size
                            Flexible(
                              child: Text(
                                widget.foodTruck.truckAddress!,
                                style: TextStyle(
                                  fontSize: screenWidth / 16, // Adjusted font size
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Timings: ",
                              style: TextStyle(
                                fontSize: screenWidth / 14, // Adjusted font size
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(top: 5),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: widget.foodTruck.truckTime != null
                                    ? widget.foodTruck.truckTime!
                                    .map((time) => Text(
                                  time,
                                  style: TextStyle(
                                    fontSize: screenWidth / 18, // Adjusted font size
                                  ),
                                ))
                                    .toList()
                                    : [
                                  Text(
                                    "Location and Times : Varies, so check our posts daily! on the given social-media",
                                    style: TextStyle(
                                      fontSize: screenWidth / 18, // Adjusted font size
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),

                        //Only display the social link column when there is one available
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
                                    fontSize: screenWidth / 18, // Adjusted font size
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
            String imageUrl = imageUrls[index]; // Correct the field name
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
}
