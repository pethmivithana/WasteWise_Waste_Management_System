import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:csse_waste_management/pickup/model/pickup_model.dart';
import 'package:firebase_auth/firebase_auth.dart';

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

  Future<bool> addPickup(Pickup pickup) async {
    try {
      await _firestore.collection('pickups').add(pickup.toMap());
      return true;
    } catch (e) {
      print('Error adding pickup: $e');
      return false;
    }
  }

  Stream<List<Pickup>> getPickupRequests() {
    return _firestore.collection('pickups').snapshots().map((snapshot) {
      return snapshot.docs.map((doc) => Pickup.fromSnapshot(doc)).toList();
    });
  }
}

// Stream pickup requests

List<Pickup> getPickups(QuerySnapshot snapshot) {
  try {
    final pickupList = snapshot.docs.map((doc) {
      return Pickup.fromSnapshot(doc);
    }).toList();
    return pickupList;
  } catch (e) {
    print('Error parsing pickups: $e');
    return [];
  }
}

  // Update a pickup request