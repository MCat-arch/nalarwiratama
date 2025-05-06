import 'package:flutter/material.dart';
import 'package:frontend/views/widgets/navbar.dart'; // Adjust the import according to your project structure

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
      ),
      body: Column(
        children: [
          const Text('Welcome to the Home Page!'),
          Navbar(), // Navbar widget
          // Add more widgets here as needed
        ],
      ), // Navbar widget
    );
  }
}