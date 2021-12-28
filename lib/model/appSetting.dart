import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'appSharePreference.dart';

class AppSetting extends ChangeNotifier {
  late bool _isDarkMode;
  late bool _clearCache;
  late bool _isAdsEnable;
  late bool _incognito;
  InAppWebViewController? webController;

  bool get getClearCache => _clearCache;
  bool get isAdsEnable => _isAdsEnable;
  bool get incognito => _incognito;
  bool get isDarkMode => _isDarkMode;

  InAppWebViewGroupOptions get webOptions => InAppWebViewGroupOptions(
      crossPlatform: InAppWebViewOptions(
        useShouldOverrideUrlLoading: true,
        incognito: true,
        clearCache: getClearCache,
        supportZoom: false,
      ),
      android: AndroidInAppWebViewOptions(
        displayZoomControls: false,
        builtInZoomControls: false,
        forceDark: _isDarkMode
            ? AndroidForceDark.FORCE_DARK_ON
            : AndroidForceDark.FORCE_DARK_OFF,
      ));

  AppSetting() {
    _isDarkMode = AppSharePreference.getIsDarkMode;
    _clearCache = AppSharePreference.getClearCache;
    _isAdsEnable = AppSharePreference.getIsAds;
    _incognito = AppSharePreference.getIncognito;
    notifyListeners();
  }
  adsSwitch() {
    _isAdsEnable = !_isAdsEnable;
    AppSharePreference.setIsAds(_isAdsEnable);
    notifyListeners();
  }

  incognitoSwitch() {
    _incognito = !_incognito;
    AppSharePreference.setIncognito(_incognito);
    webController!.setOptions(options: webOptions);
    notifyListeners();
  }

  clearCacheSwitch() {
    _clearCache = !_clearCache;
    AppSharePreference.setClearCache(_clearCache);
    webController!.setOptions(options: webOptions);
    notifyListeners();
  }

  themeSwitch() {
    _isDarkMode = !_isDarkMode;
    AppSharePreference.setIsDarkMode(_isDarkMode);
    webController!.setOptions(options: webOptions);
    notifyListeners();
  }
}

abstract class AppTheme {
  static ThemeData light = ThemeData(
      primarySwatch: Colors.red,
      canvasColor: Colors.white,
      iconTheme: const IconThemeData(color: Colors.black),
      hintColor: Colors.black54,
      textTheme: const TextTheme(bodyText1: TextStyle(color: Colors.black)));
  static ThemeData dark = ThemeData(
      primarySwatch: Colors.red,
      canvasColor: const Color(0xff121212),
      iconTheme: const IconThemeData(color: Colors.white),
      hintColor: Colors.white70,
      textTheme: const TextTheme(bodyText1: TextStyle(color: Colors.white)));
}
