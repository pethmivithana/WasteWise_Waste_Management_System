import 'package:csse_waste_management/payments/screen/Incentives_Draft.dart';
import 'package:csse_waste_management/payments/screen/Payments.dart';
import 'package:flutter/material.dart';

class Fee_Management extends StatelessWidget {
  const Fee_Management({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Fee Management'),
        centerTitle: true,
        backgroundColor: const Color(0xFF00C04B),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Padding(
              padding: EdgeInsets.all(20.0),
              child: Text(
                'Welcome to Fee Management!',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF00C04B),
                ),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF00C04B), // Background color
                    padding: const EdgeInsets.symmetric(
                        horizontal: 40, vertical: 20),
                    shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(10), // Rounded corners
                    ),
                  ),
                  onPressed: () {
                    // Navigate to Payments screen
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const PaymentPage(),
                      ), // Link to Payments screen
                    );
                  },
                  child: const Column(
                    children: [
                      Icon(Icons.payment, size: 30),
                      SizedBox(height: 10),
                      Text('Payments', style: TextStyle(fontSize: 16)),
                    ],
                  ),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF00C04B), // Background color
                    padding: const EdgeInsets.symmetric(
                        horizontal: 40, vertical: 20),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  onPressed: () {
                    // Navigate to Incentives (Drafts) screen
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              const IncentivesPage()), // Link to Incentives screen
                    );
                  },
                  child: const Column(
                    children: [
                      Icon(Icons.card_giftcard, size: 30),
                      SizedBox(height: 10),
                      Text('Incentives', style: TextStyle(fontSize: 16)),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 40),
            const Text(
              'Manage your fees and incentives efficiently!',
              style: TextStyle(
                fontSize: 18,
                color: Color(0xFF00C04B),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
