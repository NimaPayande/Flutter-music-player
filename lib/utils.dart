import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/material.dart';
import 'package:palette_generator/palette_generator.dart';

const kPrimaryColor = Color(0xFFebbe8b);

// playlist songs
List<Audio> songs = [
  Audio('assets/nf_Let_You_Down.mp3',
      metas: Metas(
          title: 'Let You Down',
          artist: 'NF',
          image: const MetasImage.asset(
              'assets/1b7f41e39f3d6ac58798a500eb4a0e2901f4502dv2_hq.jpeg'))),
  Audio('assets/lil_nas_x_industry_baby.mp3',
      metas: Metas(
          title: 'Industry Baby',
          artist: 'Lil Nas X',
          image: const MetasImage.asset('assets/81Uj3NtUuhL._SS500_.jpg'))),
  Audio('assets/Beautiful.mp3',
      metas: Metas(
          title: 'Beautiful',
          artist: 'Eminem',
          image: const MetasImage.asset('assets/916WuJt833L._SS500_.jpg'))),
];

String durationFormat(Duration duration) {
  String twoDigits(int n) => n.toString().padLeft(2, '0');
  String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
  String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
  return '$twoDigitMinutes:$twoDigitSeconds';
  // for example => 03:09
}

// get song cover image colors
Future<PaletteGenerator> getImageColors(AssetsAudioPlayer player) async {
  var paletteGenerator = await PaletteGenerator.fromImageProvider(
    AssetImage(player.getCurrentAudioImage?.path ?? ''),
  );
  return paletteGenerator;
}
