import 'package:cricket_app/main.dart';
import 'package:cricket_app/pages/settings.dart';
import 'package:cricket_app/pages/tutorials.dart';
import 'package:cricket_app/pages/statistics.dart';
import 'package:cricket_app/pages/goals.dart';
import 'package:flutter/material.dart';
import 'package:cricket_app/pages/journals.dart';

//Used to generate the bottom navigation portion
class BottomNavigation {
  int _selectedIndex;
  BuildContext temp;

  //Used to navigate to respective pages based on the option selected
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
          MaterialPageRoute(builder: (context) => Journal()),
        );
      } else if (index == 3) {
        Navigator.push(
          temp,
          MaterialPageRoute(builder: (context) => Tutorials()),
        );
      } else if (index == 4) {
        Navigator.push(
          temp,
          MaterialPageRoute(builder: (context) => Statistics()),
        );
      } else if (index == 5) {
        Navigator.push(
          temp,
          MaterialPageRoute(builder: (context) => Settings()),
        );
      }
    }

    _selectedIndex = index;
  }

  //Widget used to generate the buttom navigation bar itself
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
      //The options in the navigation bar can be modified below
      items: const <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.star),
          label: 'Goals',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.book),
          label: 'Journal',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.school),
          label: 'Tutorials',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.equalizer),
          label: 'Statistics',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.settings),
          label: 'Settings',
        )
      ],
      onTap: _onItemTapped,
    );
  }
}
