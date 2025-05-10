import 'package:frontend/data/level_data.dart';
class UserProfile {
  final String userId;
  final String name;
  final String email;
  final String avatarUrl;
  final int completedMaterials;
  final int totalScore;
  final int rank;
  final DateTime joinDate;
  final List<String> achievements;
  final Map<String, LevelProgress>
  levelProgress; // Map of levelId to LevelProgress

  UserProfile({
    required this.userId,
    required this.name,
    required this.email,
    required this.avatarUrl,
    required this.completedMaterials,
    required this.totalScore,
    required this.rank,
    required this.joinDate,
    this.achievements = const [],
    this.levelProgress = const {},
  });

  UserProfile copyWith({
    String? userId,
    String? name,
    String? email,
    String? avatarUrl,
    int? completedMaterials,
    int? totalScore,
    int? rank,
    DateTime? joinDate,
    List<String>? achievements,
    Map<String, LevelProgress>? levelProgress,
  }) {
    return UserProfile(
      userId: userId ?? this.userId,
      name: name ?? this.name,
      email: email ?? this.email,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      completedMaterials: completedMaterials ?? this.completedMaterials,
      totalScore: totalScore ?? this.totalScore,
      rank: rank ?? this.rank,
      joinDate: joinDate ?? this.joinDate,
      achievements: achievements ?? this.achievements,
      levelProgress: levelProgress ?? this.levelProgress,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'name': name,
      'email': email,
      'avatarUrl': avatarUrl,
      'completedMaterials': completedMaterials,
      'totalScore': totalScore,
      'rank': rank,
      'joinDate': joinDate.toIso8601String(),
      'achievements': achievements,
      'levelProgress': levelProgress.map(
        (key, value) => MapEntry(key, value.toMap()),
      ),
    };
  }

  UserProfile updateLevelProgress(LevelProgress progress) {
  return copyWith(
    levelProgress: {
      ...levelProgress, // Spread the existing map
      progress.levelId: progress, // Add or update the entry
    },
  );
}

  LevelProgress getLevelProgress(String levelId){
    return levelProgress[levelId] ??
        LevelProgress(levelId:levelId, currentLives:5);
  }

  factory UserProfile.fromMap(Map<String, dynamic> map) {
    return UserProfile(
      userId: map['userId'],
      name: map['name'],
      email: map['email'],
      avatarUrl: map['avatarUrl'],
      completedMaterials: map['completedMaterials'] ?? 0,
      totalScore: map['totalScore'] ?? 0,
      rank: map['rank'] ?? 0,
      joinDate: DateTime.parse(map['joinDate']),
      achievements: List<String>.from(map['achievements'] ?? []),
      levelProgress: (map['levelProgress'] as Map<String, dynamic>).map(
        (key, value) => MapEntry(key, LevelProgress.fromMap(value)),
      ),
    );
  }

  UserProfile addAchievement(String achievementId) {
    if (achievements.contains(achievementId)) {
      return this; // Achievement already exists, return the same instance
    }
    return copyWith(achievements: [...achievements, achievementId]);
  }
}
