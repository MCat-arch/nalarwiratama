import 'package:flutter/material.dart';
import 'package:frontend/data/material_data.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:frontend/data/story_data.dart';
import 'package:frontend/data/user_data.dart';
import 'package:frontend/data/level_data.dart';
import 'package:frontend/services/user_repository.dart';
import 'package:frontend/views/widgets/story/narrative_scene.dart';
import 'package:frontend/views/widgets/story/question_scene.dart';
import 'package:frontend/views/widgets/story/appbar_story.dart';

class StoryCard extends StatefulWidget {
  final StoryData storyData;
  final UserProfile user;
  final String materialTitle;
  final VoidCallback onCompleted;
  final VoidCallback onHomePressed;
  final LearningMaterial material;
  final int initialSceneIndex;

  const StoryCard({
    super.key,
    required this.storyData,
    required this.user,
    required this.materialTitle,
    required this.onCompleted,
    required this.onHomePressed,
    required this.material,
    this.initialSceneIndex = 0,
  });

  @override
  State<StoryCard> createState() => _StoryCardState();
}

class _StoryCardState extends State<StoryCard> {
  int _currentSceneIndex = 0;
  int _remainingLives = 5;
  String? _selectedAnswer;
  bool _showFeedback = false;
  final UserRepository _userRepo = UserRepository();
  late LevelProgress levelProgress;

  @override
  void initState() {
    super.initState();
    _currentSceneIndex = widget.initialSceneIndex;
    levelProgress =
        widget.user.levelProgress[widget.material.id] ??
        LevelProgress(levelId: widget.material.id, currentLives: 5);
    _remainingLives = levelProgress.currentLives;
    _loadProgressFromStorage();
  }

  Future<void> _saveProgressToStorage() async {
    final prefs = await SharedPreferences.getInstance();
    final String id = widget.material.id;
    final updatedMaterial = widget.material.updateProgress(
      levelProgress,
      widget.storyData.scenes,
    );

    await prefs.setDouble('${id}_progress', updatedMaterial.progress);
    await prefs.setBool('${id}_isCompleted', updatedMaterial.isCompleted);
    await prefs.setInt('${id}_lastSceneIndex', _currentSceneIndex);
    await prefs.setInt('${id}_currentLives', _remainingLives);
    if (updatedMaterial.isCompleted) {
      final score = _remainingLives * 20; // Contoh perhitungan score
      await prefs.setInt('${id}_score', score);
    }

    // Sinkronisasi dengan UserProfile
    final updatedUser = widget.user.copyWith(
      levelProgress: {
        ...widget.user.levelProgress,
        id: levelProgress.copyWith(
          currentSceneIndex: _currentSceneIndex,
          currentLives: _remainingLives,
          progress: updatedMaterial.progress,
          isCompleted:  updatedMaterial.isCompleted,
          score: updatedMaterial.isCompleted ? (_remainingLives * 20) : null
        ),
      },
    );
    await _userRepo.saveUser(updatedUser);
    print(
      'Progress saved: progress=${updatedMaterial.progress}, isCompleted=${updatedMaterial.isCompleted}, sceneIndex=$_currentSceneIndex',
    );
  }

  Future<void> _loadProgressFromStorage() async {
    final prefs = await SharedPreferences.getInstance();
    final String id = widget.material.id;

    setState(() {
      widget.material.progress = prefs.getDouble('${id}_progress') ?? 0.0;
      widget.material.isCompleted = prefs.getBool('${id}_isCompleted') ?? false;
      _currentSceneIndex = prefs.getInt('${id}_lastSceneIndex') ?? 0;
      _remainingLives = prefs.getInt('${id}_currentLives') ?? 5;
      levelProgress = levelProgress.copyWith(
        currentSceneIndex: _currentSceneIndex,
        currentLives: _remainingLives,
      );
    });
    print(
      'Progress loaded: progress=${widget.material.progress}, isCompleted=${widget.material.isCompleted}, sceneIndex=$_currentSceneIndex',
    );
  }

  void _goToNextScene() {
    if (_currentSceneIndex < widget.storyData.scenes.length - 1) {
      setState(() {
        _currentSceneIndex++;
        _selectedAnswer = null;
        _showFeedback = false;
        levelProgress = levelProgress.copyWith(
          currentSceneIndex: _currentSceneIndex,
        );
      });
      _saveProgressToStorage();
    } else {
      setState(() {
        widget.material.isCompleted = true;
        widget.material.progress = 100.0;
      });
      _saveProgressToStorage();
      widget.onCompleted();
    }
  }

  void _handleAnswer(bool isCorrect) {
    setState(() {
      _showFeedback = true;
      if (!isCorrect) {
        _remainingLives--;
        levelProgress = levelProgress.copyWith(currentLives: _remainingLives);
        // Update user lives in the database via UserRepository if needed
      }
      if (_remainingLives <= 0) {
        return;
      }
      if (_currentSceneIndex < widget.storyData.scenes.length - 1) {
        _currentSceneIndex++;
        final updatedMaterial = widget.material.updateProgress(
          levelProgress,
          widget.storyData.scenes,
        );
        widget.material.progress = updatedMaterial.progress;
        levelProgress = levelProgress.copyWith(
          currentSceneIndex: _currentSceneIndex,
        );
        _saveProgressToStorage();
      } else {
        widget.material.isCompleted = true;
        widget.material.progress = 100.0;
        _saveProgressToStorage();
        widget.onCompleted();
      }
    });
  }

  void _showHint() {
    final currentQuestion =
        widget.storyData.scenes[_currentSceneIndex].question;
    if (currentQuestion == null) return;

    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
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
        currentLives: _remainingLives,
        maxLives: 5,
      ),
      body: Stack(
        children: [
          if (currentScene.imageAsset != null)
            Positioned.fill(
              child: Image.asset(currentScene.imageAsset!, fit: BoxFit.cover),
            ),
          Positioned.fill(
            child: Container(color: Colors.black.withOpacity(0.4)),
          ),
          if (currentScene.type == SceneType.narrative)
            NarrativeScene(scene: currentScene, onNext: _goToNextScene)
          else if (currentScene.type == SceneType.question)
            QuestionScene(
              scene: currentScene,
              question: currentScene.question!,
              onAnswerSelected: (selectedAnswer) {
                _selectedAnswer = selectedAnswer;
                final isCorrect =
                    _selectedAnswer == currentScene.question!.correctAnswer;
                _handleAnswer(isCorrect);
              },
              onHintPressed: _showHint,
              remainingLives: _remainingLives,
            ),
        ],
      ),
    );
  }
}
