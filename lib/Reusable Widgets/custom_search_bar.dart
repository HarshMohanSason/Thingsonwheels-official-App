import 'package:flutter/material.dart';
import 'package:thingsonwheels/main.dart';
import '../Merchant Sign Up/merchant_structure.dart'; // Assuming MenuItem class is here

class CustomSearchBar extends StatefulWidget {
  const CustomSearchBar({super.key, required this.menuItems});

  final List<MenuItem> menuItems;

  @override
  State<CustomSearchBar> createState() => _CustomSearchBarState();
}

class _CustomSearchBarState extends State<CustomSearchBar> {
  TextEditingController barController = TextEditingController();
  List<MenuItem> filteredItems = []; // Filtered items for dropdown menu
  bool isDropdownVisible = false; // Controls the dropdown visibility of the dropdown Menu
  String query = ''; // To store the current query for matching from the filtered items

  @override
  void initState() {
    super.initState();
    filteredItems = widget.menuItems; // Initialize with all items
  }

  // Filter the menu items based on user input
  void filterSearch(String input) {
    final results = widget.menuItems
        .where(
            (item) => item.itemName.toLowerCase().contains(input.toLowerCase()))
        .toList();

    setState(() {
      query = input; // Update the query for highlighting matches
      filteredItems = results;
      isDropdownVisible = input.isNotEmpty && results.isNotEmpty;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Search Bar
        SizedBox(
          height: screenWidth / 8,
          child: TextFormField(
            controller: barController,
            onChanged: filterSearch,
            decoration: InputDecoration(
              filled: true,
              fillColor: const Color(0xFFF4F4F4),
              floatingLabelBehavior: FloatingLabelBehavior.always,
              labelStyle: const TextStyle(color: Colors.black, fontSize: 18),
              prefixIcon: const Icon(Icons.search, color: Color(0xFFBEBEBE)),
              hintText: "Search what you'd like to order",
              hintStyle:
                  const TextStyle(fontSize: 16, color: Color(0xFFBEBEBE)),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(35),
                borderSide: const BorderSide(color: Color(0xFFF4F4F4)),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(35),
                borderSide:
                    const BorderSide(color: Color(0xFFF4F4F4), width: 2),
              ),
            ),
          ),
        ),
        if (isDropdownVisible)
          Container(
            constraints: const BoxConstraints(maxHeight: 150),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 8,
                  spreadRadius: 2,
                ),
              ],
            ),
            child: ListView.builder(
              itemCount: filteredItems.length,
              itemBuilder: (context, index) {
                final item = filteredItems[index];
                return ListTile(
                  title: _buildHighlightedText(item.itemName, query),
                  onTap: () {
                    // Handle item selection
                    barController.text = item.itemName;
                    setState(() {
                      isDropdownVisible = false; // Close the dropdown
                    });
                  },
                );
              },
            ),
          ),
      ],
    );
  }

  // Helper method to highlight matching text
  Widget _buildHighlightedText(String itemName, String query) {
    final lowercaseName = itemName.toLowerCase();
    final lowercaseQuery = query.toLowerCase();

    // Find the index of the matching query in the item name
    final matchIndex = lowercaseName.indexOf(lowercaseQuery);

    if (matchIndex == -1) {
      // No match, return regular text
      return Text(
        itemName,
        style: TextStyle(fontSize: screenWidth / 25),
      );
    }

    // Split the text into three parts: before, match, after
    final beforeMatch = itemName.substring(0, matchIndex);
    final matchText = itemName.substring(matchIndex, matchIndex + query.length);
    final afterMatch = itemName.substring(matchIndex + query.length);

    return RichText(
      text: TextSpan(
        children: [
          TextSpan(
            text: beforeMatch,
            style: TextStyle(
                fontFamily: 'Poppins',
                color: Colors.black,
                fontSize: screenWidth / 24),
          ),
          TextSpan(
            text: matchText,
            style: TextStyle(
                fontFamily: 'Poppins',
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: screenWidth / 24),
          ),
          TextSpan(
            text: afterMatch,
            style: TextStyle(
                fontFamily: 'Poppins',
                color: Colors.black,
                fontSize: screenWidth / 24),
          ),
        ],
      ),
    );
  }
}
