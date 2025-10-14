import 'package:flutter/material.dart';

class MyButtons extends StatelessWidget {
  final VoidCallback onTap;
  final String text;

  const MyButtons({
    super.key,
    required this.onTap,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.8, // Match 80% of screen width
      child: ElevatedButton(
        onPressed: onTap,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.black, // Button background color
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(50), // Rounded corners
          ),
          elevation: 0, // No shadow
          padding: const EdgeInsets.symmetric(vertical: 20), // Adjust vertical padding
          textStyle: const TextStyle(
            fontSize: 17, // Set font size
          ),
        ),
        child: Text(
          text,
          style: const TextStyle(
            color: Colors.green, // Text color set to green
            fontWeight: FontWeight.bold, // Bold text
          ),
        ),
      ),
    );
  }
}
