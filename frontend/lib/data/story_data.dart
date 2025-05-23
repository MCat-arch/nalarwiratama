// class StoryScene {
//   final String sceneId;
//   final String title;
//   final String content;
//   final SceneType type;
//   final String? imageAsset;
//   final String nextSceneId;
//   final LogicQuestion? question;

//   StoryScene({
//     required this.sceneId,
//     required this.title,
//     required this.content,
//     this.type = SceneType.narrative,
//     this.imageAsset,
//     required this.nextSceneId,
//     this.question,
//   });

//   bool get hasQuestion => question != null;

//   Map<String, dynamic> toMap() {
//     return {
//       'sceneId': sceneId,
//       'title': title,
//       'content': content,
//       'type': type.index,
//       'imageAsset': imageAsset,
//       'nextSceneId': nextSceneId,
//       'question': question?.toMap(),
//     };
//   }

//   factory StoryScene.fromMap(Map<String, dynamic> map) {
//     return StoryScene(
//       sceneId: map['sceneId'],
//       title: map['title'],
//       content: map['content'],
//       type: SceneType.values[map['type']],
//       imageAsset: map['imageAsset'],
//       nextSceneId: map['nextSceneId'],
//       question: map['question'] != null
//           ? LogicQuestion.fromMap(map['question'])
//           : null,
//     );
//   }
// }

// enum SceneType {
//   narrative,
//   interactive,
//   quiz,
// }

// class LogicQuestion {
//   final String questionText;
//   final String proposition;
//   final bool correctAnswer;
//   final String explanation;

//   LogicQuestion({
//     required this.questionText,
//     required this.proposition,
//     required this.correctAnswer,
//     required this.explanation,
//   });

//   Map<String, dynamic> toMap() {
//     return {
//       'questionText': questionText,
//       'proposition': proposition,
//       'correctAnswer': correctAnswer,
//       'explanation': explanation,
//     };
//   }

//   factory LogicQuestion.fromMap(Map<String, dynamic> map) {
//     return LogicQuestion(
//       questionText: map['questionText'],
//       proposition: map['proposition'],
//       correctAnswer: map['correctAnswer'],
//       explanation: map['explanation'],
//     );
//   }
// }

// lib/data/story_model.dart
import 'package:frontend/data/level_data.dart';
import 'package:frontend/data/material_data.dart';

class StoryData {
  final String content;
  final bool? isCompleted;
  final double? score;
  final double? progress;
  final LearningMaterial? material;
  final dynamic level;
  final List<StoryScene> scenes;

  StoryData({
    required this.content,
    required this.isCompleted,
    this.score,
    this.material,
    this.level,
    this.progress,
    required this.scenes,
  });

  // Convert object to Map
  Map<String, dynamic> toMap() {
    return {
      'content': content,
      'isCompleted': isCompleted,
      'score': score,
      'progress': progress,
      'scenes': scenes.map((scene) => scene.toMap()).toList(),
    };
  }

  // Create object from Map
  factory StoryData.fromMap(Map<String, dynamic> map) {
    print('Parsing StoryData from map: $map'); // Debugging
    return StoryData(
      content: map['content'] as String? ?? '',
      isCompleted: map['isCompleted'] as bool? ?? false,
      score:
          (map['score'] is String && map['score'].isEmpty)
              ? null
              : (map['score'] as double?),
      progress:
          (map['progress'] is String && map['progress'].isEmpty)
              ? 0.0
              : (map['progress'] as num?)?.toDouble(),
      material:
          map['material'] != null
              ? LearningMaterial.fromMap(
                map['material'] as Map<String, dynamic>,
              )
              : null,
      level: map['level'],
      scenes:
          (map['scenes'] as List<dynamic>?)
              ?.map(
                (scene) => StoryScene.fromMap(scene as Map<String, dynamic>),
              )
              .toList() ??
          [],
    );
  }

  // Alias for fromMap to match JSON convention
  factory StoryData.fromJson(Map<String, dynamic> json) =>
      StoryData.fromMap(json);
}

class StoryScene {
  final String sceneId;
  final String title;
  final String content;
  final SceneType type;
  final String? imageAsset;
  final String nextSceneId;
  final LogicQuestion? question;

  StoryScene({
    required this.sceneId,
    required this.title,
    required this.content,
    required this.type,
    this.imageAsset,
    required this.nextSceneId,
    this.question,
  });

  // Convert object to Map
  Map<String, dynamic> toMap() {
    return {
      'sceneId': sceneId,
      'title': title,
      'content': content,
      'type': _typeToString(type),
      'imageAsset': imageAsset,
      'nextSceneId': nextSceneId,
      'question': question?.toMap(),
    };
  }

  // Create object from Map
  factory StoryScene.fromMap(Map<String, dynamic> map) {
    return StoryScene(
      sceneId: map['sceneId'] as String? ?? '',
      title: map['title'] as String? ?? 'Judul tidak tersedia',
      content: map['content'] as String? ?? 'Konten tidak tersedia',
      type: _parseSceneType(map['type'] as String? ?? 'narrative'),
      imageAsset: map['imageAsset'] as String?,
      nextSceneId: map['nextSceneId'] as String? ?? '',
      question:
          map['question'] != null
              ? LogicQuestion.fromMap(map['question'] as Map<String, dynamic>)
              : null,
    );
  }

  // Helper to convert enum to string
  static String _typeToString(SceneType type) {
    return type.toString().split('.').last;
  }

  // Helper to parse string to enum
  static SceneType _parseSceneType(String type) {
    switch (type) {
      case 'question':
        return SceneType.question;
      default:
        return SceneType.narrative;
    }
  }

  // Alias for fromMap to match JSON convention
  factory StoryScene.fromJson(Map<String, dynamic> json) =>
      StoryScene.fromMap(json);
}

class LogicQuestion {
  final String questionText;
  final List<String> options;
  final String correctAnswer;
  final String explanation;

  LogicQuestion({
    required this.questionText,
    required this.options,
    required this.correctAnswer,
    required this.explanation,
  });

  // Convert object to Map
  Map<String, dynamic> toMap() {
    return {
      'questionText': questionText,
      'options': options,
      'correctAnswer': correctAnswer,
      'explanation': explanation,
    };
  }

  // Create object from Map
  factory LogicQuestion.fromMap(Map<String, dynamic> map) {
    return LogicQuestion(
      questionText: map['questionText'],
      options: List<String>.from(map['options']),
      correctAnswer: map['correctAnswer'],
      explanation: map['explanation'],
    );
  }

  // Alias for fromMap to match JSON convention
  factory LogicQuestion.fromJson(Map<String, dynamic> json) =>
      LogicQuestion.fromMap(json);
}

enum SceneType { narrative, question }
