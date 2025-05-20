import 'package:flutter/material.dart';
import 'package:frontend/data/material_data.dart';

class KitabDetail extends StatelessWidget {
  final LearningMaterial material;

  const KitabDetail({super.key, required this.material});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        title: Text(
          material.title,
          style: const TextStyle(
            fontFamily: 'Quicksand',
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Colors.black,
          ),
        ),
        centerTitle: true,
        backgroundColor: const Color(0xFFD3B99A),
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header dengan gambar dan status
            Container(
              width: double.infinity,
              height: 180,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 6,
                    offset: const Offset(0, 3),
                  ),
                ],
                image:
                    (material.imageUrl != null && material.imageUrl!.isNotEmpty)
                        ? DecorationImage(
                          image: AssetImage(material.imageUrl!),
                          fit: BoxFit.cover,
                        )
                        : null,
              ),
              child:
                  (material.imageUrl != null && material.imageUrl!.isNotEmpty)
                      ? const Center(
                        child: Icon(
                          Icons.menu_book,
                          size: 60,
                          color: Color(0xFF8B5F3D),
                        ),
                      )
                      : null,
            ),

            const SizedBox(height: 20),

            // Badge status
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color:
                    material.isCompleted
                        ? Colors.green.withOpacity(0.1)
                        : Colors.orange.withOpacity(0.1),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    material.isCompleted
                        ? Icons.check_circle
                        : Icons.access_time,
                    size: 16,
                    color: material.isCompleted ? Colors.green : Colors.orange,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    material.isCompleted
                        ? 'SELESAI • Skor: ${material.score ?? 0}'
                        : 'BELUM SELESAI',
                    style: TextStyle(
                      fontFamily: 'Quicksand',
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color:
                          material.isCompleted ? Colors.green : Colors.orange,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // Judul materi
            Text(
              material.title,
              style: const TextStyle(
                fontFamily: 'Quicksand',
                fontSize: 22,
                fontWeight: FontWeight.w600,
                color: Colors.black,
                height: 1.3,
              ),
            ),

            const SizedBox(height: 12),

            // Deskripsi materi
            Text(
              material.description,
              style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 15,
                color: Colors.grey[700],
                height: 1.5,
                fontWeight: FontWeight.w400,
              ),
            ),

            SizedBox(height: 10),
            Center(
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Text(
                  "Pembahasan",
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.w700,
                    fontSize: 12,
                    fontFamily: 'Quicksand',
                  ),
                ),
              ),
            ),
            Text(
              material.content!,
              style: TextStyle(
                fontFamily: 'Quicksand',
                fontSize: 12,
                color: Colors.grey[700],
                height: 1.5,
              ),
            ),
            const SizedBox(height: 24),

            // Tombol aksi
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF8B5F3D),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  elevation: 0,
                ),
                onPressed: () {
                  // Aksi ketika tombol diklik
                },
                child: Text(
                  material.isCompleted ? 'ULANGI MATERI' : 'MULAI BELAJAR',
                  style: const TextStyle(
                    fontFamily: 'Quicksand',
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
