import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:csse_waste_management/feedback/model/feedback_model.dart';
import 'package:csse_waste_management/payments/model/paymentsModel.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Firestore_Datasource {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Create a new user in Firestore
  Future<bool> CreateUser(String email) async {
    try {
      await _firestore
          .collection('users')
          .doc(_auth.currentUser!.uid)
          .set({"id": _auth.currentUser!.uid, "email": email});
      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }

  // Add Feedback to Firestore
  Future<bool> addFeedback(FeedbackModel feedback) async {
    try {
      await _firestore
          .collection('users')
          .doc(_auth.currentUser!.uid)
          .collection('feedbacks')
          .doc(feedback.id)
          .set(feedback.toMap());
      return true;
    } catch (e) {
      print('Error adding feedback: $e');
      return false;
    }
  }

  // Stream of Feedback
  Stream<List<FeedbackModel>> getFeedbacks() {
    return _firestore
        .collection('users')
        .doc(_auth.currentUser!.uid)
        .collection('feedbacks')
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        return FeedbackModel.fromMap(doc.data());
      }).toList();
    });
  }

  getIncentives() {}

  addIncentive(String category, double quantity) {}

  savePayment(Payment payment) {}
}
