import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:thingsonwheels/Reusable%20Widgets/toast_widget.dart';
import '../main.dart';

class HomeScreenAppBar extends StatelessWidget {
  const HomeScreenAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: false, // Hide default back arrow
      flexibleSpace: Padding(
        padding: const EdgeInsets.only(bottom: 10, left: 20, right: 20),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Icon(
              Icons.location_pin,
              color: Colors.white,
              size: screenWidth / 10,
            ),
            const SizedBox(
              width: 10,
            ),
            GestureDetector(
              onTap: () {
                showToast(
                    'We are only in Santa Maria for now, more locations coming soon',
                    Colors.white,
                    Colors.black,
                    "LONG");
              },
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Santa Maria",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: screenWidth / 20,
                        fontWeight: FontWeight.bold),
                  ),
                  Text(
                    "USA",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: screenWidth / 25,
                        fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
            const Spacer(),
            CircleAvatar(
              foregroundImage:
                  FirebaseAuth.instance.currentUser!.photoURL != null
                      ? CachedNetworkImageProvider(
                          FirebaseAuth.instance.currentUser!.photoURL!)
                      : null,
              child: FirebaseAuth.instance.currentUser!.photoURL == null
                  ? const Icon(Icons.person)
                  : null,
            ),
          ],
        ),
      ),
      backgroundColor: Colors.red, // Background color of AppBar
      elevation: 0, // Remove shadow
    );
  }
}
