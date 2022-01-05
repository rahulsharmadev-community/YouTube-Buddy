import 'dart:async';

import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class MultiVerseScreen extends StatefulWidget {
  final String videoUrl;
  const MultiVerseScreen(this.videoUrl, {Key? key}) : super(key: key);

  @override
  State<MultiVerseScreen> createState() => _MultiVerseScreenState();
}

class _MultiVerseScreenState extends State<MultiVerseScreen>
    with SingleTickerProviderStateMixin {
  late List<YoutubePlayerController> _controllerList;

  late AnimationController _animationController;
  int noOfScreen = 4;
  bool isPlay = false;
  bool isLoop = false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _upgradeController();
    _animationController = AnimationController(
        vsync: this,
        duration: const Duration(milliseconds: 300),
        reverseDuration: const Duration(milliseconds: 300));
    setState(() {});
  }

  void _upgradeController() async {
    try {
      _controllerList = [];
      await Future.delayed(Duration(milliseconds: 300));
      _controllerList = List<YoutubePlayerController>.generate(
          noOfScreen,
          (index) => YoutubePlayerController(
              initialVideoId: YoutubePlayer.convertUrlToId(widget.videoUrl)!,
              flags: YoutubePlayerFlags(
                  hideControls: true, mute: true, loop: isLoop)));
      setState(() {});
    } catch (error) {
      Exception(error);
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _animationController.dispose();
    _controllerList.forEach((element) {
      element.dispose();
    });
    _controllerList.clear();
  }

  void playAll() {
    _animationController.forward();
    setState(() {
      _controllerList.forEach((element) {
        element.play();
      });
      isPlay = true;
    });
  }

  void stopAll() {
    _animationController.reverse();

    setState(() {
      _controllerList.forEach((element) {
        element.pause();
      });
      isPlay = false;
    });
  }

  void startLoopAll() {
    setState(() {
      isLoop = true;
    });
  }

  void stopLoopAll() {
    setState(() {
      isLoop = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: const BackButton(color: Colors.black),
          title: Row(
            children: [
              const Text(
                'Video Slots',
                style: TextStyle(fontSize: 18, color: Colors.black),
              ),
              const SizedBox(width: 12),
              DropdownButton(
                  alignment: Alignment.bottomLeft,
                  enableFeedback: true,
                  style: const TextStyle(fontSize: 18, color: Colors.black),
                  value: noOfScreen,
                  items: [2, 4, 6, 8, 10, 12]
                      .map((e) => DropdownMenuItem<int>(
                            value: e,
                            child: Text(e.toString()),
                          ))
                      .toList(),
                  onChanged: (value) {
                    setState(() {
                      noOfScreen = value as int;
                    });
                    _upgradeController();
                  }),
            ],
          ),
          actions: [
            Switch(
                value: isLoop,
                activeColor: Colors.orangeAccent,
                onChanged: (value) {
                  setState(() {
                    isLoop = value;
                  });
                  _upgradeController();
                })
          ],
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: FloatingActionButton(
                backgroundColor: !isPlay ? Colors.green : Colors.red,
                onPressed: isPlay ? stopAll : playAll,
                child: AnimatedIcon(
                  icon: AnimatedIcons.play_pause,
                  size: 28,
                  progress: _animationController,
                  semanticLabel: 'Show menu',
                ),
              ),
            ),
          ],
        ),
        body: _controllerList.isEmpty
            ? const CircularProgressIndicator()
            : GridView.builder(
                itemCount: noOfScreen,
                padding: const EdgeInsets.all(4),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 16 / 9,
                    mainAxisSpacing: 4,
                    crossAxisSpacing: 4),
                itemBuilder: (builder, index) => Row(
                      children: [
                        Expanded(
                          child: YoutubePlayer(
                            controller: _controllerList[index],
                            showVideoProgressIndicator: true,
                          ),
                        ),
                      ],
                    )));
  }
}
