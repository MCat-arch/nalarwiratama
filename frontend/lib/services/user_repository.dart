import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../data/user_data.dart';
import '../data/level_data.dart';

class UserRepository {
  static const _userKey = 'user_list';
  static const _currentUserIdKey = 'current_user_id';

  Future<List<UserProfile>> _getUsers() async {
    final prefs = await SharedPreferences.getInstance();
    final usersString = prefs.getString(_userKey);
    print('Raw users data from SharedPreferences: $usersString'); // Debug log
    if (usersString != null) {
      try {
        final List<dynamic> usersList = json.decode(usersString);
        return usersList
            .map(
              (userMap) => UserProfile.fromMap(userMap as Map<String, dynamic>),
            )
            .toList();
      } catch (e) {
        print('Error decoding users: $e');
        return [];
      }
    }
    return [];
  }

  Future<void> _saveUsers(List<UserProfile> user) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(
      _userKey,
      json.encode(user.map((user) => user.toMap()).toList()),
    );
  }

  Future<UserProfile?> getUser(String userId) async {
    final users = await _getUsers();
    try {
      return users.firstWhere((user) => user.userId == userId);
    } catch (e) {
      return null;
    }
  }

  Future<void> setCurrentUserId(String userId) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_currentUserIdKey, userId);
  }

  Future<String?> getCurrentUserId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_currentUserIdKey);
  }

  Future<void> updateLevelProgress(LevelProgress levelProgress) async {
    final users = await _getUsers();
    final userIndex = users.indexWhere(
      (user) => user.userId == levelProgress.levelId,
    );
    if (userIndex != -1) {
      final updateUser = users[userIndex].updateLevelProgress(levelProgress);
      users[userIndex] = updateUser;
      await _saveUsers(users);
    }
  }

  Future<bool> signIn(String email, String password, String name) async {
    final users = await _getUsers();
    final existingUser = users.any((user) => user.name == name);
    if (existingUser) {
      print('User already exists');
      return false;
    }

    final newUser = UserProfile(
      userId: 'user_${DateTime.now().millisecondsSinceEpoch}',
      name: name,
      email: email,
      password: password,
      avatarUrl: '',
      completedMaterials: 0,
      totalScore: 0,
      rank: 0,
      joinDate: DateTime.now(),
    );
    users.add(newUser);
    await _saveUsers(users);
    return true;
  }

  Future<bool> login(String name, String password) async {
    final users = await _getUsers();
    final user = users.firstWhere(
      (user) => user.name == name && user.password == password,
      orElse:
          () => UserProfile(
            userId: '',
            name: '',
            email: '',
            password: '',
            avatarUrl: '',
            completedMaterials: 0,
            totalScore: 0,
            rank: 0,
            joinDate: DateTime.now(),
          ),
    );
    if (user.userId.isNotEmpty) {
      await setCurrentUserId(user.userId);
      return true;
    }
    return false;
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_currentUserIdKey);
  }

  Future<void> clearUser() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_userKey);
  }

  Future<void> saveUser(UserProfile user) async {
    final users = await _getUsers();
    final userIndex = users.indexWhere((u) => u.userId == user.userId);
    if (userIndex != -1) {
      users[userIndex] = user;
    } else {
      users.add(user);
    }
    await _saveUsers(users);
  }

}
