import 'package:csse_waste_management/pickup/data/firestore.dart';
import 'package:csse_waste_management/pickup/model/pickup_model.dart';
import 'package:csse_waste_management/pickup/screen/PickupRequestPage.dart';
import 'package:flutter/material.dart';

class PickupHome extends StatelessWidget {
  final FirestoreDatasource _firestoreDatasource = FirestoreDatasource();

  PickupHome({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pickup Requests'),
        centerTitle: true,
      ),
      body: StreamBuilder<List<Pickup>>(
        stream: _firestoreDatasource.getPickupRequests(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          List<Pickup> pickups = snapshot.data ?? [];

          if (pickups.isEmpty) {
            return const Center(child: Text('No pickup requests found.'));
          }

          return ListView.builder(
            itemCount: pickups.length,
            itemBuilder: (context, index) {
              Pickup pickup = pickups[index];

              // Determine text for status
              String statusText =
                  pickup.status == 'pending' ? 'Pending' : 'Completed';

              return Card(
                margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        pickup.selectedGarbageType,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Address: ${pickup.enteredAddress}',
                        style: const TextStyle(fontSize: 14),
                      ),
                      Text(
                        'Size: ${pickup.selectedGarbageSize}',
                        style: const TextStyle(fontSize: 14),
                      ),
                      Text(
                        'Date: ${pickup.selectedDate.toLocal().toString().split(' ')[0]}',
                        style: const TextStyle(fontSize: 14),
                      ),
                      Text(
                        'Fee: \$${pickup.fee.toStringAsFixed(2)}',
                        style: const TextStyle(fontSize: 14),
                      ),
                      const SizedBox(height: 10),
                      // Display status as a colored button
                      Align(
                        alignment: Alignment.centerRight,
                        child: SizedBox(
                          width: 150, // Set a fixed width for the button
                          child: ElevatedButton(
                            onPressed: () {
                              // Implement any action if needed
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: pickup.status == 'completed'
                                  ? const Color(
                                      0xFF00C04B) // Green for completed
                                  : const Color.fromARGB(
                                      255, 234, 21, 21), // Red for pending
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            child: Text(
                              statusText,
                              style: const TextStyle(color: Colors.white),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
      // Updated FloatingActionButton to show 'Add Pickup Request'
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const PickupRequestPage()),
          );
        },
        label: const Text('Add Pickup Request'), // Button text
        icon: const Icon(Icons.add), // Button icon
        backgroundColor: const Color(0xFF00C04B), // Button color
      ),
    );
  }
}
