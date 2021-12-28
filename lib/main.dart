import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:provider/provider.dart';
import 'model/appSetting.dart';
import 'model/appSharePreference.dart';
import 'widget/endDrawer.dart';
import 'screen/youtubeWeb_screen.dart';

void main(List<String> args) async {
  WidgetsFlutterBinding.ensureInitialized();
  if (Platform.isAndroid) {
    await AndroidInAppWebViewController.setWebContentsDebuggingEnabled(false);
  }
  await SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitDown, DeviceOrientation.portraitUp]);
  await AppSharePreference.init();
  runApp(ChangeNotifierProvider<AppSetting>.value(
      value: AppSetting(), builder: (builder, child) => const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: Provider.of<AppSetting>(context).isDarkMode
            ? AppTheme.dark
            : AppTheme.light,
        title: 'YouTube Buddy',
        home: const HomeScreen());
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
        endDrawer: EndDrawer(),
        body: SafeArea(top: true, child: YouTubeWebScreen()));
  }
}
