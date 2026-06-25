import 'package:frontend/data/model/dass21_result.dart';

String adviceOverall(String emotion, Map<String, dynamic> dassResult) {
  final emotionLower = emotion.toLowerCase();

  final depression = dassResult['depression'] as Map<String, dynamic>? ?? {};
  final stress = dassResult['stress'] as Map<String, dynamic>? ?? {};
  final anxiety = dassResult['anxiety'] as Map<String, dynamic>? ?? {};

  final depressionLevel = depression['level'] as String? ?? 'Bình thường';
  final stressLevel = stress['level'] as String? ?? 'Bình thường';
  final anxietyLevel = anxiety['level'] as String? ?? 'Bình thường';

  if (emotionLower == 'buồn' &&
      ['Vừa', 'Nặng', 'Rất nặng'].contains(depressionLevel)) {
    return 'Có dấu hiệu trầm cảm, nên nghỉ ngơi '
        'và chia sẻ với người thân hoặc chuyên gia.';
  }

  if (emotionLower == 'vui vẻ' &&
      dassResult.values.every(
        (d) => (d as Map<String, dynamic>)['level'] == 'Bình thường',
      )) {
    return 'Tâm lý ổn định, cảm xúc tích cực. Tiếp tục duy trì nhé!';
  }

  if (emotionLower == 'tức giận' &&
      ['Nặng', 'Rất nặng'].contains(stressLevel)) {
    return 'Căng thẳng cao, cần thư giãn hoặc thay đổi môi trường làm việc.';
  }

  if (['lo lắng', 'ngạc nhiên'].contains(emotionLower) &&
      ['Nặng', 'Rất nặng'].contains(anxietyLevel)) {
    return 'Lo âu cao, nên hít thở sâu, '
        'thư giãn và chia sẻ cảm xúc với người tin cậy.';
  }

  return 'Cảm xúc của bạn hiện chưa tốt lắm, '
      'nên theo dõi thêm về cảm xúc và giấc ngủ.';
}

final Map<String, List<List<Object>>> dassLevels = {
  'stress': [
    [0, 14, 'Bình thường'],
    [15, 18, 'Nhẹ'],
    [19, 25, 'Vừa'],
    [26, 33, 'Nặng'],
    [34, 999, 'Rất nặng'],
  ],
  'anxiety': [
    [0, 7, 'Bình thường'],
    [8, 9, 'Nhẹ'],
    [10, 14, 'Vừa'],
    [15, 19, 'Nặng'],
    [20, 999, 'Rất nặng'],
  ],
  'depression': [
    [0, 9, 'Bình thường'],
    [10, 13, 'Nhẹ'],
    [14, 20, 'Vừa'],
    [21, 27, 'Nặng'],
    [28, 999, 'Rất nặng'],
  ],
};

String classifyLevel(double score, String scale) {
  final ranges = dassLevels[scale]!;
  for (final range in ranges) {
    final low = (range[0] as int).toDouble();
    final high = (range[1] as int).toDouble();
    final label = range[2] as String;
    if (score * 2 >= low && score * 2 <= high) {
      return label;
    }
  }
  return 'Bình thường';
}

String classifyDass21(Dass21Result score, String emotion) {
  final result = <String, Map<String, dynamic>>{};

  result['depression'] = {
    'score': score.depressionScore,
    'level': classifyLevel(score.depressionScore, 'depression'),
  };
  result['stress'] = {
    'score': score.stressScore,
    'level': classifyLevel(score.stressScore, 'stress'),
  };
  result['anxiety'] = {
    'score': score.anxietyScore,
    'level': classifyLevel(score.anxietyScore, 'anxiety'),
  };

  final advice = adviceOverall(emotion, result);

  return advice;
}
