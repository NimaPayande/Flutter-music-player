import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:music_player/music_list.dart';
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
      theme: ThemeData(
          useMaterial3: true,
          textTheme:
              const TextTheme(bodyMedium: TextStyle(color: Colors.white)),
          iconTheme: const IconThemeData(color: Colors.white)),
      debugShowCheckedModeBanner: false,
      home: const PlayerPage(),
    );
  }
}
