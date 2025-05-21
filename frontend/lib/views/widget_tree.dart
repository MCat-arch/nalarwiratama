import 'package:flutter/material.dart';
import 'package:frontend/data/notifiers.dart';
import 'package:frontend/views/pages/home.dart';
import 'package:frontend/views/pages/kitab.dart';
import 'package:frontend/views/pages/profile.dart';
import 'package:frontend/views/pages/story.dart';
import 'package:frontend/views/widgets/navbar.dart';

List<Widget> pages = [
  const Home(),
  // const StoryPage(), // Uncomment jika sudah siap
  const Kitab(),
  const ProfilePage(),
];

class WidgetTree extends StatefulWidget {
  const WidgetTree({super.key});

  @override
  State<WidgetTree> createState() => _WidgetTreeState();
}

class _WidgetTreeState extends State<WidgetTree> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true, // Izinkan body meluas ke bawah bottomNavigationBar
      body: ValueListenableBuilder(
        valueListenable: selectedPageNotifier,
        builder: (context, selectedPage, child) {
          return pages.elementAt(selectedPage);
        },
      ),
      bottomNavigationBar: const Navbar(), // Navbar widget
    );
  }
}
