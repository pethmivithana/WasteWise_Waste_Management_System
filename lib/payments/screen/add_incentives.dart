import 'package:flutter/material.dart';

class AddIncentivesPage extends StatefulWidget {
  final Function(String category, double quantity) onIncentiveAdded;

  const AddIncentivesPage({super.key, required this.onIncentiveAdded});

  @override
  _AddIncentivesPageState createState() => _AddIncentivesPageState();
}

class _AddIncentivesPageState extends State<AddIncentivesPage> {
  final TextEditingController _quantityController = TextEditingController();
  String? _selectedCategory;
  double _points = 0; // Initialize points

  // List of categories
  final List<String> _categories = ['Plastic', 'Paper', 'Glass', 'E-Waste'];

  void _submit() {
    if (_selectedCategory != null && _quantityController.text.isNotEmpty) {
      String category = _selectedCategory!;
      double quantity = double.tryParse(_quantityController.text.trim()) ?? 0.0;

      if (quantity > 0) {
        widget.onIncentiveAdded(category, quantity); // Call the callback
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Incentive added successfully!')),
        );
        Navigator.pop(context); // Return to previous page
      } else {
        // Show error if quantity is not valid
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please enter a valid quantity.')),
        );
      }
    } else {
      // Show error if fields are empty or invalid
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Please select a category and enter a quantity.')),
      );
    }
  }

  void _calculatePoints() {
    double quantity = double.tryParse(_quantityController.text.trim()) ?? 0.0;
    setState(() {
      _points = quantity; // 1kg = 1 point
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Incentive'),
        backgroundColor: const Color(0xFF00C04B), // Set AppBar color
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Select Category',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            DropdownButton<String>(
              key: Key('categoryDropdown'),
              hint: const Text('Select Category'),
              value: _selectedCategory,
              onChanged: (String? newValue) {
                setState(() {
                  _selectedCategory = newValue;
                });
              },
              items:
                  _categories.map<DropdownMenuItem<String>>((String category) {
                return DropdownMenuItem<String>(
                  value: category,
                  child: Text(category),
                );
              }).toList(),
              isExpanded: true, // Make the dropdown full width
            ),
            const SizedBox(height: 16),
            const Text(
              'Quantity (kg)',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            TextField(
              controller: _quantityController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Enter quantity',
                hintText: 'e.g. 5',
              ),
              keyboardType: TextInputType.number,
              onChanged: (value) =>
                  _calculatePoints(), // Calculate points on quantity change
            ),
            const SizedBox(height: 10),
            // Display calculated points and currency
            Text(
              'Points: ${_points.toStringAsFixed(0)} (Value: ${(_points * 100).toStringAsFixed(0)} LKR)',
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _submit,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF00C04B), // Set button color
                padding: const EdgeInsets.symmetric(
                    vertical: 12.0, horizontal: 20.0),
                textStyle: const TextStyle(fontSize: 18),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8)), // Rounded corners
              ),
              child: const Text('Submit'),
            ),
          ],
        ),
      ),
    );
  }
}
