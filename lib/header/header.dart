import 'package:flutter/material.dart';

class Header {
  double width;
  var pageTitles = ["Main Page", "My Goals", "Tutorials", "Journal"];
  var pageColors = [Colors.amber, Colors.deepOrange, Colors.deepPurple, Colors.lightGreenAccent[700]];

Widget createHeader(BuildContext context, int pageIndex) {
    var width = MediaQuery.of(context).size.width;
    return ClipRRect(
      borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(50), bottomRight: Radius.circular(50)),
      child: Container(
          height: 120,
          width: width,
          decoration: BoxDecoration(
             color: pageColors[pageIndex],    //LightColor.orange
          ),
          child: Stack(
            fit: StackFit.expand,
            alignment: Alignment.center,
            children: <Widget>[
              Positioned(
                  top: 10,
                  right: -120,
                  child: _circularContainer(300, pageColors[pageIndex])),    //LightColor.lightOrange2
              Positioned(
                  top: -60,
                  left: -65,
                  child: _circularContainer(width * .5, pageColors[pageIndex])),     //LightColor.darkOrange
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
                          Align(
                              alignment: Alignment.center,
                              child: Text(
                                pageTitles[pageIndex],
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 30,
                                    fontWeight: FontWeight.w500),
                              ))
                        ],
                      ))),
            ],
          )),
    );
  }

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