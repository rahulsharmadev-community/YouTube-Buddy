// ignore_for_file: file_names
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

class FullScreenVideo extends StatefulWidget {
  final String videoUrl;
  const FullScreenVideo(this.videoUrl, {Key? key}) : super(key: key);

  @override
  State<FullScreenVideo> createState() => _FullScreenVideoState();
}

class _FullScreenVideoState extends State<FullScreenVideo> {
  late String _embedUrl;
  late bool isLandscape;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {
      _embedUrl =
          'https://www.youtube-nocookie.com/embed/${toYtId(widget.videoUrl)}?modestbranding=1&controls=1&fs=0&autoplay=1&rel=0&iv_load_policy=3&cc_load_policy=1';
    });
    print(_embedUrl);
    landscape;
  }

  String? toYtId(String url) {
    if (url.contains('https://www.youtube.com/watch?v='))
      return url.substring(32, 43);
    if (url.contains('https://m.youtube.com/watch?v='))
      return url.substring(30, 41);
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
                initialUrlRequest: URLRequest(url: Uri.parse(_embedUrl)),
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
