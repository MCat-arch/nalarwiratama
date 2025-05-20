import 'package:frontend/data/level_data.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:frontend/data/story_data.dart';
import 'dart:convert';

class LearningMaterial {
  final String id;
  final String title;
  final String description;
  bool isCompleted;
  final int? score;
  final String? imageUrl;
  double progress;
  final String assetPath;
  String? content;
  List<StoryScene> scenes;

  LearningMaterial({
    required this.id,
    required this.title,
    required this.description,
    this.isCompleted = false,
    this.score,
    this.imageUrl,
    this.progress = 0.0,
    required this.assetPath,
    this.content,
    this.scenes = const [],
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
      'assetPath': assetPath,
      'content': content,
      'scenes': scenes.map((s) => s.toMap()).toList(),
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
      assetPath: map['assetPath'],
      content: map['content'],
      scenes: (map['scenes'] as List<dynamic>?)
          ?.map((s) => StoryScene.fromMap(s as Map<String, dynamic>))
          .toList() ?? [],
    );
  }

  LearningMaterial updateProgress(
    LevelProgress levelProgress,
    List<StoryScene> levelScenes,
  
  ) {
    if (levelScenes.isNotEmpty) {
      final totalScenes = levelScenes.length;
      final currentScene = levelProgress.currentSceneIndex + 1;
      final newProgress = (currentScene / totalScenes) * 100;
      return LearningMaterial(
        id: id,
        title: title,
        description: description,
        isCompleted: isCompleted,
        score: score,
        imageUrl: imageUrl,
        progress: newProgress.clamp(0.0, 100.0),
        assetPath: assetPath,
        content: content,
        scenes: scenes,
      );
    }
    return this;
  }

  Future<void> loadContent() async {
    try {
      final String loadedContent = await rootBundle.loadString(assetPath);
      content = loadedContent;
    } catch (e) {
      print('Error loading content from $assetPath: $e');
      content = null;
    }
  }

  Future<void> loadFromJson() async {
    try {
      print('Loading JSON from: $assetPath'); // Debugging log
      final String jsonString = await rootBundle.loadString(assetPath);
      print('Loaded JSON string: $jsonString'); // Debugging log
      final Map<String, dynamic> jsonData = jsonDecode(jsonString);
      print('Decoded JSON data: $jsonData'); // Debugging log

      content = jsonData['content'] ?? content;
      if (jsonData['scenes'] != null) {
        scenes =
            (jsonData['scenes'] as List<dynamic>)
                .map(
                  (sceneData) =>
                      StoryScene.fromMap(sceneData as Map<String, dynamic>),
                )
                .toList();
      } else {
        scenes = []; // Pastikan scenes tidak null
      }
    } catch (e) {
      print('Error loading material from $assetPath: $e');
      content = 'Gagal memuat materi';
    }
  }
}
