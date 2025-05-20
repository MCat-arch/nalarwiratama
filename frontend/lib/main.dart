import 'package:flutter/material.dart';
import 'package:frontend/views/pages/welcome_page.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(fontFamily: 'Quicksand'),
      debugShowCheckedModeBanner: false,
      home: WelcomePage(),
    );
  }
}
