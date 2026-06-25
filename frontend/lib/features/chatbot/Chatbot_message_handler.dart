import 'package:flutter/material.dart';
import 'package:frontend/features/chatbot/gemini_service.dart';

class ChatBotMessageHandler {
  ChatBotMessageHandler({
    required this.controller,
    required this.geminiService,
  });
  final TextEditingController controller;
  final GeminiService geminiService;

  bool _isSending = false;

  Future<List<Map<String, String>>> sendMessage() async {
    if (_isSending) return [];

    final input = controller.text.trim();
    if (input.isEmpty) return [];

    _isSending = true;
    controller.clear();

    final userMessage = {'role': 'user', 'text': input};

    try {
      final reply = await geminiService.generateReply(input);

      final botMessage = {'role': 'bot', 'text': reply};

      return [userMessage, botMessage];
    } on Exception {
      return [
        userMessage,
        {'role': 'bot', 'text': '⚠️ Có lỗi xảy ra. Vui lòng thử lại sau.'},
      ];
    } finally {
      _isSending = false;
    }
  }
}
