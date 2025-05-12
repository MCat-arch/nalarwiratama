import 'package:flutter/material.dart';
import 'package:frontend/data/story_data.dart';
import 'package:frontend/views/widgets/story/answer_feedback.dart';
import 'package:frontend/views/widgets/story/story_content.dart';
import 'package:frontend/views/widgets/story/logic_question.dart' as logic;

class StoryPage extends StatefulWidget {
  const StoryPage({super.key});

  @override
  State<StoryPage> createState() => _StoryPageState();
}

class _StoryPageState extends State<StoryPage> {
  final List<StoryScene> scenes = [
    StoryScene(
      sceneId: 'scene1',
      title: 'Latar Belakang Peperangan',
      content:
          'Tindakan sewenang-wenang pihak Belanda telah menyulut emosi Pangeran Diponegoro. '
          'Dia bertekad untuk menjaga warisan leluhur dan secara terbuka menantang Pasukan Belanda.',
      question: LogicQuestion(
        questionText: 'Tentukan apakah klaim berikut bernilai benar atau salah',
        proposition:
            'Jika pasukan Belanda merusak makam leluhur atau Pangeran Diponegoro mau '
            'bekerjasama maka perang terjadi',
        correctAnswer: true,
        explanation:
            'Klaim bernilai BENAR karena perang akan terjadi jika salah satu dari dua '
            'kondisi tersebut terpenuhi (merusak makam ATAU bekerjasama).',
      ),
      imageAsset: 'assets/images/img_dip.jpg',
      nextSceneId: 'scene2',
    ),
    // Tambahkan scene-scene berikutnya di sini
  ];

  String currentSceneId = 'scene1';
  bool? userAnswer;
  bool showFeedback = false;

  StoryScene get currentScene =>
      scenes.firstWhere((s) => s.sceneId == currentSceneId);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Perang Diponegoro'), centerTitle: true),
      body: Stack(
        children: [
          // Background Image full screen
          if (currentScene.imageAsset != null)
            Positioned.fill(
              child: Image.asset(currentScene.imageAsset!, fit: BoxFit.cover),
            ),

          // Overlay + Konten
          Positioned.fill(
            child: Container(
              color: Colors.black.withOpacity(
                0.4,
              ), // optional: biar teks lebih terbaca
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      // Konten Cerita
                      StoryContent(
                        title: currentScene.title,
                        content: currentScene.content,
                      ),
                      const SizedBox(height: 20),

                      // Soal logika
                      if (currentScene.question != null) ...[
                        const Divider(thickness: 2, color: Colors.white),
                        logic.LogicQuestionWidget(
                          question: currentScene.question!,
                          onAnswerSelected: (answer) {
                            setState(() {
                              userAnswer = answer;
                              showFeedback = true;
                            });
                          },
                        ),
                      ],

                      // Feedback
                      if (showFeedback && currentScene.question != null)
                        AnswerFeedback(
                          isCorrect:
                              userAnswer ==
                              currentScene.question!.correctAnswer,
                          explanation: currentScene.question!.explanation,
                        ),

                      const SizedBox(height: 20),

                      // Tombol Lanjut
                      ElevatedButton(
                        onPressed: () {
                          setState(() {
                            currentSceneId = currentScene.nextSceneId;
                            userAnswer = null;
                            showFeedback = false;
                          });
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue[800],
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 32,
                            vertical: 16,
                          ),
                        ),
                        child: const Text('Lanjutkan Cerita'),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
