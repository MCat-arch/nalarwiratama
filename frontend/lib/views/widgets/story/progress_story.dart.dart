import 'package:flutter/material.dart';

class StoryProgress extends StatelessWidget {
  final int currentIndex;
  final int totalScenes;
  const StoryProgress({super.key, required this.currentIndex, required this.totalScenes});

  @override
  Widget build(BuildContext context) {
    return Container(

      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.6),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        'Scene ${currentIndex+1}/$totalScenes',
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
        )
      ),
    );
  }
}
