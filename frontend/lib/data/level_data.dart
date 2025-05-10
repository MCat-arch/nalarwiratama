import 'package:frontend/data/story_data.dart';
import 'package:frontend/data/material_data.dart';

class GameLevel {
  final String levelId;
  final int levelNumber;
  final String title;
  final String description;
  final int initialLives;
  final List<StoryScene> scenes;
  final LearningMaterial material;

  GameLevel({
    required this.levelId,
    required this.levelNumber,
    required this.title,
    required this.description,
    required this.initialLives,
    required this.scenes,
    required this.material,
  });
}

class LevelProgress {
  final String levelId;
  final int currentLives;
  final int currentSceneIndex;
  final bool isCompleted;
  final int score;
  final int attempts;
  final DateTime? completedAt;
  final Map<String, bool>
  questionAnswers; // Map of questionId to answer (true/false)

  LevelProgress({
    required this.levelId,
    required this.currentLives,
    this.currentSceneIndex = 0,
    this.isCompleted = false,
    this.score = 0,
    this.attempts = 0,
    this.completedAt,
    this.questionAnswers = const {},
  });

  Map<String, dynamic> toMap() {
    return {
      'levelId': levelId,
      'currentLives': currentLives,
      'currentSceneIndex': currentSceneIndex,
      'isCompleted': isCompleted,
      'score': score,
      'attempts': attempts,
      'completedAt': completedAt?.toIso8601String(),
      'questionAnswers': questionAnswers,
    };
  }

  factory LevelProgress.fromMap(Map<String, dynamic> map) {
    return LevelProgress(
      levelId: map['levelId'],
      currentLives: map['currentLives'] ?? 5,
      currentSceneIndex: map['currentSceneIndex'] ?? 0,
      isCompleted: map['isCompleted'] ?? false,
      score: map['score'] ?? 0,
      attempts: map['attempts'] ?? 0,
      completedAt:
          map['completedAt'] != null
              ? DateTime.parse(map['completedAt'])
              : null,
      questionAnswers: Map<String, bool>.from(map['questionAnswers'] ?? {}),
    );
  }

  LevelProgress copyWith({
    int? currentLives,
    int? currentSceneIndex,
    bool? isCompleted,
    int? score,
    int? attempts,
    DateTime? completedAt,
    Map<String, bool>? questionAnswers,
  }) {
    return LevelProgress(
      levelId: levelId,
      currentLives: currentLives ?? this.currentLives,
      currentSceneIndex: currentSceneIndex ?? this.currentSceneIndex,
      isCompleted: isCompleted ?? this.isCompleted,
      score: score ?? this.score,
      attempts: attempts ?? this.attempts,
      completedAt: completedAt ?? this.completedAt,
      questionAnswers: questionAnswers ?? this.questionAnswers,
    );
  }

  LevelProgress addAnswer(String questionId, bool isCorrect) {
    return copyWith(
      questionAnswers: {...questionAnswers, questionId: isCorrect},
      currentLives: isCorrect ? currentLives : currentLives - 1,
      score: isCorrect ? score + 1 : score,
    );
  }

  LevelProgress complete() {
    return copyWith(
      isCompleted: true,
      completedAt: DateTime.now(),
      attempts: attempts + 1,
    );
  }

  LevelProgress reset() {
    return LevelProgress(
      levelId: levelId,
      currentLives: currentLives,
      attempts: attempts + 1,
    );
  }
}
