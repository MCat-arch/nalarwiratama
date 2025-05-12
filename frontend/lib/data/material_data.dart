import 'package:frontend/data/level_data.dart';

class LearningMaterial {
  final String id;
  final String title;
  final String description;
  final bool isCompleted;
  final int? score;
  final String? imageUrl;
  double progress;
  LearningMaterial({
    required this.id,
    required this.title,
    required this.description,
    this.isCompleted = false,
    this.score,
    this.imageUrl,
    this.progress = 0.0,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'isCompleted': isCompleted,
      'score': score,
      'imageUrl': imageUrl,
      'progress': progress,
    };
  }

  factory LearningMaterial.fromMap(Map<String, dynamic> map) {
    return LearningMaterial(
      id: map['id'] ?? '',
      title: map['title'] ?? '',
      description: map['description'] ?? '',
      isCompleted: map['isCompleted'] ?? false,
      score: map['score'],
      imageUrl: map['imageUrl'],
      progress: (map['progress'] as num?)?.toDouble() ?? 0.0,
    );
  }

  LearningMaterial updateProgress(
    LevelProgress levelProgress,
    GameLevel level,
  ) {
    if (level.material.id == id && level.scenes.isNotEmpty) {
      final totalScenes = level.scenes.length;
      final currentScene = levelProgress.currentSceneIndex;
      final newProgress = (currentScene / totalScenes) * 100;
      return LearningMaterial(
        id: id,
        title: title,
        description: description,
        isCompleted: isCompleted,
        score: score,
        imageUrl: imageUrl,
        progress: newProgress.clamp(0.0, 100.0),
      );
    }
    return this;
  }
}
