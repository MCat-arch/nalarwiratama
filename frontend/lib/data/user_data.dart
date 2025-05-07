class UserProfile {
  final String name;
  final String email;
  final String avatarUrl;
  final int completedMaterials;
  final int totalScore;
  final int rank;
  final DateTime joinDate;

  UserProfile({
    required this.name,
    required this.email,
    required this.avatarUrl,
    required this.completedMaterials,
    required this.totalScore,
    required this.rank,
    required this.joinDate,
  });
}