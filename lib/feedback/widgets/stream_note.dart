import 'package:csse_waste_management/feedback/data/firestore.dart';
import 'package:csse_waste_management/feedback/model/feedback_model.dart';
import 'package:flutter/material.dart';


class FeedbackStream extends StatelessWidget {
  const FeedbackStream({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<FeedbackModel>>(
      stream: Firestore_Datasource().getFeedbacks(),  // Stream feedback data
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          // Show loading spinner while data is being fetched
          return const Center(child: CircularProgressIndicator());
        }

        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          // Show message when there are no feedbacks
          return const Center(child: Text('No feedbacks available.'));
        }

        // Fetch the list of feedbacks from the snapshot
        final feedbackList = snapshot.data!;

        // Display the feedbacks in a ListView
        return ListView.builder(
          itemCount: feedbackList.length,
          itemBuilder: (context, index) {
            final feedback = feedbackList[index];

            // Display each feedback in a ListTile
            return ListTile(
              title: Text(feedback.category),  // Display the category of feedback
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Rating: ${feedback.rating}'),  // Display the rating
                  Text('Comments: ${feedback.comments}'),  // Display the comments
                  if (feedback.hadIssues)  // Check if there were issues
                    Text('Issues: ${feedback.issueDescription ?? "No description provided"}'),  // Display issue description if exists
                ],
              ),
            );
          },
        );
      },
    );
  }
}
