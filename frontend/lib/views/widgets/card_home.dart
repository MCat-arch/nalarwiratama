import 'package:flutter/material.dart';
import 'package:frontend/data/material_data.dart';
import 'package:frontend/views/pages/story.dart';
import 'package:frontend/data/user_data.dart';

class CardHome extends StatelessWidget {
  final LearningMaterial material;
  final UserProfile user;
  const CardHome({super.key, required this.material, required this.user});

  @override
  Widget build(BuildContext context) {
    String path = material.assetPath;

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
                      material.isCompleted
                          ? Colors.green.withOpacity(0.1)
                          : Colors.orange.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  material.isCompleted ? 'SELESAI' : 'BELAJAR SEKARANG',
                  style: TextStyle(
                    fontFamily: 'Quicksand',
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                    color: material.isCompleted ? Colors.green : Colors.orange,
                    letterSpacing: 0.5,
                  ),
                ),
              ),

              const SizedBox(height: 12),

              // Judul Materi
              Text(
                material.title,
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
                material.description,
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
                          value: material.progress,
                          backgroundColor: Colors.grey[200],
                          valueColor: AlwaysStoppedAnimation<Color>(
                            material.isCompleted
                                ? Colors.green
                                : const Color(0xFF8B5F3D),
                          ),
                          minHeight: 6,
                          borderRadius: BorderRadius.circular(3),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          '${(material.progress * 100).toStringAsFixed(0)}% selesai',
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
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder:
                                (context) => StoryPage(
                
                                  storyPath: path,
                                  user: user,
                                  materialTitle: material.title,
                                ),
                          ),
                        );
                      },
                      child: Text(
                        material.isCompleted ? 'ULANGI' : 'MULAI',
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
