import 'package:flutter/material.dart';
import 'package:frontend/data/material_data.dart';
import 'package:frontend/views/widgets/card_kitab.dart';
import 'package:frontend/views/pages/kitab_detail.dart';

class Kitab extends StatelessWidget {
  final List<LearningMaterial> materials = [
    LearningMaterial(
      id: '1',
      title: 'PENGANTAR LOGIKA MATEMATIKA',
      description:
          'Pahami konsep dasar logika matematika sebagai landasan berpikir rasional',
      isCompleted: true,
      score: 100,
      imageUrl: 'assets/images/logic.jpg',
    ),
    LearningMaterial(
      id: '2',
      title: 'PERNYATAAN DAN JENISNYA',
      description: 'Pelajari perbedaan antara pernyataan tunggal dan majemuk',
      isCompleted: false,
      score: null,
      imageUrl: 'assets/images/statement.jpg',
    ),
    LearningMaterial(
      id: '3',
      title: 'INGKARAN (NEGASI)',
      description: 'Ketahui cara membentuk ingkaran dari suatu pernyataan',
      isCompleted: true,
      score: 85,
      imageUrl: 'assets/images/negation.jpg',
    ),
  ];

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
      body: ListView.builder(
        itemCount: materials.length,
        itemBuilder: (context, index) {
          return CardKitab(
            material: materials[index],
            onTap: () {
              // Handle card tap
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => KitabDetail(
                    material: materials[index],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
