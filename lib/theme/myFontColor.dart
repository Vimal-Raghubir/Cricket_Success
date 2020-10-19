import 'package:cricket_app/theme/config.dart';
import 'package:flutter/material.dart';

class MyFontColor with ChangeNotifier {
  static bool _bright = true;

  MyFontColor() {
    if (fontBox.containsKey('currentFont')) {
      _bright = fontBox.get('currentFont');
    } else {
      fontBox.put('currentFont', _bright);
    }
  }

  Color currentColor() {
    return _bright ? Colors.white : Colors.black;
  }

  void switchColor() {
    _bright = !_bright;
    fontBox.put('currentFont', _bright);
    notifyListeners();
  }
}
