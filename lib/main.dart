import 'package:flutter/material.dart';
import 'package:music_player/player_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Music Player',
      theme: ThemeData(useMaterial3: true),
      home: const PlayerPage(),
    );
  }
}
