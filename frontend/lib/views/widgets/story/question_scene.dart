import 'package:flutter/material.dart';
import 'package:frontend/data/story_data.dart';

class QuestionScene extends StatefulWidget {
  final StoryScene scene;
  final LogicQuestion question;
  final VoidCallback onAnswerSelected;
  final VoidCallback onHintPressed;
  final int remainingLives;

  const QuestionScene({
    super.key,
    required this.scene,
    required this.question,
    required this.onAnswerSelected,
    required this.onHintPressed,
    required this.remainingLives,
  });

  @override
  State<QuestionScene> createState() => _QuestionSceneState();
}

class _QuestionSceneState extends State<QuestionScene> {
  String? _selectedAnswer;
  bool _showFeedback = false;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Background Image
        if (widget.scene.imageAsset != null)
          Positioned.fill(
            child: Image.asset(widget.scene.imageAsset!, fit: BoxFit.cover),
          ),
        Positioned.fill(child: Container(color: Colors.black.withOpacity(0.4))),

        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Spacer(),
              Container(
                padding: const EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.7),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.scene.title,
                      style: const TextStyle(
                        color: Colors.amber,
                        fontFamily: 'Quicksand',
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      widget.scene.content,
                      style: TextStyle(
                        color: Colors.white,
                        fontFamily: 'Quicksand',
                        fontSize: 16,
                      ),
                    ),
                    SizedBox(height: 20),
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.7),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.question.questionText,
                            style: TextStyle(
                              color: Colors.white12,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Quicksand',
                            ),
                          ),
                          const SizedBox(height: 12),
                          ...widget.question.options.map(
                            (option) => _buildOptionButton(option),
                          ),
                        ],
                      ),
                    ),
                    if (_showFeedback)
                      Padding(
                        padding: const EdgeInsets.only(top: 12),
                        child: Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color:
                                _selectedAnswer == widget.question.correctAnswer
                                    ? Colors.lightGreen.withOpacity(0.8)
                                    : Colors.redAccent.withOpacity(0.8),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            children: [
                              Icon(
                                _selectedAnswer == widget.question.correctAnswer
                                    ? Icons.check_circle
                                    : Icons.error,
                                color: Colors.white,
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  _selectedAnswer ==
                                          widget.question.correctAnswer
                                      ? 'Jawaban Anda benar!'
                                      : 'Jawaban salah. Yang benar: ${widget.question.correctAnswer}',
                                  style: const TextStyle(color: Colors.white),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    if (_showFeedback)
                      Padding(
                        padding: const EdgeInsets.only(top: 16),
                        child: Align(
                          alignment: Alignment.centerRight,
                          child: ElevatedButton(
                            onPressed: widget.onAnswerSelected,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.amber[700],
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 24,
                                vertical: 12,
                              ),
                            ),
                            child: const Text('Lanjutkan'),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildOptionButton(String option) {
    final bool isSelected = _selectedAnswer == option;
    final bool isCorrect = widget.question.correctAnswer == option;
    final bool showFeedback = _showFeedback;

    Color? backgroundColor;
    if (showFeedback) {
      if (isCorrect) {
        backgroundColor = Colors.green[800];
      } else if (isSelected) {
        backgroundColor = Colors.red[800];
      } else {
        backgroundColor = Colors.grey[800];
      }
    } else {
      backgroundColor = isSelected ? Colors.blue[800] : Colors.grey[800];
    }
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: ElevatedButton(
        onPressed: () {
          _showFeedback ? null : () => _selectAnswer(option);
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor,
          foregroundColor: Colors.white,
          minimumSize: const Size(double.infinity, 48),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
        child: Text(option),
      ),
    );
  }

  void _selectAnswer(String answer) {
    setState(() {
      _selectedAnswer = answer;
      _showFeedback = true;
    });
  }

}
