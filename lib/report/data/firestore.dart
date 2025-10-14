import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:csse_waste_management/report/model/request_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:uuid/uuid.dart';

class FirestoreDatasource {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Create a new user
  Future<bool> createUser(String email) async {
    try {
      await _firestore
          .collection('users')
          .doc(_auth.currentUser!.uid)
          .set({"id": _auth.currentUser!.uid, "email": email});
      return true;
    } catch (e) {
      print('Error creating user: $e');
      return false;
    }
  }

  // Add a request (reminder, pay fee, or garbage pickup)
  Future<bool> addRequest({
    required String category,
    required String description,
    required double fee, // Optional for fee category
    required DateTime requestDate,
  }) async {
    try {
      var uuid = const Uuid().v4();
      await _firestore
          .collection('users')
          .doc(_auth.currentUser!.uid)
          .collection('requests')
          .doc(uuid)
          .set({
        'id': uuid,
        'category': category,
        'description': description,
        'fee': fee,
        'isResolved': false,
        'requestDate': Timestamp.fromDate(requestDate),
      });
      return true;
    } catch (e) {
      print('Error adding request: $e');
      return false;
    }
  }

  // Stream requests based on the isResolved filter
  Stream<QuerySnapshot> streamRequests(bool isResolved) {
    return _firestore
        .collection('users')
        .doc(_auth.currentUser!.uid)
        .collection('requests')
        .where('isResolved', isEqualTo: isResolved)
        .snapshots();
  }

  // Parse the requests from Firestore snapshot
  List<RequestModel> getRequests(QuerySnapshot snapshot) {
    try {
      final requestList = snapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        return RequestModel(
          id: doc.id,
          category: data['category'],
          description: data['description'],
          isResolved: data['isResolved'],
        );
      }).toList();
      return requestList;
    } catch (e) {
      print('Error parsing requests: $e');
      return [];
    }
  }

  // Update a request (e.g., after admin resolves it)
  Future<bool> updateRequest({
    required String uuid,
    required String category,
    required String description,
    required double fee,
    required bool isResolved,
  }) async {
    try {
      await _firestore
          .collection('users')
          .doc(_auth.currentUser!.uid)
          .collection('requests')
          .doc(uuid)
          .update({
        'category': category,
        'description': description,
        'fee': fee,
        'isResolved': isResolved,
      });
      return true;
    } catch (e) {
      print('Error updating request: $e');
      return false;
    }
  }

  // Delete a request
  Future<bool> deleteRequest(String uuid) async {
    try {
      await _firestore
          .collection('users')
          .doc(_auth.currentUser!.uid)
          .collection('requests')
          .doc(uuid)
          .delete();
      return true;
    } catch (e) {
      print('Error deleting request: $e');
      return false;
    }
  }
}
