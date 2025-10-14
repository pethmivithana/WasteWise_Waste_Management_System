import 'package:csse_waste_management/payments/screen/add_incentives.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('Submit valid input shows success message',
      (WidgetTester tester) async {
    // Create a mock function to simulate the onIncentiveAdded callback
    String? addedCategory;
    double? addedQuantity;

    await tester.pumpWidget(
      MaterialApp(
        home: AddIncentivesPage(
          onIncentiveAdded: (category, quantity) {
            addedCategory = category;
            addedQuantity = quantity;
          },
        ),
      ),
    );

    // Ensure the initial state
    expect(find.text('Incentive added successfully!'), findsNothing);

    // Tap the dropdown button directly instead of finding by text
    final categoryButtonFinder = find.byKey(
        Key('categoryDropdown')); // Assume you've added a Key to the dropdown
    await tester.tap(categoryButtonFinder);
    await tester.pumpAndSettle(); // Wait for the dropdown to open

    // Select the category 'Plastic'
    await tester.tap(find.text('Plastic').last); // Select 'Plastic'
    await tester.pumpAndSettle(); // Wait for the dropdown to close

    // Enter a valid quantity
    await tester.enterText(find.byType(TextField), '5'); // Enter quantity

    // Trigger the submit button
    await tester.tap(find.text('Submit'));
    await tester.pump(); // Rebuild the widget after the state change

    // Verify that the success message is displayed
    expect(find.text('Incentive added successfully!'), findsOneWidget);
    expect(addedCategory, 55);
    expect(addedQuantity, 5.0);
  });
}
//flutter test test/add_incentives_page_test.dart