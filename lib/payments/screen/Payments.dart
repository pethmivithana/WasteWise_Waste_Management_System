import 'package:csse_waste_management/payments/data/firestore.dart';
import 'package:csse_waste_management/payments/screen/Pay.dart';
import 'package:csse_waste_management/payments/screen/UsePoints.dart';
import 'package:flutter/material.dart';

class PaymentPage extends StatefulWidget {
  const PaymentPage({super.key});

  @override
  _PaymentPageState createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  final FirestoreDatasource _firestoreDatasource = FirestoreDatasource();
  double fineAmount = 1000.0;
  double remainingFine = 1000.0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Payment'),
        backgroundColor: const Color(0xFF00C04B), // App bar color
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Your Monthly Fine: LKR $fineAmount',
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            Text(
              'Remaining Fine After Points: LKR $remainingFine',
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 40),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF00C04B), // Button color
                padding:
                    const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10), // Rounded corners
                ),
              ),
              onPressed: () async {
                // Navigate to UsePointsPage and await for points usage
                final newRemainingFine = await Navigator.push<double>(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        UsePointsPage(fineAmount: remainingFine),
                  ),
                );
                // Update the remaining fine
                if (newRemainingFine != null) {
                  setState(() {
                    remainingFine = newRemainingFine;
                  });
                }
              },
              child: const Text(
                'Use Points',
                style:
                    TextStyle(fontSize: 18, color: Colors.white), // Text style
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF00C04B), // Button color
                padding:
                    const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10), // Rounded corners
                ),
              ),
              onPressed: () {
                // Navigate to PayPage with the remaining fine
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          PayPage(payableAmount: remainingFine)),
                );
              },
              child: const Text(
                'Pay Directly',
                style:
                    TextStyle(fontSize: 18, color: Colors.white), // Text style
              ),
            ),
          ],
        ),
      ),
    );
  }
}
