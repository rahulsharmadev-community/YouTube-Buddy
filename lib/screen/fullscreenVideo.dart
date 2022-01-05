// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class FullScreenVideo extends StatefulWidget {
  final String videoUrl;

  const FullScreenVideo(
    this.videoUrl, {
    Key? key,
  }) : super(key: key);

  @override
  State<FullScreenVideo> createState() => _FullScreenVideoState();
}

class _FullScreenVideoState extends State<FullScreenVideo> {
  late YoutubePlayerController controller;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {
      controller = YoutubePlayerController(
          initialVideoId: YoutubePlayer.convertUrlToId(widget.videoUrl)!,
          flags: const YoutubePlayerFlags(
              autoPlay: true, forceHD: true, disableDragSeek: true));
    });
    landscape;
  }

  get landscape async => await SystemChrome.setPreferredOrientations(
      [DeviceOrientation.landscapeLeft, DeviceOrientation.landscapeRight]);
  get portrait async => await SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitDown, DeviceOrientation.portraitUp]);

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    portrait;
    controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.black,
        body: Center(
          child: Stack(alignment: Alignment.center, children: [
            YoutubePlayer(
                controller: controller,
                width: MediaQuery.of(context).size.width,
                onEnded: (data) {
                  Navigator.pop(context);
                },
                bottomActions: [
                  const SizedBox(width: 14.0),
                  CurrentPosition(),
                  const SizedBox(width: 8.0),
                  ProgressBar(
                    isExpanded: true,
                  ),
                  RemainingDuration(),
                  const PlaybackSpeedButton(),
                ]),
            Positioned(
              bottom: 16,
              right: 16,
              child: Image.asset(
                'assets/icons/hd.png',
                color: Colors.red,
                width: 28,
              ),
            ),
          ]),
        ));
  }
}
