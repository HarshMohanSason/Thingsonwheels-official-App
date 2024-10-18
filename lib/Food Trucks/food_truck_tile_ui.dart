import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:thingsonwheels/Food%20Trucks/food_truck_structure.dart';
import 'package:thingsonwheels/Food%20Trucks/is_live_button.dart';
import '../main.dart';
import 'food_truck_images_display.dart';

class FoodTruckTileUi extends StatelessWidget {
  const FoodTruckTileUi({
    super.key,
    required this.foodTruckStructure});

  final FoodTruckStructure foodTruckStructure;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(20), // Apply the border radius here
      child: Stack(
        children: [
          // Container on top of CustomPaint
          FoodTruckImagesDisplay(
            images: foodTruckStructure.tileImages,
            width: screenWidth - 40,
            height: screenHeight / 3,
          ),
          Positioned(
              top: 10,
              right: 10,
              child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: IsLiveButton(
                    docID: foodTruckStructure.docID,
                  ))),
          // CustomPaint at the bottom of the container
          Positioned(
            bottom: 0,
            child: SizedBox(
              width: screenWidth - 40,
              height: screenHeight / 2.3,
              // Adjust the height to match the desired custom shape height
              child: IgnorePointer(
                child: CustomPaint(
                  painter: PaintBottomOfTheTile(
                      businessName: foodTruckStructure.foodTruckName),
                ),
              ),
            ),
          ),

          Positioned(
            left: 10,
            bottom: 5,
            child: SizedBox(
              width: screenWidth - 60,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Align(
                      alignment: Alignment.centerRight,
                      child: displayRating(foodTruckStructure.currentRating)),
                  Row(
                    children: [
                      Text(
                        "0",
                        style: TextStyle(
                          color: const Color(0xFF252531), // Text color
                          fontSize: screenWidth / 32,
                        ),
                      ),
                      const SizedBox(width: 5),
                      // Spacing between text and bullet
                      Text(
                        "•", // Bullet point
                        style: TextStyle(
                          color: const Color(0xFFD9D9D9),
                          fontSize: screenWidth / 28, // Slightly larger bullet
                        ),
                      ),
                      const SizedBox(width: 5),
                      // Spacing between bullet and next text
                      Text(
                       "0",
                        style: TextStyle(
                          color: const Color(0xFF252531), // Text color
                          fontSize: screenWidth / 32,
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget displayRating(int currentRating) {
    return Container(
      width: screenWidth / 9,
      height: screenWidth / 20,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        color: const Color(0xFF007012),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            FontAwesomeIcons.solidStar,
            color: Colors.white,
            size: screenWidth / 43.2,
          ),
          const SizedBox(
            width: 5,
          ),
          Text(
            '$currentRating',
            style: TextStyle(
                color: Colors.white,
                fontSize: screenWidth / 36,
                fontWeight: FontWeight.w600),
          )
        ],
      ),
    );
  }
}

class PaintBottomOfTheTile extends CustomPainter {
  final String businessName;

  PaintBottomOfTheTile({required this.businessName});

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = Colors.white // Background color
      ..style = PaintingStyle.fill;

    Path path = Path();
    path.moveTo(0, size.height); // Start at bottom-left
    path.lineTo(0, size.height / 1.3);
    path.lineTo(size.width / 2.3, size.height / 1.3);
    path.quadraticBezierTo(size.width / 2, size.height / 1.235,
        size.width / 1.9, size.height / 1.2);
    path.lineTo(size.width, size.height / 1.2);
    path.lineTo(size.width, size.height);
    path.close(); // Close the path
    canvas.drawPath(path, paint);
    path.close();

    // Define the style for the text
    final TextStyle textStyle1 = TextStyle(
        color: const Color(0xFF676767), // Text color
        fontSize: size.width / 29,
        fontFamily: 'Poppins');
    final TextStyle textStyle2 = TextStyle(
        color: Colors.black, // Text color
        fontSize: size.width / 20,
        fontWeight: FontWeight.bold,
        fontFamily: 'Poppins');

    // Create and layout the text spans
    _drawText(canvas, size, '1.5 miles from you', textStyle1,
        Offset(10, size.height / 1.28));
    _drawText(
        canvas, size, businessName, textStyle2, Offset(10, size.height / 1.19));
  }

  void _drawText(
      Canvas canvas, Size size, String text, TextStyle style, Offset offset) {
    final TextSpan textSpan = TextSpan(text: text, style: style);
    final TextPainter textPainter = TextPainter(
      text: textSpan,
      textDirection: TextDirection.ltr,
    );

    textPainter.layout(
      minWidth: 0,
      maxWidth: size.width,
    );

    textPainter.paint(canvas, offset);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
