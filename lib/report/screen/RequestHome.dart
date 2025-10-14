import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:csse_waste_management/report/model/request_model.dart';
// Fixed import statement
import 'package:csse_waste_management/report/screen/AddRequset.dart';
import 'package:flutter/material.dart';

class RequestHome extends StatefulWidget {
  const RequestHome({super.key});

  @override
  _RequestHomeState createState() => _RequestHomeState();
}

class _RequestHomeState extends State<RequestHome> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Requests'),
        backgroundColor: Colors.green, // Green color for the app bar
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection('requests').snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final requests = snapshot.data!.docs.map((doc) {
            return RequestModel.fromFirestore(
                doc.data() as Map<String, dynamic>, doc.id);
          }).toList();

          return ListView.builder(
            itemCount: requests.length,
            itemBuilder: (context, index) {
              final request = requests[index];
              return Card(
                margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                elevation: 4, // Add elevation for shadow effect
                child: ListTile(
                  title: Text(
                    request.category,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      color: Colors.green, // Green color for the title
                    ),
                  ),
                  subtitle: Text(
                    request.description,
                    style: const TextStyle(fontSize: 16),
                  ),
                  trailing: Chip(
                    label: Text(
                      request.isResolved ? 'Resolved' : 'Not Resolved',
                      style: TextStyle(
                        color: request.isResolved ? Colors.white : Colors.black,
                      ),
                    ),
                    backgroundColor: request.isResolved
                        ? Colors.green
                        : Colors.red, // Chip color based on status
                  ),
                  onTap: () {
                    // Optional: Navigate to request details or perform action on tap
                  },
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Navigate to the AddRequestScreen when button is pressed
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AddRequestScreen()),
          );
        },
        backgroundColor: Colors.green, // Green color for the button
        child: const Icon(Icons.add),
      ),
    );
  }
}
