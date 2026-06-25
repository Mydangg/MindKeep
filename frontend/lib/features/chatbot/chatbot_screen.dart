import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:frontend/core/themes/app_colors.dart';
import 'package:frontend/features/chatbot/Chatbot_message_handler.dart';
import 'package:frontend/features/chatbot/controller/chatbox_controller.dart';
import 'package:frontend/features/chatbot/gemini_service.dart';
import 'package:frontend/routing/page_routes.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

class ChatBotScreen extends StatefulWidget {
  const ChatBotScreen({super.key});

  @override
  State<ChatBotScreen> createState() => _ChatBotScreenState();
}

class _ChatBotScreenState extends State<ChatBotScreen> {
  final TextEditingController _controller = TextEditingController();
  final List<Map<String, String>> _messages = [];
  bool _isLoading = false;
  late GeminiService _gemini;
  late ChatBotMessageHandler messageHandler;

  bool _isGeminiReady = false;
  String? _initError;

  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _initGemini(); // Gọi hàm async riêng
  }

  Future<void> _initGemini() async {
    try {
      final apiKey = await ChatboxController().loadApiKey();

      if (apiKey.trim().isEmpty) {
        throw Exception('API_KEY rỗng hoặc chưa cấu hình.');
      }

      _gemini = GeminiService(apiKey);
      messageHandler = ChatBotMessageHandler(
        controller: _controller,
        geminiService: _gemini,
      );

      setState(() {
        _isGeminiReady = true;
        _initError = null;
      });
    } catch (e) {
      setState(() {
        _isGeminiReady = false;
        _initError = e.toString();
      });

      print('Init Gemini error: $e');
    }
  }

  Future<void> _sendMessage() async {
    if (!_isGeminiReady) {
      setState(() {
        _messages.add({
          'role': 'bot',
          'text': '⚠️ Chatbot chưa sẵn sàng. Vui lòng kiểm tra API_KEY trong assets/config.json.',
        });
      });
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final newMessages = await messageHandler.sendMessage();

      setState(() {
        if (newMessages.isNotEmpty) {
          _messages.addAll(newMessages);
        }
        _isLoading = false;
      });

      WidgetsBinding.instance.addPostFrameCallback((_) {
        _scrollToEnd();
      });
    } catch (e) {
      setState(() {
        _messages.add({
          'role': 'bot',
          'text': '⚠️ Lỗi gửi tin nhắn: $e',
        });
        _isLoading = false;
      });
    }
  }

  void _scrollToEnd() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          'Chatbot AI',
          style: GoogleFonts.poppins(
            textStyle: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w600,
              color: AppColors.greyscale600,
            ),
          ),
        ),
        centerTitle: true,
        toolbarHeight: 60,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          iconSize: 26,
          color: AppColors.greyscale700,
          onPressed: () => context.go(PageRoutes.homePage),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 20),
            child: IconButton(
              onPressed: () {},
              icon: SizedBox(
                height: 100,
                width: 100,
                child: Image.asset(
                  'assets/images/chat4.gif',
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
        ],
      ),
      backgroundColor: Colors.white,
      extendBodyBehindAppBar: true,
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color.fromARGB(255, 255, 255, 255),
              Color.fromARGB(255, 255, 255, 255),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Column(
          children: [
            const SizedBox(height: 100),
            Expanded(
              child: ListView.builder(
                controller: _scrollController,
                padding: const EdgeInsets.symmetric(
                  vertical: 10,
                  horizontal: 16,
                ),
                itemCount: _messages.length,
                itemBuilder: (context, index) {
                  final message = _messages[index];
                  final isUser = message['role'] == 'user';
                  return Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment:
                        isUser
                            ? MainAxisAlignment.end
                            : MainAxisAlignment.start,
                    children: [
                      if (!isUser)
                        const CircleAvatar(
                          radius: 18,
                          backgroundColor: Color.fromARGB(255, 166, 228, 222),
                          child: Icon(Icons.smart_toy, color: Colors.white),
                        ),

                      const SizedBox(width: 8),

                      Flexible(
                        child: Container(
                          margin: const EdgeInsets.symmetric(vertical: 6),
                          padding: const EdgeInsets.all(14),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors:
                                  isUser
                                      ? [
                                        Colors.teal.shade300,
                                        const Color.fromARGB(255, 86, 171, 205),
                                      ]
                                      : [Colors.grey.shade200, Colors.white],
                            ),
                            borderRadius: BorderRadius.only(
                              topLeft: const Radius.circular(20),
                              topRight: const Radius.circular(20),
                              bottomLeft:
                                  isUser
                                      ? const Radius.circular(20)
                                      : const Radius.circular(4),
                              bottomRight:
                                  isUser
                                      ? const Radius.circular(4)
                                      : const Radius.circular(20),
                            ),
                            boxShadow: [
                              BoxShadow(
                                // ignore: deprecated_member_use
                                color: Colors.black12.withOpacity(0.06),
                                blurRadius: 6,
                                offset: const Offset(2, 3),
                              ),
                            ],
                          ),
                          child:
                              isUser
                                  ? Text(
                                    message['text'] ?? '',
                                    style: GoogleFonts.poppins(
                                      fontSize: 16,
                                      height: 1.5,
                                      color: Colors.white,
                                    ),
                                  )
                                  : buildAiMessage(
                                    (message['text'] ?? '').replaceAll('*', ''),
                                  ),
                        ),
                      ),

                      const SizedBox(width: 8),

                      if (isUser)
                        const CircleAvatar(
                          radius: 18,
                          backgroundColor: Color.fromARGB(255, 86, 171, 205),
                          child: Icon(Icons.person, color: Colors.white),
                        ),
                    ],
                  );
                },
              ),
            ),
            if (_isLoading)
              const Padding(
                padding: EdgeInsets.all(8),
                child: CircularProgressIndicator(),
              ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.white, Colors.white],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.greyscale25,
                    blurRadius: 20,
                    offset: Offset(0, -18),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _controller,
                      onSubmitted: (_) => _sendMessage(),
                      style: const TextStyle(fontSize: 16),
                      decoration: InputDecoration(
                        hintText: '💬 Enter Message...',
                        filled: true,
                        fillColor: Colors.white,
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 18,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(32),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    decoration: const BoxDecoration(shape: BoxShape.circle),
                    child: CircleAvatar(
                      radius: 28,
                      backgroundColor: const Color.fromARGB(255, 86, 171, 205),
                      child: IconButton(
                        icon: const Icon(Icons.send, color: Colors.white),
                        onPressed: _isGeminiReady && !_isLoading ? _sendMessage : null,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Map<String, String> getAiTopic(String message) {
    final text = message.toLowerCase();

    if (text.contains('tâm lý') ||
        text.contains('trầm cảm') ||
        text.contains('stress') ||
        text.contains('lo âu')) {
      return {'icon': '🧠', 'title': 'Tâm lý'};
    }

    if (text.contains('sức khỏe') ||
        text.contains('triệu chứng') ||
        text.contains('đau') ||
        text.contains('bệnh')) {
      return {'icon': '❤️‍🩹', 'title': 'Sức khỏe'};
    }

    if (text.contains('lập trình') ||
        text.contains('flutter') ||
        text.contains('code')) {
      return {'icon': '💻', 'title': 'Lập trình'};
    }

    if (text.contains('học tập') ||
        text.contains('bài tập') ||
        text.contains('kiến thức')) {
      return {'icon': '📚', 'title': 'Học tập'};
    }

    return {'icon': '🤖', 'title': 'Trả lời'};
  }

  Widget buildAiMessage(String text) {
    final topic = getAiTopic(text);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "${topic['icon']}  ${topic['title']}",
          style: GoogleFonts.poppins(
            fontSize: 15,
            fontWeight: FontWeight.w700,
            color: const Color.fromARGB(255, 86, 171, 205),
          ),
        ),
        const SizedBox(height: 6),
        Text(
          text,
          style: GoogleFonts.poppins(
            fontSize: 16,
            height: 1.5,
            color: Colors.black87,
          ),
        ),
      ],
    );
  }
}
