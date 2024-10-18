import 'package:flutter/material.dart';

class FiltersUi extends StatelessWidget {
  const FiltersUi({super.key, required this.filterName, this.icon});

  final String filterName;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(left: 5, top: 8, bottom: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: const Color(0xFFD3D3D3), // Border color
          width: 1.0, // Border width
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Image.asset(
            'assets/images/page_info.png',
            fit: BoxFit.contain,
            scale: 18,
            color: Colors.black,
          ),
          const SizedBox(
            width: 5,
          ),
          Text(
            filterName,
            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
          ),
          Icon(
            icon,
            size: 18,
          )
        ],
      ),
    );
  }
}
