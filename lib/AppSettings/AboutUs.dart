import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:thingsonwheels/main.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'package:fluttertoast/fluttertoast.dart';

class AboutUs extends StatelessWidget {
  const AboutUs({super.key});

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(screenHeight / 13.5), // Adjust the height as needed
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.orange[300]!, Colors.orange[700]!],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: AppBar(
              backgroundColor: Colors.transparent, // Make AppBar transparent
              title: Center(
                child: Text(
                  "About Us",
                  style: TextStyle(
                    color: Colors.white, // Ensure text is readable on gradient background
                    fontWeight: FontWeight.bold,
                    fontSize: screenWidth / 18,
                  ),
                ),
              ),
              leading: InkWell(
                child: Icon(Icons.arrow_back, size: screenWidth / 14, color: Colors.white), // Ensure icon is readable
                onTap: () {
                  Navigator.pop(context);
                },
              ),
              elevation: 0, // Remove shadow
            ),
          ),
        ),
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          child: SafeArea(
            child: Padding(
              padding: EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Welcome to Things On Wheels',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: screenWidth / 20,
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    '''Your gateway to local businesses right in your town. We're thrilled to introduce our beta version, starting with the vibrant community of Fresno. Our mission is simple: to expand access to the wonderful array of small businesses and hidden gems that make our towns special.

At Things On Wheels, we understand the struggle of finding the best food spots or exploring unique markets without a centralized platform. That's why we're here to bridge that gap. Whether you're craving delicious cuisine or seeking out charming local markets, our app is your one-stop solution.

But we're not stopping in Fresno. Our vision extends far beyond, envisioning every small town with its own tapestry of flavors and experiences, just waiting to be discovered. With your support, we aim to bring accessibility and convenience to communities far and wide.

Your feedback is invaluable to us. Please don't hesitate to share your thoughts and suggestions via email. And if you're a local business owner looking to showcase your offerings, reach out to us at oggooggp19962000@gmail.com.

Thank you for joining us on this journey. Together, let's unlock the essence of our towns, one discovery at a time.
                  ''',
                    style: TextStyle(
                      fontSize: screenWidth / 30,
                      height: 1.5,
                    ),
                  ),
                  SizedBox(height: 20),
                  Text(
                    "Developers:",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: screenWidth / 25,
                    ),
                  ),
                  SizedBox(height: 10),
                  _buildDeveloperLink(
                    context,
                    name: "Satyam's LinkedIn",
                    url: "https://www.linkedin.com/in/satyam-sm",
                  ),
                  SizedBox(height: 10),
                  _buildDeveloperLink(
                    context,
                    name: "Harsh's LinkedIn",
                    url: "https://www.linkedin.com/in/harsh-mohan-sason-50a72119b/",
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDeveloperLink(BuildContext context, {required String name, required String url}) {
    return InkWell(
      onTap: () async {
        if (await canLaunchUrlString(url)) {
          await launchUrlString(url);
        } else {
          Fluttertoast.showToast(
            msg: 'Could not launch the link',
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: MediaQuery.of(context).size.width / 25,
          );
        }
      },
      child: Row(
        children: [
          Icon(
            Icons.link,
            color: Colors.lightBlue,
            size: MediaQuery.of(context).size.width / 20,
          ),
          SizedBox(width: 8),
          Text(
            name,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: MediaQuery.of(context).size.width / 30,
              color: Colors.lightBlue,
            ),
          ),
        ],
      ),
    );
  }
}
