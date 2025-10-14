import 'package:csse_waste_management/payments/data/firestore.dart';
import 'package:flutter/material.dart';

class UsePointsPage extends StatefulWidget {
  final double fineAmount;

  const UsePointsPage({super.key, required this.fineAmount});

  @override
  _UsePointsPageState createState() => _UsePointsPageState();
}

class _UsePointsPageState extends State<UsePointsPage> {
  final FirestoreDatasource _firestoreDatasource = FirestoreDatasource();
  int totalPoints = 0;

  @override
  void initState() {
    super.initState();
    _fetchTotalPoints();
  }

  Future<void> _fetchTotalPoints() async {
    totalPoints = await _firestoreDatasource.getTotalClarifiedPoints();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    double totalAmountAfterPoints = widget.fineAmount - (totalPoints * 100);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Use Points'),
        backgroundColor: const Color(0xFF00C04B), // App bar color
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Points Redemption',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            Text(
              'Total Points Available: $totalPoints',
              style: const TextStyle(fontSize: 20),
            ),
            const SizedBox(height: 10),
            Text(
              'Fine Amount: LKR ${widget.fineAmount}',
              style: const TextStyle(fontSize: 20),
            ),
            const SizedBox(height: 10),
            Text(
              'Total Amount After Using Points: LKR ${totalAmountAfterPoints < 0 ? 0 : totalAmountAfterPoints}',
              style: const TextStyle(fontSize: 20),
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF00C04B), // Button background color
                padding:
                    const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10), // Rounded corners
                ),
              ),
              onPressed: () async {
                // Deduct points and get the remaining amount
                double newRemainingFine = await _firestoreDatasource
                    .deductPoints(widget.fineAmount, totalPoints);

                // Save the payment and navigate back to PaymentPage
                await _firestoreDatasource.addPayment(newRemainingFine, true);

                // Pass the remaining fine back to PaymentPage
                Navigator.pop(context, newRemainingFine);
              },
              child: const Text('Use Points and Pay',
                  style: TextStyle(fontSize: 18)),
            ),
            const SizedBox(height: 10),
            const Text(
              'Click the button above to use your points for the fine payment.',
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}
