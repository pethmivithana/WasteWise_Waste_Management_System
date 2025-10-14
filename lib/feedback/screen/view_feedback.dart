import 'package:csse_waste_management/feedback/data/firestore.dart';
import 'package:csse_waste_management/feedback/model/feedback_model.dart';
import 'package:csse_waste_management/feedback/screen/add_feedback.dart';
import 'package:flutter/material.dart';

class ViewFeedbackPage extends StatefulWidget {
  const ViewFeedbackPage({super.key});

  @override
  _ViewFeedbackPageState createState() => _ViewFeedbackPageState();
}

class _ViewFeedbackPageState extends State<ViewFeedbackPage> {
  final Firestore_Datasource firestoreDatasource = Firestore_Datasource();

  // Method to display stars based on the rating
  Widget buildStarRating(int rating) {
    return Row(
      children: List.generate(5, (index) {
        return Icon(
          index < rating ? Icons.star : Icons.star_border,
          color: const Color(0xFF00C04B),
          size: 20.0,
        );
      }),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('View Feedback'),
        backgroundColor:
            const Color(0xFF00C04B), // Set a background color for the app bar
      ),
      body: StreamBuilder<List<FeedbackModel>>(
        stream: firestoreDatasource.getFeedbacks(), // Stream from Firestore
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return const Center(child: Text('Error fetching feedbacks'));
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No feedback available'));
          }

          final feedbackList = snapshot.data!;

          return ListView.builder(
            itemCount: feedbackList.length,
            itemBuilder: (context, index) {
              final feedback = feedbackList[index];
              return Card(
                margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                elevation: 4, // Add some elevation to the card
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10), // Rounded corners
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: ListTile(
                    title: Text(
                      feedback.category,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        buildStarRating(feedback.rating), // Display star rating
                        if (feedback.comments.isNotEmpty)
                          Padding(
                            padding: const EdgeInsets.only(top: 8.0),
                            child: Text(
                              'Comments: ${feedback.comments}',
                              style: const TextStyle(fontSize: 14),
                            ),
                          ),
                        if (feedback.hadIssues)
                          Padding(
                            padding: const EdgeInsets.only(top: 4.0),
                            child: Text(
                              'Issues: ${feedback.issueDescription ?? "None"}',
                              style: const TextStyle(
                                fontSize: 14,
                                color: Colors.red, // Highlight issues in red
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AddFeedbackPage()),
          );
        },
        tooltip: 'Add Feedback',
        backgroundColor: const Color(0xFF00C04B),
        child: const Icon(Icons.add), // Match the color with the app bar
      ),
    );
  }
}
