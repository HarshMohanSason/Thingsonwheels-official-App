
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:thingsonwheels/main.dart';

class DetailedMerchantImageDisplay extends StatefulWidget{
  final String image;
  const DetailedMerchantImageDisplay({Key? key, required this.image}) : super(key: key);

  @override
  DetailedMerchantImageDisplayState createState() => DetailedMerchantImageDisplayState();
}

class DetailedMerchantImageDisplayState extends State<DetailedMerchantImageDisplay>{
  @override
  Widget build(BuildContext context) {

  return PopScope(
    canPop: Platform.isIOS ? false: true,
    child: Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
          leading: InkWell(
            onTap: ()
            {
              Navigator.pop(context);
            },
            child: Icon(Icons.cancel_rounded, color: colorTheme,size: 30,),
          )
      ),
      backgroundColor: Colors.black,
      body: Center(child: InteractiveViewer(
        minScale: 0.1,
        maxScale: 2.0,
        child: Image.network(widget.image,
        fit: BoxFit.contain,),
      ))
    ),
  );
  }

}