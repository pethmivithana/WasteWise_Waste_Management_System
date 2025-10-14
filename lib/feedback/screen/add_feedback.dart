import 'package:csse_waste_management/feedback/data/firestore.dart';
import 'package:csse_waste_management/feedback/model/feedback_model.dart';
import 'package:flutter/material.dart';

class AddFeedbackPage extends StatefulWidget {
  final Function(FeedbackModel feedback)? onFeedbackAdded;

  const AddFeedbackPage({super.key, this.onFeedbackAdded});

  @override
  _AddFeedbackPageState createState() => _AddFeedbackPageState();
}

class _AddFeedbackPageState extends State<AddFeedbackPage> {
  final TextEditingController _commentsController = TextEditingController();
  final TextEditingController _issueDescriptionController =
      TextEditingController();
  String? _selectedCategory;
  int _rating = 0;
  bool _hadIssues = false;

  final Firestore_Datasource _firestoreDatasource =
      Firestore_Datasource(); // Firestore datasource instance

  final List<String> _categories = [
    'Reminders',
    'Garbage Tips',
    'Pickup Request',
    'Get Incentives',
    'Pay a Fee',
    'General Feedback'
  ];

  void _submitFeedback() async {
    if (_selectedCategory != null && _rating > 0) {
      String category = _selectedCategory!;
      String comments = _commentsController.text.trim();
      String issueDescription =
          _hadIssues ? _issueDescriptionController.text.trim() : '';

      // Create the FeedbackModel object
      FeedbackModel feedback = FeedbackModel(
        id: DateTime.now().toString(), // Generate a unique ID
        category: category,
        rating: _rating,
        comments: comments,
        hadIssues: _hadIssues,
        issueDescription: issueDescription.isNotEmpty ? issueDescription : null,
      );

      bool success = await _firestoreDatasource
          .addFeedback(feedback); // Add feedback to Firestore
      if (success) {
        if (widget.onFeedbackAdded != null) {
          widget.onFeedbackAdded!(
              feedback); // Call the callback function if provided
        }
        Navigator.pop(context); // Return to the previous page
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text('Failed to submit feedback. Please try again.')),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Please select a category and provide a rating.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Provide Feedback'),
        backgroundColor: Colors.green, // Green app bar color
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            const Text(
              'Select Category',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            DropdownButton<String>(
              hint: const Text('Select Category'),
              value: _selectedCategory,
              onChanged: (String? newValue) {
                setState(() {
                  _selectedCategory = newValue;
                });
              },
              items: _categories.map((String category) {
                return DropdownMenuItem<String>(
                  value: category,
                  child: Text(category),
                );
              }).toList(),
            ),
            const SizedBox(height: 16),
            const Text(
              'Rate your experience',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Row(
              children: List.generate(5, (index) {
                return IconButton(
                  icon: Icon(
                    _rating > index ? Icons.star : Icons.star_border,
                    color: Colors.amber,
                  ),
                  onPressed: () {
                    setState(() {
                      _rating = index + 1;
                    });
                  },
                );
              }),
            ),
            const SizedBox(height: 16),
            const Text(
              'Additional Comments',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            TextField(
              controller: _commentsController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Enter your feedback',
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                      color: Colors.green), // Green border when focused
                ),
              ),
              maxLines: 4,
            ),
            const SizedBox(height: 16),
            CheckboxListTile(
              title: const Text('Did you experience any issues?'),
              value: _hadIssues,
              onChanged: (bool? value) {
                setState(() {
                  _hadIssues = value ?? false;
                });
              },
              controlAffinity:
                  ListTileControlAffinity.leading, // Align checkbox to the left
            ),
            if (_hadIssues)
              TextField(
                controller: _issueDescriptionController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Describe the issue',
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                        color: Colors.green), // Green border when focused
                  ),
                ),
                maxLines: 2,
              ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _submitFeedback,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green, // Green button color
                padding:
                    const EdgeInsets.symmetric(vertical: 16), // Button padding
              ),
              child: const Text(
                'Submit Feedback',
                style: TextStyle(fontSize: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
