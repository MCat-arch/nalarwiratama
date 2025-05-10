import 'package:flutter/material.dart';
import 'package:frontend/data/notifiers.dart';
import 'package:frontend/views/pages/home.dart';
import 'package:frontend/views/pages/kitab.dart';
import 'package:frontend/views/pages/profile.dart';
import 'package:frontend/views/pages/story.dart';
import 'widgets/navbar.dart';

List<Widget> pages = [Home(), StoryPage(), Kitab(), ProfilePage()];

class WidgetTree extends StatefulWidget {
  const WidgetTree({super.key});

  @override
  State<WidgetTree> createState() => _WidgetTreeState();
}

class _WidgetTreeState extends State<WidgetTree> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(title: const Text('Nalarwiratama'), centerTitle: true),
      body: ValueListenableBuilder(
        valueListenable: selectedPageNotifier,
        builder: (context, selectedPage, child) {
          return pages.elementAt(selectedPage);
          // return IndexedStack(
          //   index: selectedPage,
          //   children: pages,
          // );
        },
      ),
      bottomNavigationBar: Navbar(), // Navbar widget
    );
  }
}
