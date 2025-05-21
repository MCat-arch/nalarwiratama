// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:frontend/data/material_data.dart';
// import 'package:frontend/services/user_repository.dart';
// import 'package:frontend/data/user_data.dart';
import 'package:frontend/views/widgets/card_home_ai.dart';
// import 'package:frontend/views/widgets/card_home.dart';
// import 'package:flutter/services.dart' show rootBundle;
import 'package:frontend/data/level_data.dart';
// import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'dart:convert';
import 'package:frontend/data/material_data.dart';
import 'package:frontend/data/user_data.dart';
import 'package:frontend/services/user_repository.dart';
import 'package:frontend/views/widgets/card_home.dart';
import 'package:shared_preferences/shared_preferences.dart';

// class HomeScreen extends StatefulWidget {
//   const HomeScreen({super.key});

//   @override
//   State<HomeScreen> createState() => _HomeScreenState();
// }

// class _HomeScreenState extends State<HomeScreen> {
//   late Future<Map<String, dynamic>> _dataFuture;
//   final UserRepository _userRepo = UserRepository();
//   bool _showAchievementPopup = false;
//   String? _lastCompletedMaterialId;

//   @override
//   void initState() {
//     super.initState();
//     _dataFuture = _loadData();
//   }

//   Future<Map<String, dynamic>> _loadData() async {
//     try {
//       // Muat user profile
//       final userId = await _userRepo.getCurrentUserId();
//       if (userId == null) throw Exception('No current user ID found');
//       UserProfile? user = await _userRepo.getUser(userId);
//       if (user == null) throw Exception('User not found');

//       // Muat daftar materi dari JSON
//       final String jsonString = await rootBundle.loadString(
//         'assets/material/materials.json',
//       );
//       final Map<String, dynamic> jsonData = jsonDecode(jsonString);
//       final List<dynamic> materialList = jsonData['materials'];

//       final prefs = await SharedPreferences.getInstance();
//       final materials = <LearningMaterial>[];
//       Map<String, LevelProgress> updatedLevelProgress = Map.from(
//         user.levelProgress,
//       );

//       final bool isNewUser =
//           user.levelProgress.isEmpty ||
//           user.levelProgress.values.every(
//             (lp) =>
//                 lp.currentSceneIndex == 0 &&
//                 lp.progress == 0.0 &&
//                 !lp.isCompleted,
//           );

//       for (var materialData in materialList) {
//         final materialId = materialData['id'] as String;
//         LevelProgress levelProgress =
//             user.levelProgress[materialId] ??
//             LevelProgress(levelId: materialId, currentLives: 5);

//         if (isNewUser && materialId == '1') {
//           levelProgress = levelProgress.copyWith(currentSceneIndex: 0);
//           await prefs.setInt('${materialId}_lastSceneIndex', 0);
//         }

//         // Muat data dari SharedPreferences
//         final double storedProgress =
//             prefs.getDouble('${materialId}_progress') ?? levelProgress.progress;
//         final bool storedIsCompleted =
//             prefs.getBool('${materialId}_isCompleted') ??
//             levelProgress.isCompleted;
//         final int storedCurrentLives =
//             prefs.getInt('${materialId}_currentLives') ??
//             levelProgress.currentLives;
//         final int storedSceneIndex =
//             prefs.getInt('${materialId}_lastSceneIndex') ??
//             levelProgress.currentSceneIndex;

//         // Perbarui LevelProgress dengan data dari SharedPreferences
//         updatedLevelProgress[materialId] = levelProgress.copyWith(
//           progress: storedProgress,
//           isCompleted: storedIsCompleted,
//           currentLives: storedCurrentLives,
//           currentSceneIndex: storedSceneIndex,
//         );

//         final material = LearningMaterial(
//           id: materialId,
//           title: materialData['title'],
//           description: materialData['description'],
//           assetPath: materialData['assetPath'],
//           imageUrl: materialData['imageUrl'],
//           isCompleted: storedIsCompleted,
//           score: levelProgress.score,
//           progress: storedProgress,
//         );
//         await material.loadFromJson();
//         materials.add(material);
//       }

//       // Perbarui UserProfile dengan LevelProgress yang sudah disinkronkan
//       user = user.copyWith(levelProgress: updatedLevelProgress);
//       await _userRepo.saveUser(user);

//       // Tentukan materi aktif berdasarkan progres pengguna
//       LearningMaterial? activeMaterial;
//       String? previousMaterialId;
//       int belumSelesai = -1;

//       for (int i = 0; i < materials.length; i++) {
//         final material = materials[i];
//         final levelProgress = user.levelProgress[material.id];
//         print(
//           'Checking material ${material.id}: isCompleted=${levelProgress?.isCompleted}, currentSceneIndex=${levelProgress?.currentSceneIndex}',
//         );

//         if (levelProgress != null && levelProgress.isCompleted) {
//           previousMaterialId = material.id;
//         } else if (levelProgress != null && !levelProgress.isCompleted) {
//           activeMaterial = material;
//           belumSelesai = i;
//           break;
//         }
//       }

//       if (activeMaterial == null) {
//         activeMaterial = materials[0];
//         if (isNewUser ||
//             user.levelProgress.values.every((lp) => lp.isCompleted)) {
//           updatedLevelProgress[activeMaterial.id] =
//               updatedLevelProgress[activeMaterial.id]?.copyWith(
//                 currentSceneIndex: 1,
//               ) ??
//               LevelProgress(
//                 levelId: activeMaterial.id,
//                 currentLives: 5,
//                 currentSceneIndex: 1,
//               );
//           user = user.copyWith(
//             levelProgress: updatedLevelProgress,
//             activeMaterialId: activeMaterial.id,
//           );
//           await _userRepo.saveUser(user);
//           await prefs.setInt('${activeMaterial.id}_lastSceneIndex', 1);
//         }
//       } else {
//         user = user.copyWith(
//           activeMaterialId: activeMaterial.id,
//         ); // Sinkronisasi activeMaterialId
//         await _userRepo.saveUser(user);
//       }
//       // if (isNewUser && materials.isNotEmpty) {
//       //   activeMaterial = materials[0];
//       //   print('new user');
//       // } else {
//       //   for (var material in materials) {
//       //     final levelProgress = user.levelProgress[material.id];
//       //     if (levelProgress != null && levelProgress.isCompleted) {
//       //       previousMaterialId =
//       //           material.id; // Simpan ID materi sebelumnya yang selesai
//       //     } else if (levelProgress != null && !levelProgress.isCompleted) {
//       //       activeMaterial = material;
//       //       break; // Pilih level yang belum selesai
//       //     }
//       //   }

//       //   // Jika semua level selesai, ambil materi terakhir sebagai aktif
//       //   if (activeMaterial == null && materials.isNotEmpty) {
//       //     activeMaterial = materials.last;
//       //   }

//       // Periksa apakah ada level yang baru selesai untuk trigger achievement
//       if (previousMaterialId != null &&
//           user.levelProgress[previousMaterialId]?.isCompleted == true) {
//         _lastCompletedMaterialId = previousMaterialId;
//         _showAchievementPopup = true; // Trigger pop-up
//         // Tambahkan badge achievement
//         final achievement = 'Level ${_lastCompletedMaterialId} Completed';
//         if (!user.achievements.contains(achievement)) {
//           final updatedAchievements = List<String>.from(user.achievements)
//             ..add(achievement);
//           user = user.copyWith(achievements: updatedAchievements);
//           await _userRepo.saveUser(user);
//         }
//       }

//       return {'activeMaterial': activeMaterial, 'user': user};
//     } catch (e) {
//       print('Error loading data: $e');
//       return {'activeMaterial': null, 'user': null};
//     }
//   }

//   void _showAchievementDialog() {
//     if (_showAchievementPopup && _lastCompletedMaterialId != null) {
//       showDialog(
//         context: context,
//         barrierDismissible: false,
//         builder: (BuildContext context) {
//           return AlertDialog(
//             title: const Text('Achievement Unlocked!'),
//             content: Column(
//               mainAxisSize: MainAxisSize.min,
//               children: [
//                 const Icon(Icons.star, color: Colors.yellow, size: 50),
//                 const SizedBox(height: 10),
//                 Text('You completed Level $_lastCompletedMaterialId!'),
//                 const SizedBox(height: 10),
//                 Text('Badge Earned: Level $_lastCompletedMaterialId Completed'),
//               ],
//             ),
//             actions: [
//               TextButton(
//                 child: const Text('OK'),
//                 onPressed: () {
//                   setState(() {
//                     _showAchievementPopup = false;
//                   });
//                   Navigator.of(context).pop();
//                 },
//               ),
//             ],
//           );
//         },
//       );
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       home: Builder(
//         builder: (context) {
//           _showAchievementDialog(); // Tampilkan pop-up jika ada achievement
//           return FutureBuilder<Map<String, dynamic>>(
//             future: _dataFuture,
//             builder: (context, snapshot) {
//               if (snapshot.connectionState == ConnectionState.waiting) {
//                 return const Scaffold(
//                   backgroundColor: Color(0xFFF5F5F5),
//                   body: Center(
//                     child: CircularProgressIndicator(color: Color(0xFF8B5F3D)),
//                   ),
//                 );
//               }
//               if (snapshot.hasError ||
//                   snapshot.data == null ||
//                   snapshot.data!['activeMaterial'] == null) {
//                 return Scaffold(
//                   backgroundColor: Color(0xFFF5F5F5),
//                   appBar: AppBar(
//                     title: const Text(
//                       'Homepage',
//                       style: TextStyle(fontFamily: 'Quicksand'),
//                     ),
//                   ),
//                   body: const Center(child: Text('Gagal memuat Homepage')),
//                 );
//               }

//               final activeMaterial =
//                   snapshot.data!['activeMaterial'] as LearningMaterial;
//               final user = snapshot.data!['user'] as UserProfile;

//               // Hitung completedMaterials berdasarkan levelProgress
//               final completedMaterials =
//                   user.levelProgress.values
//                       .where((lp) => lp.isCompleted)
//                       .length;
//               const totalMaterials = 7;

//               return Scaffold(
//                 backgroundColor: const Color(0xFFF5F5F5),
//                 appBar: AppBar(
//                   toolbarHeight: 70,
//                   backgroundColor: const Color(0xFFD3B99A),
//                   titleSpacing: 0,
//                   elevation: 0,
//                   leading: Padding(
//                     padding: const EdgeInsets.only(left: 15.0),
//                     child: CircleAvatar(
//                       backgroundImage: const AssetImage(
//                         'assets/images/img_dip.jpg',
//                       ),
//                       radius: 20,
//                     ),
//                   ),
//                   title: Padding(
//                     padding: const EdgeInsets.only(left: 10),
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       mainAxisSize: MainAxisSize.min,
//                       children: [
//                         Text(
//                           "Selamat Datang",
//                           style: TextStyle(
//                             fontFamily: 'Quicksand',
//                             fontSize: 12,
//                             color: Colors.black.withOpacity(0.6),
//                           ),
//                         ),
//                         Text(
//                           user.name,
//                           style: const TextStyle(
//                             fontFamily: 'Quicksand',
//                             fontWeight: FontWeight.w600,
//                             fontSize: 16,
//                             color: Colors.black,
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                   actions: <Widget>[
//                     Container(
//                       margin: const EdgeInsets.only(right: 8),
//                       padding: const EdgeInsets.symmetric(
//                         horizontal: 12,
//                         vertical: 6,
//                       ),
//                       decoration: BoxDecoration(
//                         color: const Color(0xFF8B5F3D),
//                         borderRadius: BorderRadius.circular(20),
//                       ),
//                       child: Row(
//                         children: [
//                           const Icon(
//                             Icons.check_circle,
//                             color: Colors.white,
//                             size: 16,
//                           ),
//                           const SizedBox(width: 4),
//                           Text(
//                             '$completedMaterials/$totalMaterials',
//                             style: const TextStyle(
//                               fontFamily: 'Quicksand',
//                               color: Colors.white,
//                               fontSize: 12,
//                               fontWeight: FontWeight.w500,
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                     const SizedBox(width: 10),
//                     Container(
//                       margin: const EdgeInsets.only(right: 16),
//                       padding: const EdgeInsets.symmetric(
//                         horizontal: 8,
//                         vertical: 6,
//                       ),
//                       decoration: BoxDecoration(
//                         color: Colors.white.withOpacity(0.3),
//                         borderRadius: BorderRadius.circular(20),
//                       ),
//                       child: Row(
//                         children: [
//                           for (int i = 0; i < 5; i++)
//                             Icon(
//                               Icons.favorite,
//                               color:
//                                   (i <
//                                           (user
//                                                   .levelProgress[activeMaterial
//                                                       .id]
//                                                   ?.currentLives
//                                                   .clamp(0, 5) ??
//                                               5))
//                                       ? Colors.yellow
//                                       : Colors.grey,
//                               size: 20,
//                             ),
//                         ],
//                       ),
//                     ),
//                     // Tambahkan badge achievement
//                     if (user.achievements.isNotEmpty)
//                       Padding(
//                         padding: const EdgeInsets.only(right: 10),
//                         child: Container(
//                           padding: const EdgeInsets.all(4),
//                           decoration: BoxDecoration(
//                             color: Colors.purple[100],
//                             borderRadius: BorderRadius.circular(12),
//                           ),
//                           child: Row(
//                             children: [
//                               const Icon(
//                                 Icons.badge,
//                                 color: Colors.purple,
//                                 size: 16,
//                               ),
//                               const SizedBox(width: 4),
//                               Text(
//                                 '${user.achievements.length} Badges',
//                                 style: const TextStyle(
//                                   color: Colors.purple,
//                                   fontSize: 12,
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ),
//                       ),
//                     const SizedBox(width: 10),
//                   ],
//                 ),
//                 body: SingleChildScrollView(
//                   padding: const EdgeInsets.symmetric(
//                     horizontal: 16,
//                     vertical: 16,
//                   ),
//                   child: Column(
//                     children: [
//                       Card(
//                         elevation: 2,
//                         shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(12),
//                         ),
//                         child: Padding(
//                           padding: const EdgeInsets.all(16),
//                           child: CardHome(
//                             material: activeMaterial,
//                             user: user,
//                             path: activeMaterial.assetPath,
//                           ),
//                         ),
//                       ),
//                       const SizedBox(height: 20),
//                       Card(
//                         elevation: 2,
//                         shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(12),
//                         ),
//                         child: const Padding(
//                           padding: EdgeInsets.all(16),
//                           child: Column(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: [
//                               // Text(
//                               //   'Bantuan AI',
//                               //   style: TextStyle(
//                               //     fontFamily: 'Poppins',
//                               //     fontSize: 14,
//                               //     color: Colors.grey,
//                               //     fontWeight: FontWeight.w500,
//                               //   ),
//                               // ),
//                               SizedBox(height: 8),
//                               CardHomeAi(),
//                             ],
//                           ),
//                         ),
//                       ),
//                       // Tambahkan daftar CardKitab untuk semua level jika diperlukan
//                     ],
//                   ),
//                 ),
//               );
//             },
//           );
//         },
//       ),
//     );
//   }
// }

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final UserRepository _userRepo = UserRepository();
  late Future<Map<String, dynamic>> _dataFuture;
  bool showAchievmentPopup = false;
  String? _lastCompletedMaterial;

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
      UserProfile? user = await _userRepo.getUser(userId);
      if (user == null) throw Exception('User not found');

      // Muat daftar materi dari JSON
      final String jsonString = await rootBundle.loadString(
        'material/materials.json',
      );
      final Map<String, dynamic> jsonData = jsonDecode(jsonString);
      final List<dynamic> materialList = jsonData['materials'];

      final prefs = await SharedPreferences.getInstance();
      final materials = <LearningMaterial>[];
      Map<String, LevelProgress> updateLevelProgress = Map.from(
        user.levelProgress,
      );
      for (var materialData in materialList) {
        final materialId = materialData['id'] as String;
        final levelProgress =
            user.levelProgress[materialId] ??
            LevelProgress(levelId: materialId, currentLives: 5);

        final double storedProgress =
            prefs.getDouble('${materialId}_progress') ?? levelProgress.progress;
        final bool storedIsCompleted =
            prefs.getBool('${materialId}_isCompleted') ??
            levelProgress.isCompleted;
        final int storedCurrentLives =
            prefs.getInt('${materialId}_currentLives') ??
            levelProgress.currentLives;
        final int storedSceneIndex =
            prefs.getInt('${materialId}_lastSceneIndex') ??
            levelProgress.currentSceneIndex;

        updateLevelProgress[materialId] = levelProgress.copyWith(
          progress: storedProgress,
          isCompleted: storedIsCompleted,
          currentLives: storedCurrentLives,
          currentSceneIndex: storedSceneIndex,
        );

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

      user = user.copyWith(levelProgress: updateLevelProgress);
      await _userRepo.saveUser(user);

      // Tentukan materi aktif berdasarkan progres pengguna
      LearningMaterial? activeMaterial;
      String? previousMaterialId;
      for (var material in materials) {
        final levelProgress = user.levelProgress[material.id];
        if (levelProgress != null && levelProgress.isCompleted) {
          previousMaterialId = material.id;
        } else if (levelProgress != null && !levelProgress.isCompleted) {
          activeMaterial = material;
          break;
        }
      }

      if (activeMaterial == null && materials.isNotEmpty) {
        activeMaterial = materials.first;
      }

      if (previousMaterialId != null &&
          user.levelProgress[previousMaterialId]?.isCompleted == true) {
        _lastCompletedMaterial = previousMaterialId;
        showAchievmentPopup = true;
      }
      final achievement = 'Level${_lastCompletedMaterial} Completed';
      if (!user.achievements.contains(achievement)) {
        final updateAchievement = List<String>.from(user.achievements)
          ..add(achievement);
        user = user.copyWith(achievements: updateAchievement);
        await _userRepo.saveUser(user);
      }

      void AchievementDialog() {
        if (showAchievmentPopup && _lastCompletedMaterial != null) {
          showDialog(
            context: context,
            barrierDismissible: false,
            builder: (BuildContext context) {
              return AlertDialog(
                title: const Text('Achievement Unlocked!'),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.star, color: Colors.yellow, size: 50),
                    const SizedBox(height: 10),
                    Text('You completed Level $_lastCompletedMaterial!'),
                    const SizedBox(height: 10),
                    Text(
                      'Badge Earned: Level $_lastCompletedMaterial Completed',
                    ),
                  ],
                ),
                actions: [
                  TextButton(
                    child: const Text('OK'),
                    onPressed: () {
                      setState(() {
                        showAchievmentPopup = false;
                      });
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              );
            },
          );
        }
      }

      // Jika tidak ada level yang sedang aktif, ambil level pertama yang belum selesai
      // if (activeMaterial == null) {
      //   for (var material in materials) {
      //     final levelProgress =
      //         user.levelProgress[material.id] ??
      //         LevelProgress(levelId: material.id, currentLives: 5);
      //     if (!levelProgress.isCompleted) {
      //       activeMaterial = material;
      //       break;
      //     }
      //   }
      // }

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
    return SafeArea(
      bottom: true,
      child: MaterialApp(
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
                        child: CardHome(
                          material: activeMaterial,
                          user: user,
                          path: activeMaterial.assetPath,
                        ),
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
      ),
    );
  }
}
