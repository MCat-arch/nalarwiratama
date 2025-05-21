import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:frontend/data/material_data.dart';
import 'package:frontend/services/user_repository.dart';
import 'package:frontend/data/user_data.dart';
import 'package:frontend/data/level_data.dart';
import 'package:frontend/views/widgets/card_kitab.dart';
import 'package:frontend/views/pages/kitab_detail.dart';
import 'package:flutter/services.dart' show rootBundle;

class Kitab extends StatefulWidget {
  const Kitab({super.key});

  @override
  State<Kitab> createState() => _KitabState();
}

class _KitabState extends State<Kitab> {
  final UserRepository _userRepo = UserRepository();
  late Future<Map<String, dynamic>> _materialsAndUserFuture;

  @override
  void initState() {
    super.initState();
    _materialsAndUserFuture = _loadMaterialsAndUser();
  }

  Future<Map<String, dynamic>> _loadMaterialsAndUser() async {
    try {
      // Muat user profile
      final userId = await _userRepo.getCurrentUserId();
      if (userId == null) throw Exception('No current user ID found');
      final user = await _userRepo.getUser(userId);
      if (user == null) throw Exception('User not found');

      // Muat daftar materi dari JSON
      final String jsonString = await rootBundle.loadString(
        '/material/materials.json',
      );
      final Map<String, dynamic> jsonData = jsonDecode(jsonString);
      final List<dynamic> materialList = jsonData['materials'];

      final materials = <LearningMaterial>[];
      for (var materialData in materialList) {
        final materialId = materialData['id'] as String;
        // Ambil data dinamis dari UserProfile
        final levelProgress =
            user.levelProgress[materialId] ??
            LevelProgress(levelId: materialId, currentLives: 5);

        final material = LearningMaterial(
          id: materialId,
          title: materialData['title'],
          description: materialData['description'],
          assetPath: materialData['assetPath'],
          imageUrl: materialData['imageUrl'],
          isCompleted: levelProgress.isCompleted,
          score: levelProgress.score,
          progress: levelProgress.progress,
        );
        await material.loadFromJson(); // Muat content dari file JSON per level
        materials.add(material);
      }

      return {'materials': materials, 'user': user};
    } catch (e) {
      print('Error loading materials and user: $e');
      return {'materials': [], 'user': null};
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Learning Materials'),
        titleTextStyle: const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: Color.fromARGB(255, 38, 38, 38),
        ),
        centerTitle: true,
        backgroundColor: const Color(0xFFD3B99A),
        elevation: 2,
      ),
      body: FutureBuilder<Map<String, dynamic>>(
        future: _materialsAndUserFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError ||
              snapshot.data == null ||
              snapshot.data!['materials'].isEmpty) {
            return const Center(child: Text('Gagal memuat materi'));
          }

          final materials =
              snapshot.data!['materials'] as List<LearningMaterial>;
          final user = snapshot.data!['user'] as UserProfile?;

          return SafeArea(
            bottom: true,
            child: ListView.builder(
              itemCount: materials.length,
              itemBuilder: (context, index) {
                final material = materials[index];
                return CardKitab(
                  material: material,
                  onTap: () async {
                    if (material.content == null) {
                      await material.loadFromJson();
                    }
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => KitabDetail(material: material),
                      ),
                    );
                  },
                );
              },
            ),
          );
        },
      ),
    );
  }
}
