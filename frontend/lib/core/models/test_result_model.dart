class TestResult {
  final String predictedEmotion;
  final int depressionScore;
  final int anxietyScore;
  final int stressScore;
  final String conclusion; // Kết luận/lời khuyên ngắn
  final DoctorInfo? doctor; // Thông tin bác sĩ

  // ignore: sort_constructors_first
  TestResult({
    required this.predictedEmotion,
    required this.depressionScore,
    required this.anxietyScore,
    required this.stressScore,
    required this.conclusion,
    this.doctor,
  });
}

class DoctorInfo {
  final String name;
  final String phone;
  final String imageUrl;

  // ignore: sort_constructors_first
  DoctorInfo({required this.name, required this.phone, required this.imageUrl});
}
