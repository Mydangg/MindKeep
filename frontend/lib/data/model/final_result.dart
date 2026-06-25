class FinalResult {
  FinalResult({
    required this.examId,
    required this.depressionScore,
    required this.anxietyScore,
    required this.stressScore,
    required this.conclusion,
  });

  factory FinalResult.fromJson(Map<String, dynamic> json) {
    return FinalResult(
      anxietyScore: _toDoubleSafe(json['anxiety']).toInt(),
      depressionScore: _toDoubleSafe(json['depression']).toInt(),
      stressScore: _toDoubleSafe(json['stress']).toInt(),
      examId: json['test_id'],
      conclusion: json['result_test'],
    );
  }
  final String examId;
  final int depressionScore;
  final int anxietyScore;
  final int stressScore;
  final String conclusion;

  static double _toDoubleSafe(dynamic value) {
    if (value is num) return value.toDouble();
    if (value is String) return double.tryParse(value) ?? 0.0;
    return 0;
  }
}
