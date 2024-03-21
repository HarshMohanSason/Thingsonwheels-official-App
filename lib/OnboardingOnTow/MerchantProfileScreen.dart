import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import 'ImageUploadSection.dart';

class MerchantProfileScreen extends StatefulWidget{
  final String merchantName;
  final String merchantMobileNum;
  final String merchantEmail;
  final String merchantBusinessName;
  final String merchantBusinessAddr;
  final String merchantBusinessMobileNum;


  const MerchantProfileScreen({
    Key? key,
    required this.merchantName,
    required this.merchantMobileNum,
    required this.merchantEmail,
    required this.merchantBusinessName,
    required this.merchantBusinessAddr,
    required this.merchantBusinessMobileNum,
  }) : super(key: key);

  @override
  _MerchantProfileScreenState createState() => _MerchantProfileScreenState();
}
class _MerchantProfileScreenState extends State<MerchantProfileScreen> {
  late TextEditingController _merchantContactController;
  late TextEditingController _businessAddressController;
  late TextEditingController _businessContactController;

  @override
  void initState() {
    super.initState();
    _merchantContactController = TextEditingController(text: widget.merchantMobileNum);
    _businessAddressController = TextEditingController(text: widget.merchantBusinessAddr);
    _businessContactController = TextEditingController(text: widget.merchantBusinessMobileNum);
  }
  @override
  void dispose() {
    _merchantContactController.dispose();
    _businessAddressController.dispose();
    _businessContactController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.merchantName}\'s Profile'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            ListTile(
              title: const Text('Merchant Contact Number'),
              subtitle: TextField(
                controller: _merchantContactController,
                decoration: const InputDecoration(
                  hintText: 'Merchant Contact',
                ),
              ),
            ),
            ListTile(
              title: const Text('Merchant Business Address'),
              subtitle: TextField(
                controller: _businessAddressController,
                decoration: const InputDecoration(
                  hintText: 'Business Address',
                ),
              ),
            ),
            ListTile(
              title: const Text('Merchant Business Contact'),
              subtitle: TextField(
                controller: _businessContactController,
                decoration: const InputDecoration(
                  hintText: 'Business Contact',
                ),
              ),
            ),
            ImageUploadSection(title: 'Business Images', key: UniqueKey()),
            ImageUploadSection(title: 'Menu Images', key: UniqueKey()),
            ElevatedButton(
              onPressed: () {
                // Save the updated information to Firebase or local state
              },
              child: const Text('Save Changes'),
            ),
          ],
        ),
      ),
    );
  }
  
}