import 'package:flutter/material.dart';
import 'package:pacman/screens/man_screen.dart';

void main() => runApp(PacmanApp());

class PacmanApp extends StatelessWidget {
  const PacmanApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'PACMAN',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.amber,
      ),
      home: MainScreen(),
    );
  }
}
