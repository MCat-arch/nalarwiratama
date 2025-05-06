import 'package:flutter/material.dart';
import 'package:frontend/data/notifiers.dart';

class Navbar extends StatelessWidget {
  const Navbar({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(valueListenable: selectedPageNotifier,
     builder: (context, selectedPage, child){
      return NavigationBar(
        destinations: [
          NavigationDestination(icon: Icon(Icons.home),label:'Home'),
          NavigationDestination(icon: Icon(Icons.apple_rounded),label:'Story'),
          NavigationDestination(icon: Icon(Icons.book),label:'Book'),
          NavigationDestination(icon: Icon(Icons.person), label: 'Profile')
        ],
        onDestinationSelected: (int value){
          selectedPageNotifier.value = value;
        },
        selectedIndex: selectedPage,
      );
     });
  }
}