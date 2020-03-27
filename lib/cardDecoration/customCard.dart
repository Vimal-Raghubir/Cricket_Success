import 'package:flutter/material.dart';
import 'package:cricket_app/pages/goals.dart';
import 'package:cricket_app/cardDecoration/quad_clipper.dart';

class CustomCard {
  double width;
  //Colors for the different goal types
  var goalTypeColors = [Colors.blue, Colors.teal, Colors.deepOrange];
  //background colors corresponding to goal types
  var backgroundColors = [Colors.cyan[400], Colors.tealAccent[700], Colors.deepOrange[400]];

  //Chip is for the goal type display circle
  Widget _chip(String text, Color textColor,{double height = 0, bool isPrimaryCard = false}) {
    return Container(
      alignment: Alignment.center,
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: height),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(15)),
        color: textColor.withAlpha(isPrimaryCard ? 200 : 50),
      ),
      child: Text(
        text,
        style: TextStyle(
            color: isPrimaryCard ? Colors.white : textColor, fontSize: 12),
      ),
    );
  }

  //Card is the colorful display next to the goal information
  Widget _card({Color primaryColor = Colors.redAccent,String imgPath,Widget backWidget}) {
    return Container(
        height: 190,
        width: width * .34,
        margin: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        decoration: BoxDecoration(
            color: primaryColor,
            borderRadius: BorderRadius.all(Radius.circular(20)),
            boxShadow: <BoxShadow>[
              BoxShadow(
                  offset: Offset(0, 5),
                  blurRadius: 10,
                  color: Color(0x12000000))
            ]),
        child: ClipRRect(
          borderRadius: BorderRadius.all(Radius.circular(20)),
          child: backWidget,
        ));
  }

  //Small container is used to build the card
  Positioned _smallContainer(Color primaryColor, double top, double left,{double radius = 10}) {
      return Positioned(
        top: top,
        left: left,
        child: CircleAvatar(
          radius: radius,
          backgroundColor: primaryColor.withAlpha(255),
        ));
  }

  //Also used to build the card
  Widget _circularContainer(double height, Color color,{Color borderColor = Colors.transparent, double borderWidth = 2}) {
      return Container(
        height: height,
        width: height,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: color,
          border: Border.all(color: borderColor, width: borderWidth),
        ),
      );
  }

  //Used to render the Process Goal card
  Widget _decorationContainerA(Color primaryColor, double top, double left) {
    return Stack(
      children: <Widget>[
        Positioned(
          top: top,
          left: left,
          child: CircleAvatar(
            radius: 100,
            backgroundColor: Colors.cyan[600],
          ),
        ),
        _smallContainer(Colors.orange, 40, 20),
        Positioned(
          top: -30,
          right: -10,
          child: _circularContainer(80, Colors.transparent,
              borderColor: Colors.white),
        ),
        Positioned(
          top: 110,
          right: -50,
          child: CircleAvatar(
            radius: 60,
            backgroundColor: Colors.cyan[600],
            child:
                CircleAvatar(radius: 40, backgroundColor: Colors.cyan[400]),
          ),
        ),
      ],
    );
  }

  //Used to render the Performance goal card
  Widget _decorationContainerB() {
    return Stack(
      children: <Widget>[
        Positioned(
          top: -65,
          left: -65,
          child: CircleAvatar(
            radius: 70,
            backgroundColor: Colors.orange[300],
            child: CircleAvatar(
                radius: 30, backgroundColor: Colors.tealAccent[700]),
          ),
        ),
        Positioned(
            bottom: -35,
            right: -40,
            child:
                CircleAvatar(backgroundColor: Colors.yellow, radius: 40)),
        Positioned(
          top: 50,
          left: -40,
          child: _circularContainer(70, Colors.transparent,
              borderColor: Colors.white),
        ),
      ],
    );
  }

    //Used to render the Outcome Goal card
    Widget _decorationContainerC() {
    return Stack(
      children: <Widget>[
        Positioned(
          bottom: -65,
          left: -35,
          child: CircleAvatar(
            radius: 70,
            backgroundColor: Color(0xfffeeaea),
          ),
        ),
        Positioned(
            bottom: -30,
            right: -25,
            child: ClipRect(
                clipper: QuadClipper(),
                child: CircleAvatar(
                    backgroundColor: Colors.orange, radius: 40))),
        _smallContainer(
          Colors.yellow,
          35,
          70,
        ),
      ],
    );
  }

  //Used to determine the appropriate card for the specific goal type
  Widget getDecoration(int index) {
    switch (index) {
      case 0: return _decorationContainerA(Colors.redAccent, -110, -85);
      break;
      case 1: return _decorationContainerB();
      break;
      case 2: return _decorationContainerC();
    }
  }

  //Used to create the display for all the goal information itself
  Widget createCustomCard(GoalInformation goal, double screenWidth) {
    width = screenWidth;
    return Container(
        height: 170,
        width: width - 20,
        child: Row(
          children: <Widget>[
            AspectRatio(
              aspectRatio: .7,
              child: _card(primaryColor: backgroundColors[goal.typeIndex], backWidget: getDecoration(goal.typeIndex)),
            ),
            Expanded(
                child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                SizedBox(height: 15),
                Container(
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    children: <Widget>[
                      Expanded(
                        child: Text(goal.name,
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 16,
                                fontWeight: FontWeight.bold)),
                      ),
                      CircleAvatar(
                        radius: 3,
                        backgroundColor: backgroundColors[goal.typeIndex],
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      Text(goal.length.toString() + " days",
                          style: TextStyle(
                            color: Colors.grey,
                            fontSize: 14,
                          )),
                      SizedBox(width: 10)
                    ],
                  ),
                ),
                SizedBox(height: 15),
                Text(goal.description,
                    style: TextStyle(fontSize: 14).copyWith(
                        fontSize: 12, color: Colors.black)),
                SizedBox(height: 15),
                Row(
                  children: <Widget>[
                    _chip(goal.type, goalTypeColors[goal.typeIndex], height: 5),
                    SizedBox(
                      width: 10,
                    ),
                  ],
                )
              ],
            ))
          ],
        ));
      }
}