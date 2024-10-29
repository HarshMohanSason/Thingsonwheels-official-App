import 'package:flutter/material.dart';
import 'package:thingsonwheels/Food%20Trucks/food_truck_tile_ui.dart';
import 'package:thingsonwheels/Food%20Trucks/menu_display.dart';
import 'package:thingsonwheels/main.dart';

import 'food_truck_structure.dart';

class FoodTruckTileDisplay extends StatefulWidget {
  const FoodTruckTileDisplay({super.key});

  @override
  FoodTruckTileDisplayState createState() => FoodTruckTileDisplayState();
}

class FoodTruckTileDisplayState extends State<FoodTruckTileDisplay> {
  late Future<List<FoodTruckStructure>> future;

  @override
  void initState() {
    super.initState();
    future = FoodTruckStructure.getFoodTrucks();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: future,
        builder: (BuildContext context,
            AsyncSnapshot<List<FoodTruckStructure>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: Image.asset(
                'assets/GIFs/loading_indicator.gif',
                scale: 13,
              ),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text(
                snapshot.error.toString(),
                style: TextStyle(
                  fontSize: screenWidth / 15,
                  fontWeight: FontWeight.bold,
                  color: Colors.red,
                ),
              ),
            );
          } else {
            if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return Center(
                child: Text(
                  "No food trucks in your area",
                  style: TextStyle(
                    fontSize: screenWidth / 30,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              );
            } else {
              return ListView.builder(
                  itemCount: snapshot.data!.length,
                  primary: false,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemBuilder: (BuildContext context, int index) {

                    return Padding(
                        padding:const  EdgeInsets.only(left: 20, right: 20),
                        child: GestureDetector(
                          onTap: (){
                            Navigator.push(context, MaterialPageRoute(builder: (context)=>MenuDisplay(foodTruckStructure: snapshot.data![index],)));
                          },
                          child: FoodTruckTileUi(
                              foodTruckStructure: snapshot.data![index]),
                        ));
                  });
            }
          }
        });
  }

  Widget foodTruckTile() {
    return Stack(
      children: [
        Container(
          width: screenWidth - 40,
          height: screenHeight / 6,
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(15)),
        ),
      ],
    );
  }
}
