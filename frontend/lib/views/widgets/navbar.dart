import 'package:flutter/material.dart';
import 'package:frontend/data/notifiers.dart';

class Navbar extends StatelessWidget {
  const Navbar({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: selectedPageNotifier,
      builder: (context, selectedPage, child) {
        return ClipRRect(
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
          child: Container(
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color.fromARGB(209, 204, 162, 100),
                  Color.fromARGB(209, 184, 142, 80),
                ],
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.15),
                  blurRadius: 10,
                  spreadRadius: 2,
                  offset: const Offset(0, -3),
                ),
              ],
            ),
            child: NavigationBar(
              backgroundColor: Colors.transparent,
              elevation: 0,
              height: 70, // Tinggi navbar sedikit lebih besar untuk estetika
              labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
              destinations: [
                _buildNavItem(Icons.home, 'Home', selectedPage == 0),
                _buildNavItem(Icons.book, 'Book', selectedPage == 1),
                _buildNavItem(Icons.person, 'Profile', selectedPage == 2),
              ],
              onDestinationSelected: (int value) {
                selectedPageNotifier.value = value;
              },
              selectedIndex: selectedPage,
            ),
          ),
        );
      },
    );
  }

  // Fungsi untuk membangun item navigasi dengan animasi
  Widget _buildNavItem(IconData icon, String label, bool isSelected) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      child: NavigationDestination(
        icon: Icon(
          icon,
          size: 28,
          color: isSelected ? Colors.white : Colors.white70,
        ),
        selectedIcon: Icon(
          icon,
          size: 28,
          color: Colors.white,
          shadows: const [
            Shadow(color: Colors.black26, blurRadius: 4, offset: Offset(0, 2)),
          ],
        ),
        label: label,
        tooltip: label,
      ),
    );
  }
}
