import 'package:flutter/material.dart';
import 'package:frontend/data/story_data.dart';
import 'package:frontend/data/user_data.dart';
import 'package:frontend/views/widgets/story/narrative_scene.dart';
import 'package:frontend/views/widgets/story/question_scene.dart';
import 'package:frontend/views/widgets/story/appbar_story.dart';

class StoryCard extends StatefulWidget {
  final StoryData storyData;
  final UserProfile user;
  final String materialTitle;
  final VoidCallback onCompleted;
  final VoidCallback onHomePressed;

  const StoryCard({
    super.key,
    required this.storyData,
    required this.user,
    required this.materialTitle,
    required this.onCompleted,
    required this.onHomePressed,
  });

  @override
  State<StoryCard> createState() => _StoryCardState();
}

class _StoryCardState extends State<StoryCard> {
  int _currentSceneIndex = 0;
  int _remainingLives = 5;
  String? _selectedAnswer;
  bool _showFeedback = false;

  @override
  void initState() {
    super.initState();
    _remainingLives = widget.user.getLevelProgress('current').currentLives;
  }

  void _goToNextScene() {
    setState(() {
      if (_currentSceneIndex < widget.storyData.scenes.length - 1) {
        _currentSceneIndex++;
        _selectedAnswer = null;
        _showFeedback = false;
      } else {
        widget.onCompleted();
      }
    });
  }

  void _handleAnswer(bool isCorrect) {
    setState(() {
      _showFeedback = true;
      if (!isCorrect) {
        _remainingLives--;
        // Update user lives in the database
      }
    });
  }

  void _showHint() {
    final currentQuestion = widget.storyData.scenes[_currentSceneIndex].question;
    if (currentQuestion == null) return;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Petunjuk'),
        content: Text(currentQuestion.explanation),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final currentScene = widget.storyData.scenes[_currentSceneIndex];

    return Scaffold(
      
      extendBodyBehindAppBar: true,
      appBar: StoryAppBar(
        user: widget.user,
        materialTitle: widget.materialTitle,
        totalMaterials: 10,
        onHomePressed: widget.onHomePressed,
        onHintPressed: currentScene.question != null ? _showHint : null,
        currentLives: 3,
        maxLives: 5,
      ),
      body: Stack(
        children: [
          if (currentScene.imageAsset != null)
            Positioned.fill(
              child: Image.asset(
                currentScene.imageAsset!,
                fit: BoxFit.cover,
              ),
            ),
          
          Positioned.fill(
            child: Container(
              color: Colors.black.withOpacity(0.4),
            ),
          ),

          if (currentScene.type == SceneType.narrative)
            NarrativeScene(
              scene: currentScene,
              onNext: _goToNextScene,
            )
          else if (currentScene.type == SceneType.question)
            QuestionScene(
              scene: currentScene,
              question: currentScene.question!,
              onAnswerSelected: () => _handleAnswer(
                _selectedAnswer == currentScene.question!.correctAnswer
              ),
              onHintPressed: _showHint,
              remainingLives: _remainingLives,
            ),
        ],
      ),
    );
  }
}