import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static const String _baseUrl = 'https://openrouter.ai/api/v1';
  static const String _apiKey =
      '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';
  static const String _model = 'qwen/qwen3-30b-a3b:free';

  Future<String> sendMessage(String userInput) async {
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
      return data['choices'][0]['message']['content'] as String;
    } else {
      throw Exception('Gagal mendapatkan respon: ${response.statusCode}');
    }
  }
}
