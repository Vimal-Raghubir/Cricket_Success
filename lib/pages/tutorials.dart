import 'package:flutter/material.dart';
import 'package:cricket_app/navigation/bottom_navigation.dart';
import 'package:cricket_app/header/header.dart';
import 'package:cricket_app/layout/gridTile.dart';


//Used to handle the tutorial page
class Tutorials extends StatelessWidget {
  var width;
  var height;
  static final showGrid = true; // Set to false to show ListView

  @override
  Widget build(BuildContext context) {
    width = MediaQuery.of(context).size.width;
    height = MediaQuery.of(context).size.height;
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      bottomNavigationBar: BottomNavigation().createBottomNavigation(context, 3),
      body: Column(
        children: <Widget>[
          Header().createHeader(context, 4),
          SizedBox(height: 10),
          Expanded(
            child:
              Center(child: CustomGridTile().buildGrid(context, 0)),
          )
        ],
      )
    );
  }



}



