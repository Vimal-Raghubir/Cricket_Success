import 'package:cricket_app/navigation/bottom_navigation.dart';
import 'package:cricket_app/header/header.dart';
import 'package:cricket_app/classes/quotes.dart';
import 'package:cricket_app/theme/config.dart';
import 'package:flutter/material.dart';
import 'dart:math';
import 'package:cricket_app/layout/gridTile.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

bool theme;
void main() async {
  await Hive.initFlutter();
  themeBox = await Hive.openBox('easyTheme');
  fontBox = await Hive.openBox('Fonts');
  runApp(Main());
}

class Main extends StatefulWidget {
  _MainState createState() => _MainState();
}

class _MainState extends State<Main> {
  // This widget is the root of your application.
  initState() {
    super.initState();
    currentTheme.addListener(() {
      setState(() {});
    });

    currentColor.addListener(() {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'MyCricketCompanion',
      // This is the theme of your application.
      theme: ThemeData.light(),
      darkTheme: ThemeData.dark(),
      themeMode: currentTheme.currentTheme(),
      home: MyHomePage(title: 'MyCricketCompanion'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

//This represents the content of the main page
class _MyHomePageState extends State<MyHomePage> {
  var index = 0;

  initState() {
    super.initState();
    index = 0 + Random().nextInt(quotes.length - 1);
  }

  Widget build(BuildContext context) {
    return Scaffold(
        bottomNavigationBar:
            BottomNavigation().createBottomNavigation(context, 0),
        body: new Column(
          children: <Widget>[
            Header().createHeader(context, 0),
            SizedBox(height: 15),
            RichText(
              textAlign: TextAlign.center,
              text: TextSpan(
                  text: quotes[index],
                  style: TextStyle(
                      fontStyle: FontStyle.italic,
                      color: currentColor.currentColor(),
                      fontSize: 15)),
            ),
            SizedBox(height: 20),
            Text(
              'Please select a page below that you would like to navigate to!\n',
              style: TextStyle(
                  fontStyle: FontStyle.normal,
                  color: currentColor.currentColor(),
                  fontSize: 16),
              textAlign: TextAlign.center,
            ),
            Expanded(
              child: Center(child: CustomGridTile().buildGrid(context, 1)),
            )
          ],
        ));
  }
}
