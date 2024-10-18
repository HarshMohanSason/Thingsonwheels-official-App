
import 'package:flutter/material.dart';
import '../Reusable Widgets/divider_with_text_in_middle.dart';
import 'filters_ui.dart';
import 'food_truck_tile_display.dart';

class FoodTruckHomeScreen extends StatefulWidget {
  const FoodTruckHomeScreen({super.key});

  @override
  FoodTruckHomeScreenState createState() => FoodTruckHomeScreenState();
}

class FoodTruckHomeScreenState extends State<FoodTruckHomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(
          height: 20,
        ),
        const DividerWithTextInMiddle(textInBetween: 'WHAT\'S ON YOUR MIND'),
        const SizedBox(
          height: 120,
        ), //Fill what's on your mind later
        const DividerWithTextInMiddle(textInBetween: 'ALL FOOD TRUCKS'),
        const SizedBox(
          height: 15,
        ),
        const Padding(
          padding: EdgeInsets.only(left: 20),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              FiltersUi(
                filterName: 'Sort',
                icon: Icons.arrow_drop_down,
              ),
              SizedBox(
                width: 15,
              ),
              FiltersUi(
                filterName: 'Nearest',
              ),
              SizedBox(
                width: 15,
              ),
              FiltersUi(
                filterName: 'Rating',
              ),
            ],
          ),
        ),
        const SizedBox(
          height: 15,
        ),
        Text(
          "1234 Food Trucks within your 10 mi radius",
          style: TextStyle(
            color: Colors.grey.shade500,
          ),
        ),
        const SizedBox(
          height: 20,
        ),
        Center(
          child: Text(
            "FEATURED",
            style: TextStyle(
              color: Colors.grey.shade500,
            ),
          ),
        ),
        const SizedBox(
          height: 20,
        ),
        const FoodTruckTileDisplay(),
        const SizedBox(
          height: 20,
        ),
      ],
    );
  }
}
