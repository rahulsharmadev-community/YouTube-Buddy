// ignore_for_file: file_names
import 'package:shared_preferences/shared_preferences.dart';

class AppSharePreference {
  static late SharedPreferences _preferences;
  static const _preferencesIsDarkMode = 'IsDarkMode';
  static const _preferencesClearCache = 'ClearCache';
  static const _preferencesIsAdsEnable = 'IsAdsEnable';
  static const _preferencesIncognito = 'Incognito';
  static init() async {
    _preferences = await SharedPreferences.getInstance();
  }

  static Future<void> setIsDarkMode(bool value) async =>
      await _preferences.setBool(_preferencesIsDarkMode, value);

  static Future<void> setClearCache(bool value) async =>
      await _preferences.setBool(_preferencesClearCache, value);

  static Future<void> setIsAds(bool value) async =>
      await _preferences.setBool(_preferencesIsAdsEnable, value);

  static Future<void> setIncognito(bool value) async =>
      await _preferences.setBool(_preferencesIncognito, value);

  static bool get getIsDarkMode =>
      _preferences.getBool(_preferencesIsDarkMode) ?? false;

  static bool get getClearCache =>
      _preferences.getBool(_preferencesClearCache) ?? false;

  static bool get getIsAds =>
      _preferences.getBool(_preferencesIsAdsEnable) ?? false;

  static bool get getIncognito =>
      _preferences.getBool(_preferencesIncognito) ?? false;
}
