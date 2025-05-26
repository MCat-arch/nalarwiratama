import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class ChatMessage {
  final String text;
  final bool isUser;
  final DateTime time;

  ChatMessage({required this.text, required this.isUser, required this.time});
}

class ChatProvider with ChangeNotifier {
  List<ChatMessage> _message = [];
  List<ChatMessage> get messages => _message;
  static const String _baseUrl = 'https://openrouter.ai/api/v1';
  static const String _apiKey =
      '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';
  static const String _model = 'qwen/qwen3-30b-a3b:free';

  void addMessage(String text, bool isUser) {
    final message = ChatMessage(
      text: text,
      isUser: isUser,
      time: DateTime.now(),
    );
    _message.add(message);
    notifyListeners();
  }

  Future<String> sendMessage(String userInput) async {
    try {
      final response = await http.post(
        Uri.parse('$_baseUrl/chat/completions'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $_apiKey',
        },
        body: jsonEncode({
          'model': _model,
          'messages': [
            {'role': 'user', 'content': userInput},
          ],
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final aiResponse = data['choices'][0]['message']['content'] as String;
        addMessage(aiResponse, false);
        return aiResponse;
      } else {
        throw Exception('Gagal mendapatkan respon: ${response.statusCode}');
      }
    } catch (e) {
      addMessage('Error: $e', false); // Tambahkan pesan error jika gagal
      return 'Error: $e';
    }
  }
}
