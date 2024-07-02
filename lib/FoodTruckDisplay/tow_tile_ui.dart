
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:thingsonwheels/FoodTruckDisplay/tow_service.dart';
import 'package:thingsonwheels/FoodTruckDisplay/tow_detailed_display_ui.dart';
import 'package:thingsonwheels/Location/location_service.dart';
import 'package:thingsonwheels/main.dart';
import 'live_indicator_button_ui.dart';

class TowTileUI extends StatefulWidget {
  const TowTileUI({super.key});

  @override
  TowTileUIState createState() => TowTileUIState();
}

class TowTileUIState extends State<TowTileUI> {
  late Future<List<TowService>> _future;

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  void _fetchData() {
    final location = Provider.of<LocationService>(context, listen: false).location;
    _future = TowService.getTOWMerchantInfo(location);
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<LocationService>(
      builder: (BuildContext context, LocationService value, Widget? child) {
        _fetchData();
        return RefreshIndicator(
          color: Colors.white,
          backgroundColor: colorTheme,
          onRefresh: () async {
            await Future.delayed(const Duration(seconds: 2));

            if (mounted) {
              setState(() {
                _fetchData();
              });
            }
            return Future(() => _future);
          },
          child: FutureBuilder(
              future: _future,
              builder: (BuildContext context,
                  AsyncSnapshot<List<TowService>> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return  Center(
                      child: Text(
                    "Loading".tr(),
                    style: const TextStyle(
                        color: Colors.black, fontWeight: FontWeight.bold),
                  ));
                }
                else if(snapshot.connectionState == ConnectionState.none)
                  {
                    return  Center(
                        child: Text(
                          "Could not get a connection, try again later".tr(),
                          style: const TextStyle(
                              color: Colors.black, fontWeight: FontWeight.bold),
                        ));
                  }
                if (snapshot.hasError) {
                  return  Center(
                      child: Text(
                    "Some Error occurred, please try again !".tr(),
                    style: const TextStyle(color: Colors.black),
                  ));
                }

                if (snapshot.hasData) {
                  List<TowService> truckList = snapshot.data!;

                  if (truckList.isNotEmpty) {
                    return ListView.builder(
                      scrollDirection: Axis.vertical,
                      itemCount: truckList.length,
                      itemBuilder: (BuildContext context, int index) {
                        return buildListCard(truckList[index]);
                      },
                    );
                  } else {
                    return  Center(
                        child: Text(
                      "Nothing available in your area :(".tr(),
                      style: const TextStyle(color: Colors.black),
                    ));
                  }
                } else {
                  return  Center(
                      child: Text(
                    "No FoodTrucks available in your area".tr(),
                    style: const TextStyle(color: Colors.black),
                  ));
                }
              }),
        );
      },
    );
  }

  Widget buildListCard(TowService foodTruck) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) =>
                TowDetailedDisplayUI(foodTruck: foodTruck),
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
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.orange[300]!, Colors.orange[700]!],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(25),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                spreadRadius: 2,
                blurRadius: 5,
                offset: const Offset(0, 3),
              ),
            ],
          ),
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
                    return Stack(
                      children: [
                        CircleAvatar(
                          backgroundImage:
                              NetworkImage(foodTruck.truckImages!.first,
                              ),
                          radius: screenWidth / 12,
                        ),
                        Positioned(
                          top: 0,
                          right: 0,
                          child: StreamBuilder(
                            stream: TowService.getLiveStatusStream(),
                            builder: (BuildContext context,
                                AsyncSnapshot<Map<String, bool>> snapshot) {
                              if (snapshot.connectionState ==
                                      ConnectionState.waiting ||
                                  snapshot.connectionState ==
                                      ConnectionState.none) {
                                return const LiveIndicator(isLive: false, size: 12,);
                              }
                              if(snapshot.data == null)
                                {
                                  return Container();
                                }

                              else {
                                return LiveIndicator(
                                    isLive: snapshot.data![foodTruck.docID]!, size: 12,);
                              }
                            },
                          ),
                        )
                      ],
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
              size: screenWidth / 14.5,
            ),
          ),
        ),
      ),
    );
  }
}
