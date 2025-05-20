import 'package:frontend/data/level_data.dart';

class UserProfile {
  final String userId;
  final String name;
  final String email;
  final String? password;
  final String? avatarUrl;
  final int completedMaterials;
  final int totalScore;
  final int? rank;
  final DateTime joinDate;
  final List<String> achievements;
  final Map<String, LevelProgress> levelProgress;
  final List<GameLevel> levels;
  final String? activeMaterialId;

  UserProfile({
    required this.userId,
    required this.name,
    required this.email,
    this.password,
    this.avatarUrl,
    required this.completedMaterials,
    required this.totalScore,
    this.rank,
    required this.joinDate,
    this.achievements = const [],
    this.levelProgress = const {},
    this.levels = const [],
    this.activeMaterialId,
  });

  UserProfile copyWith({
    String? userId,
    String? name,
    String? email,
    String? password,
    String? avatarUrl,
    int? completedMaterials,
    int? totalScore,
    int? rank,
    DateTime? joinDate,
    List<String>? achievements,
    Map<String, LevelProgress>? levelProgress,
    List<GameLevel>? levels,
    String? activeMaterialId,
  }) {
    return UserProfile(
      userId: userId ?? this.userId,
      name: name ?? this.name,
      email: email ?? this.email,
      password: password ?? this.password,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      completedMaterials: completedMaterials ?? this.completedMaterials,
      totalScore: totalScore ?? this.totalScore,
      rank: rank ?? this.rank,
      joinDate: joinDate ?? this.joinDate,
      achievements: achievements ?? this.achievements,
      levelProgress: levelProgress ?? this.levelProgress,
      levels: levels ?? this.levels,
      activeMaterialId: activeMaterialId ?? this.activeMaterialId,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'name': name,
      'email': email,
      'password': password,
      'avatarUrl': avatarUrl,
      'completedMaterials': completedMaterials,
      'totalScore': totalScore,
      'rank': rank,
      'joinDate': joinDate.toIso8601String(),
      'achievements': achievements,
      'levelProgress': levelProgress.map(
        (key, value) => MapEntry(key, value.toMap()),
      ),
      'activeMaterialId': activeMaterialId,
    };
  }

  UserProfile updateLevelProgress(LevelProgress progress) {
    return copyWith(
      levelProgress: {...levelProgress, progress.levelId: progress},
      completedMaterials:
          levelProgress.values.where((lp) => lp.isCompleted).length,
    );
  }

  UserProfile syncMaterialsProgress() {
    final updateLevels =
        levels.map((level) {
          final progress =
              levelProgress[level.levelId] ??
              LevelProgress(
                levelId: level.levelId,
                currentLives: level.initialLives,
              );

          return level.copyWith(
            material: level.material.updateProgress(progress, level),
          );
        }).toList();
    return copyWith(levels: updateLevels);
  }

  

  LevelProgress getLevelProgress(String levelId) {
    return levelProgress[levelId] ??
        LevelProgress(levelId: levelId, currentLives: 5);
  }

  factory UserProfile.fromMap(Map<String, dynamic> map) {
    try {
      print('Deserializing map: $map'); // Debug log
      return UserProfile(
        userId: (map['userId'] as String?) ?? '',
        name: (map['name'] as String?) ?? '',
        email: (map['email'] as String?) ?? '', // Explicit casting
        password: map['password'] as String?,
        avatarUrl: map['avatarUrl'] as String?,
        completedMaterials: (map['completedMaterials'] as int?) ?? 0,
        totalScore: (map['totalScore'] as int?) ?? 0,
        rank: map['rank'] as int?,
        joinDate: DateTime.parse(map['joinDate']),
        achievements: List<String>.from(map['achievements'] ?? []),
        levelProgress:
            (map['levelProgress'] as Map<String, dynamic>?)?.map(
              (key, value) => MapEntry(key, LevelProgress.fromMap(value)),
            ) ??
            {},
        levels:
            (map['levels'] as List?)
                ?.map((levelMap) => GameLevel.fromMap(levelMap))
                .toList() ??
            [],
      );
    } catch (e) {
      print('Error in fromMap: $e'); // Log the error
      return UserProfile(
        userId: '',
        name: '',
        email: '',
        password: null,
        avatarUrl: null,
        completedMaterials: 0,
        totalScore: 0,
        rank: null,
        joinDate: DateTime.now(),
        achievements: [],
        levelProgress: {},
      );
    }
  }

  UserProfile addAchievement(String achievementId) {
    if (achievements.contains(achievementId)) {
      return this;
    }
    return copyWith(achievements: [...achievements, achievementId]);
  }
}
