import 'package:cricket_app/main.dart';
import 'package:cricket_app/pages/tutorials.dart';
import 'package:cricket_app/pages/goals.dart';
import 'package:flutter/material.dart';
import 'package:cricket_app/pages/journal.dart';

class Bottom_Navigation {
  int _selectedIndex;
  BuildContext temp;

  void _onItemTapped(int index) {
    if (index != _selectedIndex) {
      if (index == 0) {
        Navigator.push(
          temp,
          MaterialPageRoute(builder: (context) => MyHomePage()),
        );
      } else if (index == 1) {
        Navigator.push(
          temp,
          MaterialPageRoute(builder: (context) => Goals()),
        );
      } else if (index == 2) {
        Navigator.push(
          temp,
          MaterialPageRoute(builder: (context) => Tutorials()),
        );
      } else if (index == 3) {
        Navigator.push(
          temp,
          MaterialPageRoute(builder: (context) => Journal()),
        );
      }
    }

    _selectedIndex = index;
}

  Widget createBottomNavigation(BuildContext context, int currentIndex) {
    temp = context;
    _selectedIndex = currentIndex;
    return BottomNavigationBar(
      showSelectedLabels: false,
      showUnselectedLabels: false,
      selectedItemColor: Colors.lightBlue,
      unselectedItemColor: Colors.grey.shade300,
      type: BottomNavigationBarType.fixed,
      currentIndex: _selectedIndex,
      items: const <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          title: Text('Home'),
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.star),
          title: Text('Goals'),
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.school),
          title: Text('School'),
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.book),
          title: Text('Journal'),
        ),
      ],
      onTap: _onItemTapped,
    );
  }
}