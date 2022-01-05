import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:provider/provider.dart';
import 'package:wakelock/wakelock.dart';
import 'package:youtubebuddy/screen/multiVerseScreen.dart';
import '../model/appSetting.dart';
import 'fullscreenVideo.dart';

class YouTubeWebScreen extends StatefulWidget {
  const YouTubeWebScreen({Key? key}) : super(key: key);

  @override
  _YouTubeWebScreenState createState() => _YouTubeWebScreenState();
}

class _YouTubeWebScreenState extends State<YouTubeWebScreen> {
  final Uri webDomain = Uri.parse('https://m.youtube.com/');
  bool isPlay = false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Wakelock.enable();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    Wakelock.disable();
  }

  @override
  Widget build(BuildContext context) {
    var appSetting = Provider.of<AppSetting>(context);
    return WillPopScope(
      onWillPop: () async {
        appSetting.webController != null &&
                appSetting.webController!.getUrl() != webDomain
            ? await appSetting.webController!.goBack()
            : exit(0);

        return false;
      },
      child: Stack(
        children: [
          InAppWebView(
            initialUrlRequest: URLRequest(url: webDomain),
            initialOptions: appSetting.webOptions,
            onTitleChanged: (controller, progress) async {
              var uri = (await controller.getUrl()).toString();
              if (appSetting.isAdsEnable && uri.contains('watch?v=')) {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (builder) => FullScreenVideo(uri)));
                await appSetting.webController!.goBack();
              }

              if (appSetting.isMultiVerse && uri.contains('watch?v=')) {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (builder) => MultiVerseScreen(uri)));
                await appSetting.webController!.goBack();
              }
            },
            onWebViewCreated: (onWebViewCreated) async {
              setState(() {
                appSetting.webController = onWebViewCreated;
              });
            },
            shouldOverrideUrlLoading: (controller, navigationAction) async {
              var uri = navigationAction.request.url!;

              if (!["youtube"].contains(uri.scheme)) {
                // and cancel the request
                return NavigationActionPolicy.CANCEL;
              }

              return NavigationActionPolicy.ALLOW;
            },
          ),
          Align(
            alignment: Alignment.topRight,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(15),
                    bottomRight: Radius.circular(15)),
                color: Theme.of(context).canvasColor,
              ),
              child: IconButton(
                splashRadius: double.minPositive,
                onPressed: () {
                  Scaffold.of(context).openEndDrawer();
                },
                icon: const Icon(Icons.settings),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
