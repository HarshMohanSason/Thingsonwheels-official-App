import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'location_service.dart'; // Import your Location class

class LocationSelector extends StatefulWidget {
  const LocationSelector({super.key});

  @override
  LocationSelectorState createState() => LocationSelectorState();
}

class LocationSelectorState extends State<LocationSelector> {
  void _changeLocation(BuildContext context, String newLocation) {
    var locationProvider = context.read<LocationService>();
    locationProvider.setLocation(newLocation);
  }

  void _showLocationDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: Center(
            child: Text(
              'Change Location'.tr(),
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: MediaQuery.of(context).size.width / 20,
                color: Colors.black,
              ),
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildLocationTile(context, 'Fresno'),
              Divider(color: Colors.grey.shade300),
              _buildLocationTile(context, 'Santa Maria'),
              // Add more locations as needed
            ],
          ),
        );
      },
    );
  }

  Widget _buildLocationTile(BuildContext context, String location) {
    return ListTile(
      title: Text(
        location,
        style: TextStyle(
          fontSize: MediaQuery.of(context).size.width / 25,
          fontWeight: FontWeight.w500,
          color: Colors.black87,
        ),
      ),
      onTap: () {
        _changeLocation(context, location);
        Navigator.of(context).pop();
      },
      trailing: Icon(
        Icons.location_on,
        color: Colors.orange.shade700,
      ),
      tileColor: Colors.orange.shade50,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      contentPadding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
    );
  }

  @override
  Widget build(BuildContext context) {
    var locationProvider = context.watch<LocationService>();
    double screenWidth = MediaQuery.of(context).size.width;

    return GestureDetector(
      onTap: _showLocationDialog,
      child: Container(
        padding: const EdgeInsets.all(8),
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
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.location_pin,
              color: Colors.white,
              size: screenWidth / 17,
            ),
            const SizedBox(width: 8),
            Text(
              locationProvider.location,
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: screenWidth / 26,
              ),
            ),
            const Icon(
              Icons.arrow_drop_down,
              color: Colors.white,
            ),
          ],
        ),
      ),
    );
  }
}
