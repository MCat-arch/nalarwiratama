import 'package:flutter/services.dart' show rootBundle;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../data/user_data.dart';
import '../data/level_data.dart';
import '../data/material_data.dart';

class UserRepository {
  static const _userKey = 'user_list';
  static const _currentUserIdKey = 'current_user_id';

  Future<List<UserProfile>> _getUsers() async {
    final prefs = await SharedPreferences.getInstance();
    final usersString = prefs.getString(_userKey);
    print('Raw users data from SharedPreferences: $usersString');
    if (usersString != null) {
      try {
        final List<dynamic> usersList = json.decode(usersString);
        return usersList.map((userMap) {
          print('Deserializing map: $userMap');
          return UserProfile.fromMap(userMap as Map<String, dynamic>);
        }).toList();
      } catch (e) {
        print('Error decoding users: $e');
        return [];
      }
    }
    return [];
  }

  Future<void> _saveUsers(List<UserProfile> users) async {
    final prefs = await SharedPreferences.getInstance();
    final encodedUsers = json.encode(
      users.map((user) => user.toMap()).toList(),
    );
    print('Saving users: $encodedUsers');
    await prefs.setString(_userKey, encodedUsers);
    // Tunggu hingga penyimpanan selesai
    await Future.delayed(Duration(milliseconds: 200));
    await prefs.reload();
  }

  Future<UserProfile?> getUser(String userId) async {
    final users = await _getUsers();
    try {
      final user = users.firstWhere((user) => user.userId == userId);
      print('Retrieved user: ${user.toMap()}');
      return user;
    } catch (e) {
      print('Error getting user with ID $userId: $e');
      return null;
    }
  }

  Future<UserProfile?> getCurrentUser() async {
    final userId = await getCurrentUserId();
    return userId != null ? getUser(userId) : null;
  }

  Future<void> saveUserProgress({
    required String levelId,
    required int currentSceneIndex,
    required bool isCorrectAnser,
    required String questionId,
  })async{
    
  }

  Future<void> setCurrentUserId(String userId) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_currentUserIdKey, userId);
    print('Set current user ID: $userId');
  }

  Future<String?> getCurrentUserId() async {
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getString(_currentUserIdKey);
    print('Retrieved current user ID: $userId');
    return userId;
  }

  Future<void> updateLevelProgress(LevelProgress levelProgress) async {
    final currentUserId = await getCurrentUserId();
    if (currentUserId == null) {
      print('No current user ID found');
      return;
    }
    final users = await _getUsers();
    final userIndex = users.indexWhere((user) => user.userId == currentUserId);
    if (userIndex != -1) {
      final currentUser = users[userIndex];
      final updatedUser =
          currentUser
              .updateLevelProgress(levelProgress)
              .syncMaterialsProgress();
      users[userIndex] = updatedUser;
      await _saveUsers(users);
    }
  }

  Future<void> setActiveMaterial(String userId, String materialId) async {
    final user = await getUser(userId);
    if (user != null) {
      final updatedUser = user.copyWith(activeMaterialId: materialId);
      print('Setting activeMaterialId to: $materialId for user: $userId');
      await saveUser(updatedUser);
      // Verifikasi bahwa data tersimpan
      int retries = 3;
      UserProfile? savedUser;
      while (retries > 0) {
        savedUser = await getUser(userId);
        if (savedUser != null && savedUser.activeMaterialId == materialId) {
          print(
            'Verified activeMaterialId saved: ${savedUser.activeMaterialId}',
          );
          break;
        }
        print('Retrying verification... ($retries attempts left)');
        await Future.delayed(Duration(milliseconds: 300));
        retries--;
      }
      if (savedUser == null || savedUser.activeMaterialId != materialId) {
        print('Failed to verify activeMaterialId after retries');
      }
    } else {
      print('User not found for ID: $userId');
    }
  }

  Future<LearningMaterial?> getActiveMaterial(String userId) async {
    final user = await getUser(userId);
    if (user == null || user.activeMaterialId == null) {
      print('User or activeMaterialId is null for userId: $userId');
      return null;
    }

    final String jsonString = await rootBundle.loadString(
      'assets/material/materials.json',
    );
    print('Loaded materials.json: $jsonString');
    final Map<String, dynamic> jsonData = jsonDecode(jsonString);
    final List<dynamic> materialList = jsonData['materials'];
    print('Material list: $materialList');

    for (var materialData in materialList) {
      if (materialData['id'] == user.activeMaterialId) {
        print('Found material with id: ${materialData['id']}');
        final material = LearningMaterial(
          id: materialData['id'],
          title: materialData['title'],
          description: materialData['description'],
          assetPath: materialData['assetPath'],
          imageUrl: materialData['imageUrl'],
          isCompleted:
              user.levelProgress[materialData['id']]?.isCompleted ?? false,
          score: user.levelProgress[materialData['id']]?.score,
          progress: user.levelProgress[materialData['id']]?.progress ?? 0.0,
        );
        try {
          await material.loadFromJson();
          print(
            'Material loaded successfully: ${material.title}, scenes count: ${material.scenes.length}',
          );
        } catch (e) {
          print('Failed to load material from ${material.assetPath}: $e');
          return null;
        }
        return material;
      }
    }
    print('No material found for activeMaterialId: ${user.activeMaterialId}');
    return null;
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
      activeMaterialId: '1', // Set langsung saat sign-in
    );
    users.add(newUser);
    await _saveUsers(users);
    await setCurrentUserId(newUser.userId);
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
      if (user.activeMaterialId == null) {
        await setActiveMaterial(user.userId, '1');
      }
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
    final userIndex = users.indexWhere((u) => u.userId == u.userId);
    if (userIndex != -1) {
      users[userIndex] = user;
    } else {
      users.add(user);
    }
    await _saveUsers(users);
  }
}
