import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:thingsonwheels/Social%20Media/social_media_post_tile_ui.dart';
import 'package:thingsonwheels/Social%20Media/social_media_post_structure.dart';

import '../main.dart';

class DisplaySocialMediaPosts extends StatefulWidget {
  const DisplaySocialMediaPosts({super.key});

  @override
  DisplaySocialMediaPostsState createState() => DisplaySocialMediaPostsState();
}

class DisplaySocialMediaPostsState extends State<DisplaySocialMediaPosts> {
  late Future<List<SocialMediaPostStructure>> future;

  @override
  void initState() {
    super.initState();
    future = SocialMediaPostStructure.getPosts();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: future,
        builder: (BuildContext context,
            AsyncSnapshot<List<SocialMediaPostStructure>> snapshot) {
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
            if (snapshot.data!.isEmpty) {
              return Center(
                child: Text(
                  "No posts in your area",
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
                  shrinkWrap: false,
                  itemBuilder: (BuildContext context, int index) {
                    return Padding(
                        padding:const EdgeInsets.only(top: 20,left: 20, right: 20),
                        child: SocialMediaPostTileUi(socialMediaStructure: snapshot.data![index]));
                  });
            }
          }
        });
  }


}
