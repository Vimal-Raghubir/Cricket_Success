import 'package:flutter/material.dart';
import 'package:cricket_app/navigation/bottom_navigation.dart';
import 'package:cricket_app/header/header.dart';

class Journal extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: Bottom_Navigation().createBottomNavigation(context, 3),
      body: Column(
        children: <Widget> [
          Header().createHeader(context, 3),
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