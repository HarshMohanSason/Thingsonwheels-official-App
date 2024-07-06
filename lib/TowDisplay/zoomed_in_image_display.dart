import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:page_view_indicators/circle_page_indicator.dart';
import '../main.dart';

class FullImageView extends StatefulWidget {

  final List<String> imageUrls;
  final int currImageIndex;

  const FullImageView({Key? key, required this.imageUrls, required this.currImageIndex}) : super(key: key);

  @override
  State<FullImageView> createState() => _FullImageViewState();
}

class _FullImageViewState extends State<FullImageView> {

  final  _currentPageNotifier = ValueNotifier<int>(0);
  @override
  void initState() {
    super.initState();
    _currentPageNotifier.value = widget.currImageIndex;
  }

  @override
  Widget build(BuildContext context) {

    return PopScope(
      canPop: Platform.isAndroid ? true: false,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children : [
              Padding(
                padding: const EdgeInsets.only(top: 50, left: 10),
                child: Align(
                    alignment: Alignment.topLeft,
                    child: InkWell(
                        onTap: () => Navigator.pop(context),
                        child: Icon(Icons.cancel, size: screenWidth/12, color: colorTheme,))
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 20.0),
                child: Center(
                  child: Container(
                      color: Colors.transparent,
                      width: screenWidth,
                      height: screenHeight/2,
                      child: PageView.builder(
                        controller: PageController(initialPage: widget.currImageIndex),
                        onPageChanged:  (page)
                        {
                          setState(() {
                            _currentPageNotifier.value = page ;
                          });
                        },
                        itemCount: widget.imageUrls.length,
                        itemBuilder: (context, index) {
                          List<String> imageUrls = widget.imageUrls.map((dynamic imageUrl) => imageUrl.toString()).toList();
                          return buildImageWidget(imageUrls[index]);
                        },
                      )
                  ),
                ),
              ),
              Padding(
                  padding: const EdgeInsets.only(top: 40),
                  child: Center(child: circleIndicator())),
            ] ),
      ),
    );
  }


  Widget buildImageWidget(String imagePath) {
    return FittedBox(
      fit: BoxFit.contain,
      child: InteractiveViewer(  //Using Interactive viewer to make sure the image is zoomable
        minScale: 0.5,
        maxScale: 4,
        child: CachedNetworkImage(
          imageUrl:
          imagePath,
        ),
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
      itemCount: widget.imageUrls.length,
      currentPageNotifier: _currentPageNotifier,
    );
  }

}