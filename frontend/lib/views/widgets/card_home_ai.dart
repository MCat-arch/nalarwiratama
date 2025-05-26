import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:frontend/provider/chat_provider.dart';
import 'package:provider/provider.dart';
import 'chat_dialog.dart';
// import 'api_service.dart';

class CardHomeAi extends StatefulWidget {
  const CardHomeAi({super.key});

  @override
  State<CardHomeAi> createState() => _CardHomeAiState();
}

class _CardHomeAiState extends State<CardHomeAi> {
  final TextEditingController _textController = TextEditingController();
  final List<Map<String, dynamic>> _messages = [];
  // final ApiService _apiService = ApiService();
  bool _isloading = false;

  void _sendMessage(String userInput) async {
    // final userInput = _textController.text.trim();
    if (userInput.trim().isNotEmpty) {
      final chatProvider = Provider.of<ChatProvider>(context, listen: false);
      setState(() {
        _isloading = true;
        // _messages.add({
        //   'text': userInput.trim(),
        //   'isUser': true,
        //   'time': DateTime.now(),
        // });
      });

      try {
        await chatProvider.sendMessage(userInput);
        // final aiResponse = await _apiService.sendMessage(userInput.trim());
        // setState(() {
        //   _messages.add({
        //     'text': aiResponse,
        //     'isUser': false,
        //     'time': DateTime.now(),
        //   });
        //   _isloading = false;
        // });
      } catch (e) {
        setState(() {
          _isloading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: $e'),
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            backgroundColor: Colors.redAccent,
          ),
        );
      }
      // Simulate sending the message to the AI assistant
      //   print('User: $userInput');
      //   _textController.clear();
      //   FocusScope.of(context).unfocus();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Masukkan pertanyaan Anda'),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
      );
    }
  }

  void _showChatDialog() {
    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
      barrierColor: Colors.black54,
      transitionDuration: const Duration(milliseconds: 200),
      pageBuilder:
          (context, anim1, anim2) => ChatDialog(
           
            onSendMessage: _sendMessage,
          ),
      transitionBuilder:
          (context, anim1, anim2, child) => FadeTransition(
            opacity: anim1,
            child: ScaleTransition(
              scale: Tween<double>(begin: 0.8, end: 1.0).animate(anim1),
              child: child,
            ),
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ChatProvider>(
      builder: (context, chatProvider, child) {
        return Container(
          // Hapus properti color
          decoration: BoxDecoration(
            color: Colors.white60, // Pindahkan warna ke dalam BoxDecoration
            borderRadius: BorderRadius.circular(12), // Tambahkan border radius
            // boxShadow: [
            //   BoxShadow(
            //     color: Colors.black26, // Warna bayangan
            //     blurRadius: 4, // Tingkat blur bayangan
            //     offset: Offset(0, 2), // Posisi bayangan
            //   ),
            // ],
          ),
          margin: const EdgeInsets.only(bottom: 16),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header dengan avatar dan judul
                Row(
                  children: [
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: const Color(0xFF8B5F3D).withOpacity(0.1),
                      ),
                      child: const Icon(
                        Icons.auto_awesome,
                        color: Color(0xFF8B5F3D),
                        size: 20,
                      ),
                    ),
                    const SizedBox(width: 12),
                    const Text(
                      'Asisten AI',
                      style: TextStyle(
                        fontFamily: 'Quicksand',
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 12),

                // Deskripsi
                Text(
                  'Butuh bantuan? Saya bisa menjelaskan konsep logika dalam buku, memberikan contoh, dan membantu Anda dengan latihan.',
                  style: TextStyle(
                    fontFamily: 'Quicksand',
                    fontSize: 14,
                    color: Colors.grey[600],
                    height: 1.4,
                  ),
                ),

                const SizedBox(height: 16),

                // Input area
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _textController,
                          style: const TextStyle(
                            fontFamily: 'Quicksand',
                            fontSize: 14,
                          ),
                          decoration: InputDecoration(
                            hintText: 'Tanyakan sesuatu...',
                            hintStyle: TextStyle(
                              fontFamily: 'Quicksand',
                              color: Colors.grey[400],
                            ),
                            border: InputBorder.none,
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 14,
                            ),
                          ),
                          textInputAction: TextInputAction.send,
                          onSubmitted: (value) {
                            _sendMessage(value);
                            _showChatDialog();
                          },
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: IconButton(
                          onPressed: () {
                            _sendMessage(_textController.text);
                            _showChatDialog();
                          },
                          icon: Container(
                            width: 36,
                            height: 36,
                            decoration: BoxDecoration(
                              color: const Color(0xFF8B5F3D),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.send,
                              color: Colors.white,
                              size: 18,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }
}
