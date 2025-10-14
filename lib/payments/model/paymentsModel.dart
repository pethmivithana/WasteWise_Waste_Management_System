
class Payment {
  String pay_id; // Unique payment ID
  double amount; // Payment amount (e.g., 500 LKR)
  DateTime paymentDate; // Date of payment



  Payment({
    required this.pay_id,
    required this.amount,
    required this.paymentDate,

  });

  // Create a Payment object from Firestore data
  factory Payment.fromMap(Map<String, dynamic> map) {
    return Payment(
      pay_id: map['pay_id'],
      amount: map['amount'],
      paymentDate: DateTime.parse(map['paymentDate']),


    );
  }

  // Convert the Payment object to a map (for Firestore)
  Map<String, dynamic> toMap() {
    return {
      'pay_id': pay_id,
      'amount': amount,
      'paymentDate': paymentDate.toIso8601String(),

 
    };
  }
}
