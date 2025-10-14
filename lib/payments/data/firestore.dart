// firestore.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:csse_waste_management/payments/model/incentives.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:uuid/uuid.dart';

class FirestoreDatasource {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Create a new user in Firestore
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

  // Add an incentive to Firestore
  Future<bool> addIncentive(String category, double quantity) async {
    try {
      var uuid = const Uuid().v4();
      int points = calculatePoints(quantity);

      await _firestore
          .collection('users')
          .doc(_auth.currentUser!.uid)
          .collection('incentives')
          .doc(uuid)
          .set({
        'id': uuid,
        'category': category,
        'quantity': quantity,
        'points': points,
        'isClarified': false,
      });
      return true;
    } catch (e) {
      print('Error adding incentive: $e');
      return false;
    }
  }

  // Calculate points based on quantity
  int calculatePoints(double quantity) {
    return quantity.toInt();
  }

  // Fetch all incentives for the current user
  Stream<List<Incentive>> getIncentives() {
    return _firestore
        .collection('users')
        .doc(_auth.currentUser!.uid)
        .collection('incentives')
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) {
              final data = doc.data();
              return Incentive.fromMap(data);
            }).toList());
  }

  // Fetch and sum points for all clarified incentives
  Future<int> getTotalClarifiedPoints() async {
    try {
      final snapshot = await _firestore
          .collection('users')
          .doc(_auth.currentUser!.uid)
          .collection('incentives')
          .where('isClarified', isEqualTo: true)
          .get();

      int totalPoints = snapshot.docs.fold(0, (sum, doc) {
        final data = doc.data();
        return sum + (data['points'] as int);
      });

      return totalPoints;
    } catch (e) {
      print('Error fetching total clarified points: $e');
      return 0;
    }
  }

  // Deduct points and return remaining fine
  Future<double> deductPoints(double fineAmount, int totalPoints) async {
    double amountAfterPoints = fineAmount - (totalPoints * 100);
    if (amountAfterPoints < 0) amountAfterPoints = 0;
    return amountAfterPoints;
  }

  // Add payment transaction to Firestore
  Future<void> addPayment(double amount, bool paidWithPoints) async {
    await _firestore.collection('payments').add({
      'amount': amount,
      'paidWithPoints': paidWithPoints,
      'timestamp': FieldValue.serverTimestamp(),
    });
  }
}
