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
                  TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ));
          }
          if (snapshot.hasError) {
            return const Center(
                child:  Text(
              "Error fetching data",
              style: TextStyle(color: Colors.white),
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
        // Adjust the elevation relative to screenWidth
        margin: EdgeInsets.symmetric(
            horizontal: screenWidth / 36, vertical: screenHeight / 120),
        // Adjust margin relative to screenWidth and screenHeight
        child: Container(
          decoration: const BoxDecoration(color: Colors.orange),
          // White background
          child: ListTile(
            contentPadding: EdgeInsets.symmetric(
                horizontal: screenWidth / 18, vertical: screenHeight / 120),
            // Adjust content padding relative to screenWidth and screenHeight
            leading: Container(
              padding: EdgeInsets.only(right: screenWidth / 30),
              decoration: BoxDecoration(
                border: Border(
                  right: BorderSide(width: screenWidth / 750,
                      color: Colors
                          .black), // Adjust border width relative to screenWidth
                ),
              ),
              child: CircleAvatar(
                backgroundImage: NetworkImage(
                  foodTruck.truckImages.isNotEmpty
                      ? foodTruck.truckImages[0]
                      : '',
                ),
                radius: screenWidth /
                    16, // Adjust the radius of CircleAvatar relative to screenWidth for smaller height
              ),
            ),
            title: Text(
              foodTruck.truckName,
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: screenWidth /
                    24, // Adjust fontSize relative to screenWidth
              ),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  foodTruck.truckAddress,
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: screenWidth / 30, // Adjust fontSize relative to screenWidth
                  ),
                ),
                SizedBox(height: screenHeight / 120),
                // Adjust height relative to screenHeight
                // Add spacing between address and availability indicator
                Row(
                  children: <Widget>[
                    SizedBox(width: screenWidth / 72),
                    // Adjust width relative to screenWidth
                    Text(
                      foodTruck.isAvailable ? "Available" : "Not Available",
                      style: TextStyle(
                        color: foodTruck.isAvailable ? Colors.green : Colors
                            .red,
                        fontWeight: FontWeight.bold,
                        fontSize: screenWidth / 30, // Adjust fontSize relative to screenWidth
                      ),
                    ),
                  ],
                ),
              ],
            ),
            trailing: Icon(
              Icons.keyboard_arrow_right,
              color: Colors.white,
              size: screenWidth / 10, // Adjust icon size relative to screenWidth
            ),
          ),
        ),
      ),
    );
  }
  }
