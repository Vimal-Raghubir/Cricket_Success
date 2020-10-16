import 'package:cricket_app/theme/config.dart';
import 'package:flutter/material.dart';
import 'package:cricket_app/navigation/bottom_navigation.dart';
import 'package:cricket_app/header/header.dart';

bool _light;

//Used to handle the tutorial page
class Settings extends StatefulWidget {
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  double width;

  initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _light = convertTheme();
    width = MediaQuery.of(context).size.width;
    return Scaffold(
      bottomNavigationBar:
          BottomNavigation().createBottomNavigation(context, 5),
      body: Column(children: <Widget>[
        Header().createHeader(context, 16),
        Text(
          'Select your theme',
          textAlign: TextAlign.left,
          softWrap: true,
        ),
        Switch(
            value: _light,
            onChanged: (toggle) {
              setState(() {
                if (_light != toggle) {
                  currentTheme.switchTheme();
                  _light = toggle;
                }
              });
            }),
      ]),
    );
  }

  convertTheme() {
    return currentTheme.currentTheme() == ThemeMode.dark ? true : false;
  }
}
