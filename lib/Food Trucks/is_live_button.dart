import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:thingsonwheels/Animations/is_live_dot_animation.dart';
import 'package:thingsonwheels/main.dart';
import 'food_truck_structure.dart';

class IsLiveButton extends StatefulWidget {
  const IsLiveButton({super.key, required this.docID});

  final String docID;

  @override
  IsLiveButtonState createState() => IsLiveButtonState();
}

class IsLiveButtonState extends State<IsLiveButton> {
  late Stream<bool> getIsLiveButton;

  @override
  void initState() {
    super.initState();
    getIsLiveButton = FoodTruckStructure.getIsLiveStatus(widget.docID);
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<bool>(
      stream: getIsLiveButton,
      builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
         return Container();
        } else if (snapshot.hasError) {
         return Container();
        } else if (snapshot.data == true) {
          return createLiveButton(true);
        } else {
          return Container();
        }
      },
    );
  }
}

Widget createLiveButton(bool isLive) {
  return Container(
    padding: const EdgeInsets.only(top: 8, bottom: 8, left: 8, right: 8),
    decoration:  BoxDecoration(color: const Color(0xFFAFFCBC).withOpacity(0.7)),
    child: Row(
      children: [
        IsLiveDotAnimation(isLive: isLive),
        Text(
          "LIVE NOW",
          style: TextStyle(
              fontSize: screenWidth / 36,
              fontWeight: FontWeight.bold,
              color: const Color(0xFF007012)),
        ),
      ],
    ),
  );
}
