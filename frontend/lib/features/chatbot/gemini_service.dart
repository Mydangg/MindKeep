import 'dart:convert';
import 'dart:async';
import 'package:http/http.dart' as http;

class GeminiService {
  GeminiService(this.apiKey);

  final String apiKey;

  Future<String> generateReply(String userInput) async {
    final models = [
      'gemini-2.5-flash',
      'gemini-2.0-flash',
      'gemini-1.5-flash',
    ];

    for (final model in models) {
      final result = await _callGeminiWithRetry(model, userInput);

      if (result != null) {
        return result;
      }
    }

    return '⚠️ Gemini đang quá tải. Bạn vui lòng thử lại sau vài phút nhé.';
  }

  Future<String?> _callGeminiWithRetry(String model, String userInput) async {
    final url = Uri.parse(
      'https://generativelanguage.googleapis.com/v1beta/models/$model:generateContent',
    );

    for (int attempt = 1; attempt <= 3; attempt++) {
      try {
        final response = await http.post(
          url,
          headers: {
            'Content-Type': 'application/json',
            'x-goog-api-key': apiKey,
          },
          body: jsonEncode({
            'contents': [
              {
                'parts': [
                  {'text': userInput},
                ],
              },
            ],
          }),
        );

        print('Model: $model');
        print('Attempt: $attempt');
        print('Gemini status: ${response.statusCode}');
        print('Gemini body: ${response.body}');

        if (response.statusCode == 200) {
          final data = jsonDecode(response.body);
          final reply =
              data['candidates']?[0]['content']?['parts']?[0]['text'];

          return reply ?? 'Không có phản hồi từ Gemini.';
        }

        if (response.statusCode == 503 || response.statusCode == 429) {
          await Future.delayed(Duration(seconds: attempt * 2));
          continue;
        }

        if (response.statusCode == 403) {
          return '⚠️ API key không hợp lệ, bị giới hạn sai hoặc chưa bật Generative Language API.';
        }

        if (response.statusCode == 400) {
          return '⚠️ Request gửi lên Gemini chưa hợp lệ hoặc model không hỗ trợ.';
        }

        return '⚠️ Lỗi API ${response.statusCode}. Vui lòng thử lại sau.';
      } catch (e) {
        print('Gemini exception: $e');

        await Future.delayed(Duration(seconds: attempt * 2));
      }
    }

    return null;
  }
}