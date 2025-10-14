import 'package:csse_waste_management/payments/data/firestore.dart';
import 'package:csse_waste_management/payments/model/incentives.dart';
import 'package:csse_waste_management/payments/screen/add_incentives.dart';
import 'package:flutter/material.dart';

class IncentivesPage extends StatefulWidget {
  const IncentivesPage({super.key});

  @override
  _IncentivesPageState createState() => _IncentivesPageState();
}

class _IncentivesPageState extends State<IncentivesPage> {
  final FirestoreDatasource _firestoreDatasource = FirestoreDatasource();
  List<Incentive> incentives = [];

  @override
  void initState() {
    super.initState();
    _fetchIncentives(); // Fetch incentives when the page loads
  }

  void _fetchIncentives() {
    _firestoreDatasource.getIncentives().listen((incentivesList) {
      setState(() {
        incentives =
            incentivesList; // Update the local state with incentives from Firestore
      });
    });
  }

  void _addIncentive(String category, double quantity) async {
    bool success = await _firestoreDatasource.addIncentive(category, quantity);
    if (success) {
      // Optionally, show a success message
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Incentive added successfully!')),
      );
    } else {
      // Optionally, show an error message
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to add incentive.')),
      );
    }
  }

  // Calculate the total incentive points
  double _getTotalIncentivePoints() {
    return incentives.fold(0, (total, incentive) => total + incentive.points);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Your Incentives')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            FutureBuilder<int>(
              future: _firestoreDatasource.getTotalClarifiedPoints(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const CircularProgressIndicator();
                } else if (snapshot.hasError) {
                  return const Text('Error fetching total points');
                } else {
                  return Padding(
                    padding: const EdgeInsets.only(top: 16.0),
                    child: Text(
                      'Total Incentive Points: ${snapshot.data}',
                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  );
                }
              },
            ),
            Expanded(
              child: incentives.isNotEmpty
                  ? ListView.builder(
                      itemCount: incentives.length,
                      itemBuilder: (context, index) {
                        Incentive incentive = incentives[index];
                        return Card(
                          margin: const EdgeInsets.symmetric(vertical: 8.0),
                          child: ListTile(
                            title: Text(
                              'Category: ${incentive.category}',
                              style: const TextStyle(fontWeight: FontWeight.bold),
                            ),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Quantity: ${incentive.quantity} kg'),
                                Text('Points: ${incentive.points}'),
                                Text(
                                  'Clarified: ${incentive.isClarified ? "Clarified" : "Pending Clarification"}',
                                  style: TextStyle(
                                    color: incentive.isClarified
                                        ? const Color(0xFF00C04B)
                                        : Colors.red,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    )
                  : const Center(
                      child: Text(
                        'No incentives added yet.',
                        style: TextStyle(fontSize: 18, color: Colors.grey),
                      ),
                    ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 16.0),
              child: ElevatedButton(
                onPressed: () {
                  // Navigate to AddIncentivesPage
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => AddIncentivesPage(
                        onIncentiveAdded: (category, quantity) {
                          _addIncentive(category, quantity); // Call addIncentive method
                        },
                      ),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF00C04B), // Set button color
                  padding: const EdgeInsets.symmetric(
                      vertical: 12.0, horizontal: 20.0),
                  textStyle: const TextStyle(fontSize: 18),
                ),
                child: const Text('Add Incentive'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
