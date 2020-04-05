import 'package:flutter/material.dart';
import 'package:cricket_app/navigation/bottom_navigation.dart';
import 'package:cricket_app/header/header.dart';


//Used to handle the tutorial page
class Statistics extends StatefulWidget {
  _StatisticsState createState() => _StatisticsState();
}

class _StatisticsState extends State<Statistics> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: Bottom_Navigation().createBottomNavigation(context, 4),
      body: Column(
        children: <Widget> [
          Header().createHeader(context, 8),
          Container(
            padding: const EdgeInsets.all(32),
            child: Text(
              'Please see below!',
              softWrap: true,
            ),
          )
        ]
      ),
    );
  }
}