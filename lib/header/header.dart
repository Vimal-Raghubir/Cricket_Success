import 'package:flutter/material.dart';

class Header {
  double width;

  //Various page titles
  var pageTitles = ["Main Page", "My Goals", "New Goal", "Update Goal", "Tutorials", "My Journals", "New Journal", "Update Journal", "Add Match Stats", "Update Match Stats", "Bowling Tutorials", "Batting Tutorials", "Fielding Skills", "Mental Training", "Physical Training"];
  //Colors corresponding to page titles
  var pageColors = [Colors.amber, Colors.deepOrange, Colors.lime, Colors.cyan, Colors.deepPurple, Colors.lightGreenAccent[700], Colors.greenAccent[700], Colors.pink, Colors.teal, Colors.red, Colors.blueGrey, Colors.pink, Colors.cyanAccent[700], Colors.greenAccent[400], Colors.redAccent[700]];

//Widget used to create the styled header for each page
Widget createHeader(BuildContext context, int pageIndex) {
    var width = MediaQuery.of(context).size.width;
    return ClipRRect(
      borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(50), bottomRight: Radius.circular(50)),
      child: Container(
          height: 120,
          width: width,
          decoration: BoxDecoration(
             color: pageColors[pageIndex],
          ),
          child: Stack(
            fit: StackFit.expand,
            alignment: Alignment.center,
            children: <Widget>[
              Positioned(
                  top: 10,
                  right: -120,
                  child: _circularContainer(300, pageColors[pageIndex])),
              Positioned(
                  top: -60,
                  left: -65,
                  child: _circularContainer(width * .5, pageColors[pageIndex])),
              Positioned(
                  top: -230,
                  right: -30,
                  child: _circularContainer(width * .7, Colors.transparent,
                      borderColor: Colors.white38)),
              Positioned(
                  top: 50,
                  left: 0,
                  child: Container(
                      width: width,
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      child: Stack(
                        children: <Widget>[
                          Center(
                              //alignment: Alignment.center,
                              child: Text(
                                //Here is where the title is placed
                                pageTitles[pageIndex],
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 30,
                                    fontWeight: FontWeight.w500),
                              ))
                        ],
                      ))),

              Positioned(
                child: IconButton(
                  icon: const BackButtonIcon(),
                  color: Colors.black,
                  tooltip: MaterialLocalizations.of(context).backButtonTooltip,
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
                left: 0,
                right: width - 55,
                top: 42,
              ),
            ],
          )),
    );
  }

    //This is used to create the circular style of the header
    Widget _circularContainer(double height, Color color, {Color borderColor = Colors.transparent, double borderWidth = 2}) {
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
}