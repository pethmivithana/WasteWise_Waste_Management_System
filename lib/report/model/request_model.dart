class RequestModel {
  String id;
  String category;
  String description;

  bool isResolved;

  RequestModel({
    required this.id,
    required this.category,
    required this.description,
    required this.isResolved,
  });

  // Convert Firestore document to RequestModel
  factory RequestModel.fromFirestore(Map<String, dynamic> data, String id) {
    return RequestModel(
      id: id,
      category: data['category'],
      description: data['description'],
      isResolved: data['isResolved'],
    );
  }

  // Convert RequestModel to Firestore document
  Map<String, dynamic> toFirestore() {
    return {
      'category': category,
      'description': description,
      'isResolved': isResolved,
    };
  }
}
