

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:thingsonwheels/AppSettings/AppSettingsUI.dart';
import 'package:thingsonwheels/FoodTruckDisplay/FoodTruckTileUI.dart';
import 'package:thingsonwheels/main.dart';

class HomeScreen extends StatefulWidget {

  const HomeScreen({super.key});

  @override
  HomeScreenState createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen>
{
  @override
  Widget build(BuildContext context) {
   return PopScope(

     canPop: false,
     child: Scaffold(
       backgroundColor: colorTheme,
       body:  SafeArea(

         child: Column(
           children: [
             Row(
               children: [
                 Spacer(),
                 Row(
                   children: [
                     Icon(Icons.location_on, size: screenWidth/13,),
                     Text("Fresno", style: TextStyle(
                         fontSize: screenWidth/18,
                     ),),
                   ],
                 ),
                 Spacer(),
                 InkWell(
                     onTap: ()
                     {
                       Navigator.push(context, MaterialPageRoute(builder: (context)=> const  AppSettings()));

                     },
                     child: Icon(Icons.settings, size: screenWidth/12)),
               ],
             ),
             const SizedBox(height: 20),
              const Expanded(child: FoodTruckTileUI()),
           ],
         ),
       ),
     ),
   );
  }

}