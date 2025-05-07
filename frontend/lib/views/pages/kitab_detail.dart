import 'package:flutter/material.dart';
import 'package:frontend/data/material_data.dart';

class KitabDetail extends StatelessWidget {
  final LearningMaterial material;

  const KitabDetail({super.key, required this.material});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(material.title),
        backgroundColor: const Color(0xFFD3B99A),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image.asset(material.imageUrl),
            const SizedBox(height: 16),
            Text(
              material.title,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              material.description,
              style: const TextStyle(
                fontSize: 16,
                color: Colors.black54,
              ),
            ),
            const SizedBox(height: 16),
            if (material.isCompleted)
              Text(
                'Status: Completed (Score: ${material.score ?? 0})',
                style: const TextStyle(
                  fontSize: 16,
                  color: Colors.green,
                ),
              )
            else
              const Text(
                'Status: Not Completed',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.red,
                ),
              ),
          ],
        ),
      ),
    );
  }
}