import 'package:csse_waste_management/feedback/data/firestore.dart';
import 'package:csse_waste_management/feedback/model/feedback_model.dart';
import 'package:csse_waste_management/feedback/screen/add_feedback.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

// Mock class for Firestore_Datasource
class MockFirestoreDatasource extends Mock implements Firestore_Datasource {}

void main() {
  testWidgets('Submit feedback with all required fields',
      (WidgetTester tester) async {
    // Create a mock Firestore datasource
    final mockFirestoreDatasource = MockFirestoreDatasource();

    // Build the AddFeedbackPage widget
    await tester.pumpWidget(MaterialApp(
      home: AddFeedbackPage(
        onFeedbackAdded: (FeedbackModel feedback) {
          // Callback function to handle feedback added
        },
      ),
    ));

    // Select a category
    await tester.tap(find.byType(DropdownButton<String>));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Reminders').last);
    await tester.pumpAndSettle();

    // Set a rating
    await tester.tap(find.byIcon(Icons.star).first);
    await tester.pumpAndSettle();

    // Enter comments
    await tester.enterText(find.byType(TextField).first, 'Great service!');

    // Submit feedback
    await tester.tap(find.text('Submit'));
    await tester.pumpAndSettle();
  });
}
//flutter test test/add_feedback_page_test.dart