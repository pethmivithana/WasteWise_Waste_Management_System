
class Incentive {
  String id; // Unique ID for each incentive entry
  String category; // Selected category (plastic, paper, etc.)
  double quantity; // Quantity in kg
  int points; // Calculated points based on quantity
  bool isClarified; // Status to indicate whether points are clarified by admin

  Incentive({
    required this.id,
    required this.category,
    required this.quantity,
    required this.points,
    this.isClarified = false,
  });

  // Factory method to create an Incentive from a map (e.g., from a database)
  factory Incentive.fromMap(Map<String, dynamic> map) {
    return Incentive(
      id: map['id'],
      category: map['category'],
      quantity: map['quantity'],
      points: map['points'],
      isClarified: map['isClarified'] ?? false,
    );
  }

  // Convert to map to store in a database
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'category': category,
      'quantity': quantity,
      'points': points,
      'isClarified': isClarified,
    };
  }
}
