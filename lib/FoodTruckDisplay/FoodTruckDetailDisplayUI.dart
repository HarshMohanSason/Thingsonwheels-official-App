import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
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
          backgroundColor: colorTheme,
          body: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: SizedBox(
                  height: screenHeight,
                  child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Stack(children: [
                          _buildDetailedFoodTruckUI(widget.foodTruck),

                          Padding(
                            padding: const EdgeInsets.only(top: 60, left: 10),
                            child: Align(
                                alignment: Alignment.topLeft,
                                child: InkWell(
                                    onTap: () => Navigator.pop(context),
                                    child: Icon(Icons.arrow_back,
                                        size: screenWidth / 12,
                                        color: Colors.white))),
                          ),
                        ]),
                        Padding(
                          padding: EdgeInsets.only(left: 15),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(height: 10),
                               Center(child: circleIndicator()),
                              const SizedBox(height: 20),
                              Text(widget.foodTruck.truckName,
                                  style: TextStyle(
                                    fontSize: screenWidth / 10,
                                    fontWeight: FontWeight.bold,
                                  )),
                              const SizedBox(height: 20),
                              Row(
                                children: [
                                  Icon(Icons.phone, size: screenWidth / 13),
                                  Text(widget.foodTruck.truckPhoneNo,
                                      style: TextStyle(
                                        fontSize: screenWidth / 15,
                                      )),
                                ],
                              ),
                              const SizedBox(height: 20),
                              Row(
                                children: [
                                  Icon(Icons.location_on, size: screenWidth / 13),
                                  Text(widget.foodTruck.truckAddress,
                                      style: TextStyle(
                                        fontSize: screenWidth / 15,
                                      )),
                                ],
                              ),
                              const SizedBox(height: 20),
                              Row(
                                children: [
                                  Icon(Icons.timer, size: screenWidth / 13),
                                  Text(widget.foodTruck.truckTime,
                                      style: TextStyle(
                                        fontSize: screenWidth / 15,
                                        fontWeight: FontWeight.bold,
                                      )),
                                ],
                              ),
                              const SizedBox(height: 100),
                              Center(
                                child: Text(
                                  widget.foodTruck.isAvailable
                                      ? "Available"
                                      : "Not Available",
                                  style: TextStyle(
                                    color: widget.foodTruck.isAvailable
                                        ? Colors.green.shade700
                                        : Colors.red,
                                    fontWeight: FontWeight.bold,
                                    fontSize: screenWidth /
                                        14, // Adjust fontSize relative to screenWidth
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ])))),
    );
  }

  Widget _buildDetailedFoodTruckUI(FoodTruck foodTruck) {
    List<String> imageUrls = foodTruck.truckImages;
    return Container(
        color: Colors.orange,
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
    return FittedBox(
      fit: BoxFit.contain,
      child: Image.network(
        imagePath,
      ),
    );
  }

  Widget circleIndicator()
  {
    return CirclePageIndicator(
      selectedDotColor: Colors.white,
      dotColor: Colors.white,
      size: screenWidth/30,
      selectedSize: screenWidth/26,
      itemCount: widget.foodTruck.truckImages.length,
      currentPageNotifier: _currentPageNotifier,
    );
  }

}
