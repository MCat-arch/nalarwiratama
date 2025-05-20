import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:frontend/data/material_data.dart';
import 'package:frontend/services/user_repository.dart';
import 'package:frontend/data/user_data.dart';
import 'package:frontend/views/widgets/card_home_ai.dart';
import 'package:frontend/views/widgets/card_home.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:frontend/data/level_data.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final UserRepository _userRepo = UserRepository();
  late Future<Map<String, dynamic>> _dataFuture;

  @override
  void initState() {
    super.initState();
    _dataFuture = _loadData();
  }

  Future<Map<String, dynamic>> _loadData() async {
    try {
      // Muat user profile
      final userId = await _userRepo.getCurrentUserId();
      if (userId == null) throw Exception('No current user ID found');
      final user = await _userRepo.getUser(userId);
      if (user == null) throw Exception('User not found');

      // Muat daftar materi dari JSON
      final String jsonString = await rootBundle.loadString(
        'material/materials.json',
      );
      final Map<String, dynamic> jsonData = jsonDecode(jsonString);
      final List<dynamic> materialList = jsonData['materials'];

      final materials = <LearningMaterial>[];
      for (var materialData in materialList) {
        final materialId = materialData['id'] as String;
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

      // Tentukan materi aktif berdasarkan progres pengguna
      LearningMaterial? activeMaterial;
      for (var material in materials) {
        final levelProgress = user.levelProgress[material.id];
        if (levelProgress != null &&
            !levelProgress.isCompleted &&
            levelProgress.currentSceneIndex > 0) {
          activeMaterial = material;
          break; // Prioritaskan level yang sedang aktif
        }
      }

      // Jika tidak ada level yang sedang aktif, ambil level pertama yang belum selesai
      if (activeMaterial == null) {
        for (var material in materials) {
          final levelProgress =
              user.levelProgress[material.id] ??
              LevelProgress(levelId: material.id, currentLives: 5);
          if (!levelProgress.isCompleted) {
            activeMaterial = material;
            break;
          }
        }
      }

      // Jika semua level sudah selesai, ambil materi terakhir
      activeMaterial ??= materials.last;

      return {'activeMaterial': activeMaterial, 'user': user};
    } catch (e) {
      print('Error loading data: $e');
      return {'activeMaterial': null, 'user': null};
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: FutureBuilder<Map<String, dynamic>>(
        future: _dataFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Scaffold(
              backgroundColor: Color(0xFFF5F5F5),
              body: Center(
                child: CircularProgressIndicator(color: Color(0xFF8B5F3D)),
              ),
            );
          }
          if (snapshot.hasError ||
              snapshot.data == null ||
              snapshot.data!['activeMaterial'] == null) {
            return Scaffold(
              backgroundColor: Color(0xFFF5F5F5),
              appBar: AppBar(
                title: const Text(
                  'Homepage',
                  style: TextStyle(fontFamily: 'Quicksand'),
                ),
              ),
              body: const Center(child: Text('Gagal memuat Homepage')),
            );
          }

          final activeMaterial =
              snapshot.data!['activeMaterial'] as LearningMaterial;
          final user = snapshot.data!['user'] as UserProfile;

          // Hitung completedMaterials berdasarkan levelProgress
          final completedMaterials =
              user.levelProgress.values.where((lp) => lp.isCompleted).length;
          const totalMaterials = 7;

          return Scaffold(
            backgroundColor: const Color(0xFFF5F5F5),
            appBar: AppBar(
              toolbarHeight: 70,
              backgroundColor: const Color(0xFFD3B99A),
              titleSpacing: 0,
              elevation: 0,
              leading: Padding(
                padding: const EdgeInsets.only(left: 15.0),
                child: CircleAvatar(
                  backgroundImage: const AssetImage(
                    'assets/images/img_dip.jpg',
                  ),
                  radius: 20,
                ),
              ),
              title: Padding(
                padding: const EdgeInsets.only(left: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      "Selamat Datang",
                      style: TextStyle(
                        fontFamily: 'Quicksand',
                        fontSize: 12,
                        color: Colors.black.withOpacity(0.6),
                      ),
                    ),
                    Text(
                      user.name,
                      style: const TextStyle(
                        fontFamily: 'Quicksand',
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
              ),
              actions: <Widget>[
                Container(
                  margin: const EdgeInsets.only(right: 8),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFF8B5F3D),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.check_circle,
                        color: Colors.white,
                        size: 16,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '$completedMaterials/$totalMaterials',
                        style: const TextStyle(
                          fontFamily: 'Quicksand',
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(width: 10),
                Container(
                  margin: const EdgeInsets.only(right: 16),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    children: [
                      // Tampilkan lives berdasarkan currentLives dari level aktif
                      for (int i = 0; i < 5; i++)
                        Icon(
                          Icons.favorite,
                          color:
                              (i <
                                      (user
                                              .levelProgress[activeMaterial.id]
                                              ?.currentLives
                                              .clamp(0, 5) ??
                                          5))
                                  ? Colors.yellow
                                  : Colors.grey,
                          size: 20,
                        ),
                    ],
                  ),
                ),
                const SizedBox(width: 10),
              ],
            ),
            body: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              child: Column(
                children: [
                  Card(
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: CardHome(material: activeMaterial, user: user),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Card(
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Padding(
                      padding: EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Text(
                          //   'Bantuan AI',
                          //   style: TextStyle(
                          //     fontFamily: 'Poppins',
                          //     fontSize: 14,
                          //     color: Colors.grey,
                          //     fontWeight: FontWeight.w500,
                          //   ),
                          // ),
                          SizedBox(height: 8),
                          CardHomeAi(),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
