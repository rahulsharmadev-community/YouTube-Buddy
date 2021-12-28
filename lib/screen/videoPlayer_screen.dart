// ignore_for_file: file_names
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

class FullScreenVideo extends StatefulWidget {
  final String videoId;
  const FullScreenVideo(this.videoId, {Key? key}) : super(key: key);

  @override
  State<FullScreenVideo> createState() => _FullScreenVideoState();
}

class _FullScreenVideoState extends State<FullScreenVideo> {
  late String _videoUrl;
  late bool isLandscape;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {
      _videoUrl =
          'https://www.youtube-nocookie.com/embed/${widget.videoId}?modestbranding=1&controls=1&fs=0&autoplay=1&rel=0&iv_load_policy=3&cc_load_policy=1';
    });
    landscape;
  }

  get landscape async {
    await SystemChrome.setPreferredOrientations(
        [DeviceOrientation.landscapeLeft, DeviceOrientation.landscapeRight]);
    await SystemChrome.setEnabledSystemUIOverlays([]);
    isLandscape = true;
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    portrait();
  }

  get portrait async {
    await SystemChrome.setPreferredOrientations(
        [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
    await SystemChrome.setEnabledSystemUIOverlays(SystemUiOverlay.values);
    isLandscape = false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Theme.of(context).canvasColor,
        body: SafeArea(
          child: Stack(
            children: [
              InAppWebView(
                initialUrlRequest: URLRequest(url: Uri.parse(_videoUrl)),
                shouldOverrideUrlLoading: (controller, navigationAction) async {
                  var uri = navigationAction.request.url!;
                  if (!["youtube-nocookie"].contains(uri.scheme)) {
                    // and cancel the request
                    return NavigationActionPolicy.CANCEL;
                  }

                  return NavigationActionPolicy.ALLOW;
                },
                initialOptions: InAppWebViewGroupOptions(
                    crossPlatform: InAppWebViewOptions(
                        useShouldOverrideUrlLoading: true,
                        incognito: true,
                        supportZoom: false)),
              ),
              Column(
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      margin: const EdgeInsets.only(top: 5.0),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 18.0, vertical: 14.0),
                      decoration: const BoxDecoration(
                          borderRadius: BorderRadius.only(
                              topRight: Radius.circular(35),
                              bottomRight: Radius.circular(35)),
                          color: Colors.white),
                      child: const Icon(Icons.exit_to_app, color: Colors.red),
                    ),
                  ),
                  IconButton(
                      color: Colors.white,
                      onPressed: () => isLandscape ? portrait : landscape,
                      icon: const Icon(Icons.screen_rotation))
                ],
              ),
            ],
          ),
        ));
  }
}
