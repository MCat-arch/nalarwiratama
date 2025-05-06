import 'package:flutter/material.dart';
import 'package:frontend/views/widgets/navbar.dart'; // Adjust the import according to your project structure

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      
      home: Scaffold(
        
        appBar: AppBar(
          toolbarHeight: 80,
          flexibleSpace: Container(
            color: Color(0xFFD3B99A), // Background color
          ),
           automaticallyImplyLeading: false, // supaya leading tidak muncul default
           titleSpacing: 0, // hilangkan spacing bawaan AppBar
          actions: <Widget>[

            Padding(
              padding: const EdgeInsets.all(10.0),

              child: CircleAvatar(
                backgroundImage: AssetImage(
                  '/images/img_dip.jpg',
                ), // Replace with your image path
                radius: 20,
              ),
            ),
            SizedBox(width: 10),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              decoration: BoxDecoration(
                color: Color(0xFF8B5F3D),
                borderRadius: BorderRadius.circular(15),
              ),
              child: Text('3/10', style: TextStyle(color: Colors.white)),
            ),
            SizedBox(width: 10),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              decoration: BoxDecoration(
                color: Color(0xFF8B5F3D),
                borderRadius: BorderRadius.circular(15),
              ),

              child: Row(
                children: [
                  Icon(Icons.monetization_on, color: Colors.yellow),
                  SizedBox(width: 5),
                  Text('50', style: TextStyle(color: Colors.white)),
                ],
              ),
            ),
            SizedBox(width: 10),
            Row(
              children: [
                for (int i = 0; i < 5; i++)
                  Icon(
                    Icons.favorite,
                    color: (i < 3) ? Colors.yellow : Colors.grey,
                    size: 20,
                  ),
              ],
            ),
            SizedBox(width: 10),
          ],
          backgroundColor: Color.fromARGB(207, 199, 134, 60),
        ),
        body: SizedBox(
          height: double.infinity,
          width: double.infinity,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Welcome to the Home Page!'),
              Container(
                alignment: Alignment.bottomCenter,
                width: double.infinity,
                height: 70,
                child: Navbar(), // Navbar widget
              ),
              // Add more widgets here as needed
            ],
          ),
        ), // Navbar widget
      ),
    );
  }
}
