// lib/services/story_service.dart
import 'package:flutter/services.dart';
import 'dart:convert';
import '../data/story_data.dart';

class StoryService {
  Future<StoryData> loadStoryData(String path) async {
    try {
      final jsonString = await rootBundle.loadString(path);
      final jsonData = json.decode(jsonString);
      return StoryData.fromJson(jsonData);
    } catch (e) {
      print('Error loading story data: $e');
      throw Exception('Failed to load story data');
    }
  }
}