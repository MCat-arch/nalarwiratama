// lib/views/pages/story_page.dart
import 'package:flutter/material.dart';
import 'package:frontend/data/story_data.dart';
import 'package:frontend/data/user_data.dart';
import 'package:frontend/services/story_service.dart';
import 'package:frontend/views/widgets/story/card_story.dart';

class StoryPage extends StatelessWidget {
  final String storyPath;
  final UserProfile user;
  final String materialTitle;

  const StoryPage({super.key, required this.storyPath, required this.user, required this.materialTitle});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<StoryData>(
        future: StoryService().loadStoryData(storyPath),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          if (!snapshot.hasData) {
            return Center(child: Text('Data unavailable'));
          }

          void onCompleted() {
            // Handle story completion
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(const SnackBar(content: Text('Cerita selesai!')));
            Navigator.pop(context);
          }

          ;

          return StoryCard(
            storyData: snapshot.data!,
            materialTitle: materialTitle,
            user: user,
            onCompleted: onCompleted,
            onHomePressed: () => Navigator.pop(context),
          );
        },
      ),
    );
  }
}
