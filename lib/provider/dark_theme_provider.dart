import 'package:flutter/material.dart';
import 'package:grand_store_app/sevices/dark_theme_prefs.dart';

class DarkThemeProvider with ChangeNotifier {
  DarkThemePref darkThemePref = DarkThemePref();
  bool _darkTheme = false;

  bool get getDarkTheme => _darkTheme;

  set setDarkTheme(bool value) {
    _darkTheme = value;
    darkThemePref.setDarkTheme(value);
    notifyListeners();
  }
}