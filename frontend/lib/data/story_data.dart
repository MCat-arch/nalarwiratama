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
}
