


import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:thingsonwheels/main.dart';
import 'package:url_launcher/url_launcher_string.dart';

class AboutUs extends StatelessWidget
{
  const AboutUs({super.key});

  @override
  Widget build(BuildContext context) {

    return PopScope(
      canPop: false,
      child: Scaffold(

        appBar: PreferredSize(
          preferredSize: Size.fromHeight(screenHeight / 12), // Adjust the height as needed
          child: AppBar(
            backgroundColor: colorTheme,
            title: Text(
              "About Us",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: screenWidth / 16,
              ),
            ),
            leading: Padding(
              padding: const EdgeInsets.only(right: 22),
              child: InkWell(
                child: Icon(Icons.arrow_back, size: screenWidth / 14),
                onTap: () {
                  Navigator.pop(context);
                },
              ),
            ),
          ),
        ),
        backgroundColor: Colors.white,
        body:  SingleChildScrollView(
          child:  SafeArea(
           child: Padding(
             padding: EdgeInsets.only(top: 20),
             child: Column(
                children: [
                   Text(
                    '''Welcome to Things On Wheels, your gateway to local businesses right in your town. We're thrilled to introduce our beta version, starting with the vibrant community of Fresno. Our mission is simple: to expand access to the wonderful array of small businesses and hidden gems that make our towns special.

At Things On Wheels, we understand the struggle of finding the best food spots or exploring unique markets without a centralized platform. That's why we're here to bridge that gap. Whether you're craving delicious cuisine or seeking out charming local markets, our app is your one-stop solution.

But we're not stopping in Fresno. Our vision extends far beyond, envisioning every small town with its own tapestry of flavors and experiences, just waiting to be discovered. With your support, we aim to bring accessibility and convenience to communities far and wide.

Your feedback is invaluable to us. Please don't hesitate to share your thoughts and suggestions via email. And if you're a local business owner looking to showcase your offerings, reach out to us at oggooggp19962000@gmail.com.

Thank you for joining us on this journey. Together, let's unlock the essence of our towns, one discovery at a time.
                  ''',
                    style: TextStyle(
                      fontSize: screenWidth/30,
                    ),
                  ),
                   Text("Developers:",
                  style: TextStyle(

                    fontSize: screenWidth/30,
                  ),),
                  Padding(
                    padding: const EdgeInsets.only(top: 5),
                    child: InkWell(
                      onTap: () async {

                        if (await canLaunchUrlString("https://www.linkedin.com/in/satyam-sm")) {
                          await launchUrlString("https://www.linkedin.com/in/satyam-sm");
                        } else {
                          throw 'Could not launch the link';
                        }
                      },
                      child:  Text("Satyam's Linkedin", style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: screenWidth/34,
                          color: Colors.lightBlue
                      ),),
                    ),
                  ),
             Padding(
               padding: const EdgeInsets.only(top: 5),
                 child: InkWell(
                    onTap: () async {

                      if (await canLaunchUrlString("https://www.linkedin.com/in/harsh-mohan-sason-50a72119b/")) {
                        await launchUrlString("https://www.linkedin.com/in/harsh-mohan-sason-50a72119b/");
                      } else {
                        throw 'Could not launch the link';
                      }
                    },
                    child:  Text("Harsh's Linkedin", style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: screenWidth/34,
                        color: Colors.lightBlue
                    ),),
                  ),
             ),


             ],
              ),
           ),
          ),
        ),
      ),
    );
  }

}