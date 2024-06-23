

import 'package:flutter/cupertino.dart';
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

  return Scaffold(
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
    body: Center(child: Image.network(widget.image))
  );
  }

}