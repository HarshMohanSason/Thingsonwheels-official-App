import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:thingsonwheels/FoodTruckDisplay/FoodTruck.dart';
import 'package:thingsonwheels/FoodTruckDisplay/FoodTruckDetailDisplayUI.dart';
import 'package:thingsonwheels/main.dart';

class FoodTruckTileUI extends StatefulWidget {
  const FoodTruckTileUI({super.key});

  @override
  FoodTruckTileUIState createState() => FoodTruckTileUIState();
}

class FoodTruckTileUIState extends State<FoodTruckTileUI> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: FoodTruck.getTruckDataFirestore(),
        builder:
            (BuildContext context, AsyncSnapshot<List<FoodTruck>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
                child: Text(
              "Loading..",
              style:
                  TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
            ));
          }
          if (snapshot.hasError) {
            return const Center(
                child:  Text(
              "Error fetching data",
              style: TextStyle(color: Colors.black),
            ));
          } else {
            List<FoodTruck> truckList = snapshot.data!;

            return ListView.builder(
              scrollDirection: Axis.vertical,
              itemCount: truckList.length,
              itemBuilder: (BuildContext context, int index) {
                return buildListCard(truckList[index]);
              },
            );
          }
        });
  }

  Widget buildListCard(FoodTruck foodTruck) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) =>
                FoodTruckDetailDisplayUI(foodTruck: foodTruck),
          ),
        );
      },
      child: Card(
        elevation: screenWidth / 30,
        margin: EdgeInsets.symmetric(
          horizontal: screenWidth / 36,
          vertical: screenHeight / 120,
        ),
        child: Container(
          decoration: const BoxDecoration(color: Colors.orange),
          child: ListTile(
            contentPadding: EdgeInsets.symmetric(
              horizontal: screenWidth / 18,
              vertical: screenHeight / 120,
            ),
            leading: Container(
              padding: EdgeInsets.only(right: screenWidth / 30),
              decoration: BoxDecoration(
                border: Border(
                  right: BorderSide(
                    width: screenWidth / 750,
                    color: Colors.black,
                  ),
                ),
              ),
              child: Builder(
                builder: (BuildContext context) {
                  if (foodTruck.truckImages != null &&
                      foodTruck.truckImages!.first.isNotEmpty) {
                    return CircleAvatar(
                      backgroundImage:
                      NetworkImage(foodTruck.truckImages!.first),
                      radius: screenWidth / 12, // Adjust image size
                    );
                  } else {
                    return CircleAvatar(
                      backgroundColor: Colors.black,
                      radius: screenWidth / 12,
                      child: Icon(
                        Icons.fastfood,
                        color: Colors.white,
                        size: screenWidth / 12,
                      ),
                    );
                  }
                },
              ),
            ),
            title: Text(
              foodTruck.truckName,
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: screenWidth / 24,
              ),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  foodTruck.truckAddress!.length < 25
                      ? foodTruck.truckAddress!
                      : "${foodTruck.truckAddress!.substring(0, 15)}...",
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: screenWidth / 28,
                  ),
                ),
                SizedBox(height: screenHeight / 120),
                Row(
                  children: <Widget>[
                    SizedBox(width: screenWidth / 72),
                  ],
                ),
              ],
            ),
            trailing: Icon(
              Icons.keyboard_arrow_right,
              color: Colors.white,
              size: screenWidth/14.5,
            ),
          ),
        ),
      ),
    );
  }
  }
