import 'package:flutter/material.dart';
import 'package:frontend/provider/chat_provider.dart';
import 'package:frontend/views/pages/welcome_page.dart';
import 'package:provider/provider.dart';
import 'package:frontend/provider/theme_provider.dart';
import 'package:frontend/provider/audio_provider.dart';
import 'package:frontend/provider/user_provider.dart';

//error karena cara akses asset misalnya pake assetpath yg seharusnya bukan

void main() async {
  
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context)=>ThemeProvider()),
        ChangeNotifierProvider(create: (context) => AudioProvider()),
        ChangeNotifierProvider(create: (context) => ChatProvider()),
        ChangeNotifierProvider(create: (context) => UserProvider()),
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
