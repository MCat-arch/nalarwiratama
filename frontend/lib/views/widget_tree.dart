import 'package:flutter/material.dart';
import 'package:frontend/views/pages/home.dart';
import 'package:frontend/views/pages/kitab.dart';
import 'package:frontend/views/pages/profile.dart';
import 'package:frontend/views/pages/story.dart';
import 'widgets/navbar.dart';

List<Widget> pages = [Home(), Kitab(), Story(), Profile()];

class WidgetTree extends StatelessWidget {
  const WidgetTree({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Nalarwiratama'), centerTitle: true),
      body: pages.elementAt(1),
      bottomNavigationBar: Navbar(), // Navbar widget
    );
  }
}
