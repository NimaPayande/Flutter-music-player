import 'dart:math' as math;
import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:music_player/player_page.dart';
import 'package:music_player/utils.dart';
import 'package:palette_generator/palette_generator.dart';

class PlaylistPage extends StatefulWidget {
  const PlaylistPage({Key? key}) : super(key: key);
  @override
  State<PlaylistPage> createState() => _PlaylistPageState();
}

class _PlaylistPageState extends State<PlaylistPage>
    with SingleTickerProviderStateMixin {
  final player = AssetsAudioPlayer();
  bool isPlaying = true;

  // define an animation controller for rotate the song cover image
  late final AnimationController _animationController =
      AnimationController(vsync: this, duration: const Duration(seconds: 3));

  @override
  void initState() {
    openPlayer();

    player.isPlaying.listen((event) {
      if (mounted) {
        setState(() {
          isPlaying = event;
        });
      }
    });
    super.initState();
  }

  // define a playlist for player
  void openPlayer() async {
    await player.open(Playlist(audios: songs),
        autoStart: false, showNotification: true, loopMode: LoopMode.playlist);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.withOpacity(.2),
      appBar: AppBar(
        title: const Text(
          'Music Player',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        centerTitle: false,
        backgroundColor: Colors.transparent,
      ),
      body: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          SafeArea(
              child: ListView.separated(
            separatorBuilder: (context, index) {
              return const Divider(
                color: Colors.white30,
                height: 0,
                thickness: 1,
                indent: 85,
              );
            },
            itemCount: songs.length,
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.only(top: 10),
                child: ListTile(
                  title: Text(
                    songs[index].metas.title!,
                    style: const TextStyle(color: Colors.white),
                  ),
                  subtitle: Text(
                    songs[index].metas.artist!,
                    style: const TextStyle(color: Colors.white70),
                  ),
                  leading: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Image.asset(songs[index].metas.image!.path)),
                  onTap: () async {
                    await player.playlistPlayAtIndex(index);
                    setState(() {
                      player.getCurrentAudioImage;
                      player.getCurrentAudioTitle;
                    });
                  },
                ),
              );
            },
          )),
          player.getCurrentAudioImage == null
              ? const SizedBox.shrink()
              : FutureBuilder<PaletteGenerator>(
                  future: getImageColors(player),
                  builder: (context, snapshot) {
                    return Container(
                      margin: const EdgeInsets.symmetric(
                          horizontal: 15, vertical: 50),
                      height: 75,
                      decoration: BoxDecoration(
                          gradient: LinearGradient(
                              begin: Alignment.topLeft,
                              end: const Alignment(0, 5),
                              colors: [
                                snapshot.data?.lightMutedColor?.color ??
                                    Colors.grey,
                                snapshot.data?.mutedColor?.color ?? Colors.grey,
                              ]),
                          borderRadius: BorderRadius.circular(20)),
                      child: ListTile(
                        leading: AnimatedBuilder(
                          // rotate the song cover image
                          animation: _animationController,
                          builder: (_, child) {
                            // if song is not playing
                            if (!isPlaying) {
                              _animationController.stop();
                            } else {
                              _animationController.forward();
                              _animationController.repeat();
                            }
                            return Transform.rotate(
                                angle: _animationController.value * 2 * math.pi,
                                child: child);
                          },
                          child: CircleAvatar(
                              radius: 30,
                              backgroundColor: Colors.grey,
                              backgroundImage: AssetImage(
                                  player.getCurrentAudioImage?.path ?? '')),
                        ),
                        onTap: () => Navigator.push(
                            context,
                            CupertinoPageRoute(
                                fullscreenDialog: true,
                                builder: (context) => PlayerPage(
                                      player: player,
                                    ))),
                        title: Text(player.getCurrentAudioTitle),
                        subtitle: Text(player.getCurrentAudioArtist),
                        trailing: IconButton(
                          padding: EdgeInsets.zero,
                          onPressed: () async {
                            await player.playOrPause();
                          },
                          icon: isPlaying
                              ? const Icon(Icons.pause)
                              : const Icon(Icons.play_arrow),
                        ),
                      ),
                    );
                  },
                ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    player.dispose();
    super.dispose();
  }
}
