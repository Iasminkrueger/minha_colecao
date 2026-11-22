import 'package:flutter/material.dart';
import 'pages/home_page.dart';

void main() {
  runApp(const MinhaColecaoApp());
}

class MinhaColecaoApp extends StatelessWidget {
  const MinhaColecaoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Minha Coleção',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF8D6E63)),
        scaffoldBackgroundColor: const Color(0xFFFAF3E8), // fundo cor de papel
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF6D4C41),
          foregroundColor: Colors.white,
        ),
        useMaterial3: true,
      ),
      home: const HomePage(),
    );
  }
}