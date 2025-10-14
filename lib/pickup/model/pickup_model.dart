import 'package:cloud_firestore/cloud_firestore.dart';

class Pickup {
  String enteredAddress;
  String selectedGarbageType;
  String selectedGarbageSize;
  DateTime selectedDate;
  double fee;
  String status; // "pending" or "completed"

  Pickup({
    required this.enteredAddress,
    required this.selectedGarbageType,
    required this.selectedGarbageSize,
    required this.selectedDate,
    required this.fee,
    this.status = 'pending', // Default status is pending
  });

  Map<String, dynamic> toMap() {
    return {
      'enteredAddress': enteredAddress,
      'selectedGarbageType': selectedGarbageType,
      'selectedGarbageSize': selectedGarbageSize,
      'selectedDate': selectedDate,
      'fee': fee,
      'status': status,
    };
  }

  static Pickup fromSnapshot(DocumentSnapshot snapshot) {
    return Pickup(
      enteredAddress: snapshot['enteredAddress'],
      selectedGarbageType: snapshot['selectedGarbageType'],
      selectedGarbageSize: snapshot['selectedGarbageSize'],
      selectedDate: (snapshot['selectedDate'] as Timestamp).toDate(),
      fee: snapshot['fee'],
      status: snapshot['status'] ?? 'pending',
    );
  }
}