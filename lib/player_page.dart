import 'dart:ui';

import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/material.dart';

class PlayerPage extends StatefulWidget {
  const PlayerPage({Key? key}) : super(key: key);

  @override
  State<PlayerPage> createState() => _PlayerPageState();
}

class _PlayerPageState extends State<PlayerPage> {
  bool isPlaying = false;
  Duration duration = Duration.zero;
  Duration position = Duration.zero;
  Color dominantColor = Colors.transparent;
  final player = AssetsAudioPlayer();
  @override
  void initState() {
    openPlayer();
    player.onReadyToPlay.listen((event) {
      setState(() {
        duration = event?.duration ?? Duration.zero;
      });
    });
    player.currentPosition.listen((newPosition) {
      setState(() {
        position = newPosition;
      });
    });
    super.initState();
  }

  List<Audio> songs = [
    Audio('assets/nf_Let_You_Down.mp3',
        metas: Metas(
            title: 'Let you down',
            artist: 'NF',
            image: const MetasImage.asset(
                'assets/1b7f41e39f3d6ac58798a500eb4a0e2901f4502dv2_hq.jpeg'))),
  ];
  void openPlayer() async {
    await player.open(Playlist(audios: songs),
        autoStart: false, showNotification: false, loopMode: LoopMode.playlist);
  }

  String durationFormat(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
    return '$twoDigitMinutes:$twoDigitSeconds';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        leading: Padding(
          padding: const EdgeInsets.only(left: 10),
          child: IconButton(
              onPressed: () => Navigator.pop(context),
              icon: const Icon(
                Icons.keyboard_arrow_down,
                size: 30,
                color: Colors.white,
              )),
        ),
      ),
      body: Stack(
        alignment: Alignment.topCenter,
        children: [
          // ImageFiltered(
          //   imageFilter: ImageFilter.blur(sigmaX: 3, sigmaY: 3),
          //   child: Image.asset(
          //     player.getCurrentAudioImage?.path ?? '',
          //     width: double.infinity,
          //   ),
          // ),
          Container(
            margin: const EdgeInsets.only(bottom: 400),
            decoration: const BoxDecoration(
                gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [Colors.transparent, Colors.black])),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                decoration: const BoxDecoration(boxShadow: [
                  BoxShadow(blurRadius: 100, color: Colors.black45)
                ]),
                child: Image.asset(
                  player.getCurrentAudioImage?.path ?? '',
                  height: 300,
                ),
              ),
              const SizedBox(height: 30),
              Text(
                player.current.valueOrNull?.audio.audio.metas.title ?? '',
                style: const TextStyle(fontSize: 24),
              ),
              const SizedBox(
                height: 30,
              ),
              Slider(
                activeColor: Colors.white,
                inactiveColor: Colors.grey,
                min: 0,
                max: duration.inSeconds.toDouble(),
                value: position.inSeconds.toDouble(),
                onChanged: (value) async {
                  await player.seek(Duration(seconds: value.toInt()));
                },
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Text(durationFormat(position)),
                  Text(durationFormat(duration - position))
                ],
              ),
              Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                        onPressed: () async {
                          await player.previous();
                        },
                        icon: const Icon(Icons.skip_previous)),
                    IconButton(
                      onPressed: () async {
                        await player.playOrPause();
                        setState(() {
                          isPlaying = !isPlaying;
                        });
                      },
                      icon: isPlaying
                          ? const Icon(Icons.pause)
                          : const Icon(Icons.play_arrow),
                    ),
                    IconButton(
                        onPressed: () async {
                          await player.next();
                          setState(() {
                            isPlaying = true;
                          });
                        },
                        icon: const Icon(Icons.skip_next)),
                  ],
                ),
              )
            ],
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
