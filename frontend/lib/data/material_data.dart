class LearningMaterial {
  final String id;
  final String title;
  final String description;
  final bool isCompleted;
  final int? score;
  final String? imageUrl;
  LearningMaterial({
    required this.id,
    required this.title,
    required this.description,
    this.isCompleted = false,
    this.score,
    this.imageUrl,
  });
}





