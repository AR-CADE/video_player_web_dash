// ignore_for_file: unused_local_variable

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

void main() {
  runApp(const VideoApp());
}

class VideoApp extends StatefulWidget {
  const VideoApp({super.key});

  @override
  VideoAppState createState() => VideoAppState();
}

class VideoAppState extends State<VideoApp> {
  late VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();
    try {
      final uri = Uri.parse(
        'https://livesim.dashif.org/livesim/chunkdur_1/ato_7/testpic4_8s/Manifest.mpd',
      );
      final uri1 = Uri.parse(
        'https://dash.akamaized.net/dash264/TestCasesUHD/2b/11/MultiRate.mpd',
      );
      final uri2 = Uri.parse(
        'https://dash.akamaized.net/dash264/TestCasesIOP33/adapatationSetSwitching/5/manifest.mpd',
      );
      final uri3 = Uri.parse(
        'https://dash.akamaized.net/dash264/TestCases/2c/qualcomm/1/MultiResMPEG2.mpd',
      );
      final uri4 = Uri.parse(
        'https://dash.akamaized.net/dash264/TestCasesHD/2b/qualcomm/1/MultiResMPEG2.mpd',
      );
      final uri5 = Uri.parse(
        'https://dash.akamaized.net/dash264/TestCases/1b/qualcomm/1/MultiRatePatched.mpd',
      );
      final uri6 = Uri.parse(
        'https://bitmovin-a.akamaihd.net/content/MI201109210084_1/mpds/f08e80da-bf1d-4e3d-8899-f0f6155f6efa.mpd',
      );

      final uri7 = Uri.parse(
        'https://dash.akamaized.net/akamai/bbb_30fps/bbb_30fps.mpd',
      );
      final uri8 = Uri.parse(
        'http://media.developer.dolby.com/DolbyVision_Atmos/profile8.1_DASH/p8.1.mpd',
      );
      final uri9 = Uri.parse(
        'https://ftp.itec.aau.at/datasets/mmsys12/TheSwissAccount/MPDs/TheSwissAccount_15s_isoffmain_DIS_23009_1_v_2_1c2_2011_08_30.mpd',
      );
      final uri10 = Uri.parse(
        'https://ftp.itec.aau.at/datasets/mmsys12/RedBullPlayStreets/MPDs/RedBullPlayStreets_15s_isoffmain_DIS_23009_1_v_2_1c2_2011_08_30.mpd',
      );
      final uri11 = Uri.parse(
        'https://ftp.itec.aau.at/datasets/mmsys12/Valkaama/MPDs/Valkaama_15s_act_isoffmain_DIS_23009_1_v_2_1c2_2011_08_30.mpd',
      );
      final uri12 = Uri.parse(
        'https://ftp.itec.aau.at/datasets/mmsys12/OfForestAndMen/MPDs/OfForestAndMen_15s_isoffmain_DIS_23009_1_v_2_1c2_2011_08_30.mpd',
      );
      final uri13 = Uri.parse(
        'https://ftp.itec.aau.at/datasets/mmsys12/TearsOfSteel/ToS_s2.mpd',
      );
      _controller = VideoPlayerController.networkUrl(
        uri7,
      )..initialize().then((_) {
          // Ensure the first frame is shown after the video is initialized,
          // even before the play button has been pressed.
          setState(() {});
        });
      _controller.setVolume(0);
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Video Demo',
      home: Scaffold(
        body: Center(
          child: _controller.value.isInitialized
              ? AspectRatio(
                  aspectRatio: _controller.value.aspectRatio,
                  child: VideoPlayer(_controller),
                )
              : Container(),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            setState(() {
              _controller.value.isPlaying
                  ? _controller.pause()
                  : _controller.play();
            });
          },
          child: Icon(
            _controller.value.isPlaying ? Icons.pause : Icons.play_arrow,
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }
}
