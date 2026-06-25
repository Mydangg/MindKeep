// class Predictions {
//   Predictions({
//     required this.id,
//     required this.email,
//     required this.userId,
//     required this.emotions,
//     required this.finalEmotion,
//     required this.createdAt,
//   });

//   factory Predictions.fromJson(Map<String, dynamic> json) => Predictions(
//     id: json['id'],
//     email: json['email'],
//     userId: json['user_id'],
//     emotions: json['emotions'],
//     finalEmotion: json['final_emotion'],
//     createdAt: DateTime.parse(json['created_at']),
//   );

//   factory Predictions.toJson(Map<String, dynamic> json) => Predictions(
//     id: json['id'],
//     email: json['email'],
//     userId: json['user_id'],
//     emotions: json['emotions'],
//     finalEmotion: json['final_emotion'],
//     createdAt: DateTime.parse(json['created_at']),
//   );

//   String id;
//   String email;
//   String userId;
//   List<dynamic> emotions;
//   String finalEmotion;
//   DateTime createdAt;
// }
class Predictions {
  Predictions({
    required this.id,
    required this.email,
    required this.userId,
    required this.emotions,
    required this.finalEmotion,
    required this.createdAt,
  });

  factory Predictions.fromJson(Map<String, dynamic> json) {
    return Predictions(
      id: (json['id'] ?? json['test_id'] ?? '').toString(),
      email: (json['email'] ?? '').toString(),
      userId: (json['user_id'] ?? '').toString(),
      emotions: json['emotions'] is List
          ? List<dynamic>.from(json['emotions'])
          : [],
      finalEmotion: (json['final_emotion'] ??
              json['input_data']?['emotion'] ??
              'Chưa xác định')
          .toString(),
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'].toString())
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'user_id': userId,
      'emotions': emotions,
      'final_emotion': finalEmotion,
      'created_at': createdAt.toIso8601String(),
    };
  }

  String id;
  String email;
  String userId;
  List<dynamic> emotions;
  String finalEmotion;
  DateTime createdAt;
}