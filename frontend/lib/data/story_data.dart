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
    this.type = SceneType.narrative,
    this.imageAsset,
    required this.nextSceneId,
    this.question,
  });

  bool get hasQuestion => question != null;

  Map<String, dynamic> toMap() {
    return {
      'sceneId': sceneId,
      'title': title,
      'content': content,
      'type': type.index,
      'imageAsset': imageAsset,
      'nextSceneId': nextSceneId,
      'question': question?.toMap(),
    };
  }

  factory StoryScene.fromMap(Map<String, dynamic> map) {
    return StoryScene(
      sceneId: map['sceneId'],
      title: map['title'],
      content: map['content'],
      type: SceneType.values[map['type']],
      imageAsset: map['imageAsset'],
      nextSceneId: map['nextSceneId'],
      question: map['question'] != null
          ? LogicQuestion.fromMap(map['question'])
          : null,
    );
  }
}

enum SceneType {
  narrative,
  interactive,
  quiz,
}

class LogicQuestion {
  final String questionText;
  final String proposition;
  final bool correctAnswer;
  final String explanation;

  LogicQuestion({
    required this.questionText,
    required this.proposition,
    required this.correctAnswer,
    required this.explanation,
  });

  Map<String, dynamic> toMap() {
    return {
      'questionText': questionText,
      'proposition': proposition,
      'correctAnswer': correctAnswer,
      'explanation': explanation,
    };
  }

  factory LogicQuestion.fromMap(Map<String, dynamic> map) {
    return LogicQuestion(
      questionText: map['questionText'],
      proposition: map['proposition'],
      correctAnswer: map['correctAnswer'],
      explanation: map['explanation'],
    );
  }
}
