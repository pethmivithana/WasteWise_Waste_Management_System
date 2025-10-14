import 'package:flutter/material.dart';

class CustomDropdown extends StatelessWidget {
  final String? selectedValue;
  final List<String> items;
  final String hintText;
  final Function(String?) onChanged;

  const CustomDropdown({
    super.key,
    required this.selectedValue,
    required this.items,
    required this.hintText,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xFFedf0f8),
          borderRadius: BorderRadius.circular(30),
        ),
        child: Row(
          children: [
            // Icon on the left
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Icon(Icons.location_on, color: Colors.black54),
            ),
            Expanded(
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  value: selectedValue,
                  isExpanded: true,
                  hint: Text(
                    hintText,
                    style: const TextStyle(color: Colors.black45, fontSize: 18),
                  ),
                  dropdownColor: Colors.white,
                  items: items.map((String item) {
                    return DropdownMenuItem<String>(
                      value: item,
                      child: Text(
                        item,
                        style: const TextStyle(fontSize: 20), // Matching text size
                      ),
                    );
                  }).toList(),
                  onChanged: onChanged,
                  style: const TextStyle(fontSize: 20, color: Colors.black), // Matching text style
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
