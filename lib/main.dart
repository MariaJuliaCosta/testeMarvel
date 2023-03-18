import 'package:flutter/material.dart';
import 'package:project_test_marvel/screens/character_page.dart';


void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Flutter Demo',
      home: CharactersScreen(),
    );
  }
}
