import 'package:MindMate/Models/ThemeProvider.dart';
import 'package:MindMate/Pages/HomePage.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: FirebaseOptions(
      apiKey: "AIzaSyDAW8Qr-RAlm-NvSrl7_mIYWaSAJM9dzsM",
      appId: "1:840287474885:web:293ffd44aa2a1c20b7ccac",
      messagingSenderId: "840287474885",
      projectId: "mindmate-d2359",
    ),
  );
  runApp(ChangeNotifierProvider(
    create: (context) => ThemeProvider(),
    child: MindMate(),
  ));
}

class MindMate extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: themeProvider.currentTheme,
      home: HomePage(),
    );
  }
}
