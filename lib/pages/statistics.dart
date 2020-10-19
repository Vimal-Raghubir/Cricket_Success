import 'package:cricket_app/statisticsTabs/FieldingTab.dart';
import 'package:cricket_app/statisticsTabs/battingTab.dart';
import 'package:cricket_app/statisticsTabs/bowlingTab.dart';
import 'package:cricket_app/theme/config.dart';
import 'package:flutter/material.dart';
import 'package:cricket_app/navigation/bottom_navigation.dart';
import 'package:cricket_app/classes/statistics.dart';

//Stores all the statistics in the database
List<StatisticInformation> statistics = [];

//Used to handle the tutorial page
class Statistics extends StatefulWidget {
  _StatisticsState createState() => _StatisticsState();
}

class _StatisticsState extends State<Statistics> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    currentTheme.addListener(() {
      setState(() {});
    });

    currentColor.addListener(() {
      setState(() {});
    });
  }

  var width;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.light(),
      darkTheme: ThemeData.dark(),
      themeMode: currentTheme.currentTheme(),
      home: DefaultTabController(
        length: 3,
        child: Scaffold(
          bottomNavigationBar:
              BottomNavigation().createBottomNavigation(context, 4),
          appBar: AppBar(
            bottom: TabBar(
              tabs: [
                Tab(
                    icon: Image.asset('assets/images/statistics/bat.png',
                        width: 35,
                        height: 35,
                        color: currentColor.currentColor()),
                    text: "Batting"),
                Tab(
                    icon: Image.asset(
                      'assets/images/statistics/ball.png',
                      width: 35,
                      height: 35,
                      color: currentColor.currentColor(),
                    ),
                    text: "Bowling"),
                Tab(
                    icon: Image.asset('assets/images/statistics/fielding.png',
                        width: 35,
                        height: 35,
                        color: currentColor.currentColor()),
                    text: "Fielding"),
              ],
            ),
            title: Text("Statistics"),
          ),
          body: TabBarView(
            children: [
              BattingTab(),
              BowlingTab(),
              FieldingTab(),
            ],
          ),
        ),
      ),
    );
  }
}
