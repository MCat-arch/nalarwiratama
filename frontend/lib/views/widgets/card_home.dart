import 'package:flutter/material.dart';
import 'package:frontend/data/level_data.dart';
import 'package:frontend/data/material_data.dart';
import 'package:frontend/views/pages/story.dart';
import 'package:frontend/data/user_data.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CardHome extends StatefulWidget {
  final LearningMaterial material;
  final UserProfile user;
  final String path;
  const CardHome({
    super.key,
    required this.material,
    required this.user,
    required this.path,
  });

  @override
  State<CardHome> createState() => _CardHomeState();
}

class _CardHomeState extends State<CardHome> {
  late double _progress;
  late bool _isCompleted;
  late int _lastSceneIndex;

  @override
  void initState() {
    super.initState();
    _loadProgressFromStorage();
  }

  Future<void> _loadProgressFromStorage() async {
    final prefs = await SharedPreferences.getInstance();
    final String id = widget.material.id;

    setState(() {
      _progress = prefs.getDouble('${id}_progress') ?? widget.material.progress;
      _isCompleted =
          prefs.getBool('${id}_isCompleted') ?? widget.material.isCompleted;
      _lastSceneIndex = prefs.getInt('${id}_lastSceneIndex') ?? 0;
    });
  }

  Future<void> _saveProgressToStorage() async {
    final prefs = await SharedPreferences.getInstance();
    final String id = widget.material.id;

    await prefs.setDouble('${id}_progress', _progress);
    await prefs.setBool('${id}_isCompleted', _isCompleted);
    await prefs.setInt('${id}_lastSceneIndex', _lastSceneIndex);
    

    final UpdateUser = widget.user.copyWith(
      levelProgress: {
        ...widget.user.levelProgress,
        id: (widget.user.levelProgress[id] ??
                LevelProgress(levelId: id, currentLives: 5))
            .copyWith(currentSceneIndex: _lastSceneIndex),
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(0),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () {
          // Tambahkan aksi ketika card di-tap
        },
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Badge Status
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color:
                      widget.material.isCompleted
                          ? Colors.green.withOpacity(0.1)
                          : Colors.orange.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  widget.material.isCompleted ? 'SELESAI' : 'BELAJAR SEKARANG',
                  style: TextStyle(
                    fontFamily: 'Quicksand',
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                    color:
                        widget.material.isCompleted
                            ? Colors.green
                            : Colors.orange,
                    letterSpacing: 0.5,
                  ),
                ),
              ),

              const SizedBox(height: 12),

              // Judul Materi
              Text(
                widget.material.title,
                style: const TextStyle(
                  fontFamily: 'Quicksand',
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                ),
              ),

              const SizedBox(height: 8),

              // Deskripsi
              Text(
                widget.material.description,
                style: TextStyle(
                  fontFamily: 'Quicksand',
                  fontSize: 14,
                  color: Colors.grey[600],
                  height: 1.4,
                ),
              ),

              const SizedBox(height: 16),

              // Image
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.asset(
                  '/images/home_card.png',
                  height: 120,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),

              const SizedBox(height: 16),

              // Progress Bar dan Tombol
              Row(
                children: [
                  // Progress Bar
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        LinearProgressIndicator(
                          value: _progress/100,
                          backgroundColor: Colors.grey[200],
                          valueColor: AlwaysStoppedAnimation<Color>(
                            widget.material.isCompleted
                                ? Colors.green
                                : const Color(0xFF8B5F3D),
                          ),
                          minHeight: 6,
                          borderRadius: BorderRadius.circular(3),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          '${_progress.toStringAsFixed(0)}% selesai',
                          style: TextStyle(
                            fontFamily: 'Quicksand',
                            fontSize: 10,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(width: 12),

                  // Tombol
                  SizedBox(
                    height: 40,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF8B5F3D),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                      ),
                      onPressed: () async {
                        final prefs = await SharedPreferences.getInstance();
                        final String id = widget.material.id;

                        int initialIndex = 0;
                        if (!widget.material.isCompleted) {
                          initialIndex =
                              prefs.getInt('${id}_lastSceneIndex') ?? 0;
                        } else {
                          await prefs.setDouble('${id}_progress', 0.0);
                          await prefs.setBool('${id}_isCompleted', false);
                          await prefs.setInt('${id}_lastSceneIndex', 0);
                        }
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder:
                                (context) => StoryPage(
                                  storyPath: widget.path,
                                  user: widget.user,
                                  materialTitle: widget.material.title,
                                  initialScene: initialIndex,
                                  material: widget.material,
                                ),
                          ),
                        );
                      },
                      child: Text(
                        widget.material.isCompleted ? 'ULANGI' : 'MULAI',
                        style: const TextStyle(
                          fontFamily: 'Quicksand',
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
