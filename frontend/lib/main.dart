import 'package:flutter/material.dart';
import 'package:frontend/views/pages/welcome_page.dart';
import 'package:provider/provider.dart';
import 'package:frontend/theme_provider.dart';
import 'package:frontend/data/audio_provider.dart';

//error karena cara akses asset misalnya pake assetpath yg seharusnya bukan

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context)=>ThemeProvider()),
        ChangeNotifierProvider(create: (context) => AudioProvider()),
      ],
      child: const MainApp(),
    ),
  );
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});
  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        return MaterialApp(
          theme: themeProvider.themeData,
          debugShowCheckedModeBanner: false,
          home: WelcomePage(),
        );
      },
    );
  }
}
