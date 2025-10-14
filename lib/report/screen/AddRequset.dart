import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

class AddRequestScreen extends StatefulWidget {
  const AddRequestScreen({super.key});

  @override
  _AddRequestScreenState createState() => _AddRequestScreenState();
}

class _AddRequestScreenState extends State<AddRequestScreen> {
  final TextEditingController _descriptionController = TextEditingController();
  String _selectedCategory = 'Pickup Request'; // Default category
  final List<String> _categories = [
    'Pickup Request',
    'Get Incentives',
    'Pay a Fee',
    'General Report'
  ];

  void _addRequest() {
    if (_descriptionController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a description')),
      );
      return;
    }

    var uuid = const Uuid().v4();
    FirebaseFirestore.instance.collection('requests').doc(uuid).set({
      'id': uuid,
      'category': _selectedCategory,
      'description': _descriptionController.text,
      'fee': _selectedCategory == 'Pay a Fee' ? 0 : 0,
      'isResolved': false,
      'requestDate': Timestamp.now(),
    }).then((value) {
      Navigator.pop(context); // Go back to the home screen after adding
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Request added successfully!')),
      );
    }).catchError((error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to add request: $error')),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add New Request'),
        backgroundColor: Colors.green, // Green color for the app bar
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Select Request Category',
              style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.green),
            ),
            const SizedBox(height: 10),
            DropdownButtonFormField<String>(
              value: _selectedCategory,
              onChanged: (newValue) {
                setState(() {
                  _selectedCategory = newValue!;
                });
              },
              items:
                  _categories.map<DropdownMenuItem<String>>((String category) {
                return DropdownMenuItem<String>(
                  value: category,
                  child: Text(category),
                );
              }).toList(),
              decoration: InputDecoration(
                border: const OutlineInputBorder(),
                contentPadding: const EdgeInsets.symmetric(horizontal: 10),
                filled: true,
                fillColor: Colors.green[50], // Light green background
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Description',
              style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.green),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _descriptionController,
              maxLines: 3,
              decoration: InputDecoration(
                hintText: 'Enter a detailed description...',
                border: const OutlineInputBorder(),
                contentPadding: const EdgeInsets.symmetric(horizontal: 10),
                filled: true,
                fillColor: Colors.green[50], // Light green background
              ),
            ),
            const SizedBox(height: 30),
            Center(
              child: ElevatedButton(
                onPressed: _addRequest,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green, // Green button color
                  padding:
                      const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10), // Rounded corners
                  ),
                ),
                child: const Text(
                  'Submit Request',
                  style: TextStyle(fontSize: 18), // Larger button text
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
