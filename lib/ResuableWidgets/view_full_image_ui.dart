
import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:thingsonwheels/main.dart';

class FullImageView extends StatelessWidget {
  final List<dynamic> images;
  final int currImageIndex;

  const FullImageView({Key? key, required this.images, required this.currImageIndex}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: Platform.isIOS ? false : true,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.black,
          leading: InkWell(
            onTap: () {
              Navigator.pop(context);
            },
            child: Icon(Icons.cancel_rounded, color: colorTheme, size: 30),
          ),
        ),
        backgroundColor: Colors.black,
        body: PageView.builder(
          controller: PageController(initialPage: currImageIndex),
          onPageChanged: (page) {
            // Handle page change if needed
          },
          itemCount: images.length,
          itemBuilder: (context, index) {
            List<String> imageUrls = images.map((dynamic imageUrl) => imageUrl.toString()).toList();
            return Center(
              child: InteractiveViewer(
                minScale: 0.1,
                maxScale: 2.0,
                child: CachedNetworkImage(
                  imageUrl: imageUrls[index],
                  fit: BoxFit.contain,
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
