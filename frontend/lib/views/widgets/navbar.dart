import 'package:flutter/material.dart';
import 'package:frontend/data/notifiers.dart';

class Navbar extends StatelessWidget {
  const Navbar({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: selectedPageNotifier,
      builder: (context, selectedPage, child) {
        return Container(
          decoration: BoxDecoration(
            color: const Color.fromARGB(209, 204, 162, 100),
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
            boxShadow: [
              BoxShadow(
                color: const Color.fromARGB(
                  255,
                  255,
                  255,
                  255,
                ).withOpacity(0.2),
                blurRadius: 10,
                spreadRadius: 1,
                offset: Offset(0, -3),
              ),
            ],
          ),
          child: NavigationBar(
            backgroundColor: Colors.transparent,
            destinations: [
              NavigationDestination(icon: Icon(Icons.home), label: 'Home'),
              // NavigationDestination(
              //   icon: Icon(Icons.apple_rounded),
              //   label: 'Story',
              // ),
              NavigationDestination(icon: Icon(Icons.book), label: 'Book'),
              NavigationDestination(icon: Icon(Icons.person), label: 'Profile'),
            ],
            onDestinationSelected: (int value) {
              selectedPageNotifier.value = value;
            },
            selectedIndex: selectedPage,
          ),
        );
      },
    );
  }
}
