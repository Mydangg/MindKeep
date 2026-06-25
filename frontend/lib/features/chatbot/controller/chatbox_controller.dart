import 'dart:convert';

import 'package:flutter/services.dart' show rootBundle;

class ChatboxController {
  Future<String> loadApiKey() async {
    final configString = await rootBundle.loadString('assets/config.json');
    final Map<String, dynamic> config = json.decode(configString);
    return config['API_KEY'];
  }
}
