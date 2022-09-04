import 'package:flutter/material.dart';
import 'package:music_player/player_page.dart';
import 'package:music_player/utils.dart';

class MusicList extends StatelessWidget {
  const MusicList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
          child: ListView.builder(
        itemCount: songs.length,
        itemBuilder: (context, index) {
          return Container(
            margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 5),
            decoration: const BoxDecoration(),
            child: ListTile(
              title: Text(
                songs[index].metas.title!,
                style: const TextStyle(color: Colors.white),
              ),
              subtitle: Text(
                songs[index].metas.artist!,
                style: const TextStyle(color: Colors.white70),
              ),
              leading: Image.asset(songs[index].metas.image!.path),
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => PlayerPage(index: index),
                    ));
              },
            ),
          );
        },
      )),
    );
  }
}
