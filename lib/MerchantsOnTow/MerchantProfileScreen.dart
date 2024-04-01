
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'MerchantOnTowService.dart';


class MerchantProfileScreen extends StatefulWidget{


  const MerchantProfileScreen({Key? key,}) : super(key: key);

  @override
  _MerchantProfileScreenState createState() => _MerchantProfileScreenState();
}
class _MerchantProfileScreenState extends State<MerchantProfileScreen> {

  @override
  void initState() {
    super.initState();

  }
  @override
  void dispose() {

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final merchantProvider = context.read<MerchantsOnTOWService>();
    return Scaffold(
      appBar: AppBar(
        leading: Icon(Icons.arrow_back),
        title: Text('${merchantProvider.merchantName}\'s Profile'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const ListTile(
              title: const Text('Merchant Contact Number'),
              subtitle: TextField(
                decoration: const InputDecoration(
                  hintText: 'Merchant Contact',
                ),
              ),
            ),
            ListTile(
              title: const Text('Merchant Business Address'),
              subtitle: TextField(
                decoration: const InputDecoration(
                  hintText: 'Business Address',
                ),
              ),
            ),
            ListTile(
              title: const Text('Merchant Business Contact'),
              subtitle: TextField(
                decoration: const InputDecoration(
                  hintText: 'Business Contact',
                ),
              ),
            ),
            ElevatedButton(
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(Colors.orange),
                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                ),
              ),
              onPressed: () {

                // Save the updated information to Firebase or local state
              },
              child: const Text('Save Changes',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold
              ),),
            ),
            ElevatedButton(
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(Colors.orange),
                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                ),
              ),
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Go Live',
                  style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold
              ),),
            ),
          ],
        ),
      ),
    );
  }


  
}



