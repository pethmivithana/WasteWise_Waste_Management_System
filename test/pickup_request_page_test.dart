import 'package:csse_waste_management/pickup/screen/PaymentPage.dart';
import 'package:csse_waste_management/pickup/screen/PickupRequestPage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('PickupRequestPage submits a pickup request successfully',
      (WidgetTester tester) async {
    // Build the PickupRequestPage widget
    await tester.pumpWidget(const MaterialApp(home: PickupRequestPage()));

    // Enter address
    await tester.enterText(find.byType(TextField).first, '123 Main St');

    // Select garbage type
    await tester.tap(find.byType(DropdownButton<String>).first);
    await tester.pumpAndSettle(); // Wait for dropdown to open
    await tester.tap(find.text('Plastic').last); // Select 'Plastic'
    await tester.pumpAndSettle(); // Wait for dropdown to settle

    // Select garbage size
    await tester.tap(
        find.byType(DropdownButton<String>).at(1)); // Second dropdown for size
    await tester.pumpAndSettle(); // Wait for dropdown to open
    await tester.tap(find.text('5-10Kg').last); // Select '5-10Kg'
    await tester.pumpAndSettle(); // Wait for dropdown to settle

    // Select date
    await tester.tap(find.byType(TextField).last); // Tap on date TextField
    await tester.pumpAndSettle(); // Wait for date picker to open
    await tester.tap(find.text('15')); // Select a date (example: 15th)
    await tester.pumpAndSettle(); // Wait for date picker to close

    // Check estimated fee text before submission
    expect(find.text('Estimated Fee: \$900.00'),
        findsOneWidget); // Check the estimated fee

    // Submit the pickup request
    await tester.tap(find.byType(ElevatedButton));
    await tester.pumpAndSettle(); // Wait for the navigation

    // Verify that the PaymentPage is displayed
    expect(find.byType(PaymentPage), findsOneWidget);
  });
}
//flutter test test/pickup_request_page_test.dart