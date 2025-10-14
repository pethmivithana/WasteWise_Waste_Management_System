class FeedbackModel {
  final String id;
  final String category;
  final int rating;
  final String comments;
  final bool hadIssues;
  final String? issueDescription;

  FeedbackModel({
    required this.id,
    required this.category,
    required this.rating,
    required this.comments,
    required this.hadIssues,
    this.issueDescription,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'category': category,
      'rating': rating,
      'comments': comments,
      'hadIssues': hadIssues,
      'issueDescription': issueDescription,
    };
  }

  static FeedbackModel fromMap(Map<String, dynamic> map) {
    return FeedbackModel(
      id: map['id'],
      category: map['category'],
      rating: map['rating'],
      comments: map['comments'],
      hadIssues: map['hadIssues'],
      issueDescription: map['issueDescription'],
    );
  }
}
