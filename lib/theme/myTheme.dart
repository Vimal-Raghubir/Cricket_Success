import 'package:cricket_app/theme/config.dart';
import 'package:flutter/material.dart';

class MyTheme with ChangeNotifier {
  static bool _isDark = true;

  MyTheme() {
    if (themeBox.containsKey('currentTheme')) {
      _isDark = themeBox.get('currentTheme');
    } else {
      themeBox.put('currentTheme', _isDark);
    }
  }
  ThemeMode currentTheme() {
    return _isDark ? ThemeMode.dark : ThemeMode.light;
  }

  void switchTheme() {
    _isDark = !_isDark;
    themeBox.put('currentTheme', _isDark);
    notifyListeners();
  }
}
