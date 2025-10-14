import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:csse_waste_management/report/screen/AddRequset.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

// Mock class for Firestore
class MockFirebaseFirestore extends Mock implements FirebaseFirestore {}

void main() {
  // Ensure that Flutter is initialized for testing
  TestWidgetsFlutterBinding.ensureInitialized();

  // Create a mock instance of FirebaseFirestore
  final MockFirebaseFirestore mockFirestore = MockFirebaseFirestore();

  group('AddRequestScreen Tests', () {
    testWidgets('Adding a request shows success message',
        (WidgetTester tester) async {
      // Build our app and trigger a frame.
      await tester.pumpWidget(MaterialApp(
        home: AddRequestScreen(),
      ));

      // Verify that the default category is displayed.
      expect(find.text('Pickup Request'), findsOneWidget);

      // Enter a description in the text field
      await tester.enterText(find.byType(TextField), 'Need to pick up waste');
      await tester.pump(); // Rebuild the widget after the state has changed.

      // Tap the dropdown and select a category
      await tester.tap(find.byType(DropdownButtonFormField<String>));
      await tester.pumpAndSettle(); // Wait for the dropdown menu to open

      // Select 'Get Incentives' from the dropdown
      await tester.tap(find.text('Get Incentives').last);
      await tester.pump(); // Rebuild the widget after the selection

      // Tap the submit button
      await tester.tap(find.text('Submit Request'));
      await tester.pumpAndSettle(); // Wait for the button tap to be processed

      // Verify that the success message appears
      expect(find.text('Request added successfully!'), findsOneWidget);
    });
  });
}
//flutter test test/add_request_page_test.dart