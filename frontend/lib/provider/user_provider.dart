import 'package:flutter/material.dart';
import 'package:frontend/data/user_data.dart';
import 'package:frontend/services/user_repository.dart';
import 'package:frontend/data/level_data.dart';

class UserProvider with ChangeNotifier {
  UserProfile _user;
  final UserRepository _userRepo = UserRepository();

  UserProvider() : _user = UserProfile.initial() {
    _loadUser();
  }

  UserProfile get user => _user;

  Future<void> _loadUser() async {
    final userId = await _userRepo.getCurrentUserId();
    if (userId != null) {
      _user = await _userRepo.getUser(userId) ?? UserProfile.initial();
      notifyListeners();
    }
  }

  Future<void> updateUser(UserProfile updatedUser) async {
    _user = updatedUser;
    await _userRepo.saveUser(updatedUser);
    notifyListeners();
  }

  Future<void> updateLevelProgress(String levelId, double progress, bool isCompleted, int lastSceneIndex) async {
    final updatedProgress = Map<String, LevelProgress>.from(_user.levelProgress);
    updatedProgress[levelId] = (updatedProgress[levelId] ?? LevelProgress(levelId: levelId, currentLives: 5))
        .copyWith(
      currentSceneIndex: lastSceneIndex,
      isCompleted: isCompleted,
      progress: progress,
    );
    _user = _user.copyWith(levelProgress: updatedProgress);
    await _userRepo.saveUser(_user);
    notifyListeners();
  }
}