import 'package:flutter/material.dart';

class ViewDetailedBill extends StatelessWidget {
  const ViewDetailedBill({super.key});

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
        initialChildSize: 0.3, // Starts at 30% height
        minChildSize: 0.1, // Minimum height (10%)
        maxChildSize: 0.9, // Maximum height (90%)
        builder: (context, scrollController) {
          return Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(
                top: Radius.circular(20),
              ),
            ),
            child: ListView(
              controller: scrollController,
              children: [
                ListTile(
                  leading: Icon(Icons.receipt),
                  title: Text('Total Amount: \$30'),
                ),
                ListTile(
                  leading: Icon(Icons.payment),
                  title: Text('Payment Method: Credit Card'),
                ),
                ListTile(
                  leading: Icon(Icons.info),
                  title: Text('Payment Status: Completed'),
                ),
              ],
            ),
          );
        });
  }
}
