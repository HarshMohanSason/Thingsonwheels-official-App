import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:page_view_indicators/circle_page_indicator.dart';

class FoodTruckImagesDisplay extends StatefulWidget {
  const FoodTruckImagesDisplay(
      {super.key, required this.images, this.width, this.height});

  final List<String?> images;
  final double? width;
  final double? height;

  @override
  FoodTruckImagesDisplayState createState() => FoodTruckImagesDisplayState();
}

class FoodTruckImagesDisplayState extends State<FoodTruckImagesDisplay> {
  final _currentPageNotifier = ValueNotifier<int>(0);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        SizedBox(
            width: widget.width,
            height: widget.height,
            child: PageView.builder(
                onPageChanged: (page) {
                  setState(() {
                    _currentPageNotifier.value = page;
                  });
                },
                itemCount: widget.images.length,
                itemBuilder: (context, index) {
                  String imageUrl = widget.images[index]!;
                  // Correct the field name
                  return CachedNetworkImage(
                    imageUrl: imageUrl,
                    fit: BoxFit.cover,
                  );
                })),
        Positioned(
            right: 5, bottom: widget.width! / 4.8, child: circleIndicator()),
      ],
    );
  }

  Widget circleIndicator() {
    return CirclePageIndicator(
      selectedDotColor: Colors.white,
      dotColor: const Color(0xFFA0A0A0),
      size: 6,
      selectedSize: 6,
      itemCount: widget.images.length,
      currentPageNotifier: _currentPageNotifier,
    );
  }
}