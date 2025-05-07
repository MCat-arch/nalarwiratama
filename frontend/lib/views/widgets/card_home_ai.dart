import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CardHomeAi extends StatefulWidget {
  const CardHomeAi({super.key});

  @override
  State<CardHomeAi> createState() => _CardHomeAiState();
}

class _CardHomeAiState extends State<CardHomeAi> {
  final TextEditingController _textController = TextEditingController();

  void _sendMessage() {
    final userInput = _textController.text.trim();
    if (userInput.isNotEmpty) {
      // Simulate sending the message to the AI assistant
      print('User: $userInput');
      _textController.clear(); // Clear the text field after sending
    } else {
      // Show a message if the input is empty
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Please enter a message')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(10),
      elevation: 8,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
      color: const Color.fromARGB(255, 248, 248, 248),
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: [
            Row(
              children: [
                CircleAvatar(
                  backgroundImage: AssetImage(
                    '/images/img_dip.jpg',
                  ), // Ganti dengan path gambar Anda
                  radius: 20,
                ),
                SizedBox(width: 10),
                Text(
                  'AI Assistant',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: const Color.fromARGB(255, 16, 16, 16),
                  ),
                ),
              ],
            ),
            SizedBox(height: 10, width: double.infinity),
            Text(
              'Need help? I can explain the logical concepts in the book, provide examples, and even help you with exercises.',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w300,
                color: const Color.fromARGB(255, 16, 16, 16),
              ),
            ),
            SizedBox(height: 10, width: double.infinity),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              children: [
                Expanded(
                  child: TextField(
                    controller: _textController,
                    decoration: InputDecoration(
                      hintText: 'Ask me anything',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                        borderSide: BorderSide(color: Colors.grey),
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 10),
                IconButton(
                  onPressed: _sendMessage,
                  icon: Icon(Icons.send, color: Colors.blue),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
