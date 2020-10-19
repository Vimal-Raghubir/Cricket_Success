import 'package:cricket_app/theme/config.dart';
import 'package:flutter/material.dart';

class CustomStatisticCard extends StatefulWidget {
  final object;
  final width;
  final type;

  const CustomStatisticCard({Key key, this.object, this.width, this.type})
      : super(key: key);

  _MyCustomStatisticCardState createState() =>
      new _MyCustomStatisticCardState();
}

class _MyCustomStatisticCardState extends State<CustomStatisticCard> {
  double width;

  //background colors corresponding to goal types
  var backgroundColors = [Colors.red, Colors.yellow[700], Colors.green];

  //Card is the colorful display next to the journal information
  Widget _card(
      {Color primaryColor = Colors.redAccent,
      String imgPath,
      Widget backWidget}) {
    return Container(
        height: 190,
        width: widget.width * .34,
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

  String generateCardMessage() {
    String cardText = "";
    if (widget.type == 0) {
      if (widget.object.ballsFaced == 0) {
        cardText = "You did not bat in this game.";
      } else {
        cardText = "Runs: " +
            widget.object.runs.toString() +
            "\n\nBalls Faced: " +
            widget.object.ballsFaced.toString() +
            "\n\nNot out: ";
        cardText += widget.object.notOut == 0 ? "no" : "yes";
      }
    } else if (widget.type == 1) {
      if (widget.object.overs == 0) {
        cardText = "You did not bowl in this game.";
      } else {
        cardText = "Overs bowled: " +
            widget.object.overs.toString() +
            "\n\nRuns Conceeded: " +
            widget.object.runsConceeded.toString() +
            "\n\nWickets: " +
            widget.object.wickets.toString();
      }
    } else if (widget.type == 2) {
      if (widget.object.catches == 0 &&
          widget.object.runOuts == 0 &&
          widget.object.stumpings == 0) {
        cardText = "You did not get any fielding dismissals in this game.";
      } else {
        cardText = "Catches: " +
            widget.object.catches.toString() +
            "\t\t\t\t\t\t\tDropped Catches: " +
            widget.object.catchesMissed.toString() +
            "\n\nRun Outs: " +
            widget.object.runOuts.toString() +
            "\t\t\t\t\tMissed Run Outs: " +
            widget.object.runOutsMissed.toString() +
            "\n\nStumpings: " +
            widget.object.stumpings.toString() +
            "\t\tMissed Stumpings: " +
            widget.object.stumpingsMissed.toString();
      }
    }
    return cardText;
  }

  //Used to create the display for all the journal information itself
  Widget createCustomStatisticCard() {
    width = widget.width;
    var namePreview = widget.object.name;

    // This will generate a preview of the name to allow longer names
    if (widget.object.name.length > 25) {
      namePreview = widget.object.name.substring(0, 22);
      namePreview += "...";
    }

    var cardColor = currentColor.currentColor() == Colors.black
        ? Colors.white
        : Colors.grey[800];

    return Container(
        height: 170,
        width: width - 20,
        decoration: BoxDecoration(
            border:
                Border(bottom: BorderSide(color: currentColor.currentColor()))),
        child: Row(
          children: <Widget>[
            AspectRatio(
              aspectRatio: .7,
              child: _card(
                  primaryColor: backgroundColors[widget.type],
                  backWidget: _decorationContainer(widget.type)),
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
                        child: Text(namePreview,
                            style: TextStyle(
                                color: currentColor.currentColor(),
                                fontSize: 16,
                                fontWeight: FontWeight.bold)),
                      ),
                      CircleAvatar(
                        radius: 3,
                        backgroundColor: backgroundColors[widget.type],
                      ),
                      SizedBox(
                        width: 5,
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 15),
                Expanded(
                  child: Text(generateCardMessage(),
                      style: TextStyle(fontSize: 14).copyWith(
                          fontSize: 14, color: currentColor.currentColor())),
                ),
                SizedBox(height: 15),
              ],
            ))
          ],
        ));
  }

  //Used to render the Statistic cards
  Widget _decorationContainer(int index) {
    String image = 'assets/images/statistics/bat.png';
    switch (index) {
      case 0:
        {
          image = 'assets/images/statistics/bat.png';
        }
        break;
      case 1:
        {
          image = 'assets/images/statistics/ball.png';
        }
        break;
      case 2:
        {
          image = 'assets/images/statistics/fielding.png';
        }
        break;
    }

    return Stack(
      children: <Widget>[
        //This is used to render the process.png image instead of previous card decoration
        Positioned(
          top: 0,
          bottom: 0,
          right: 0,
          left: 0,
          child: Image.asset(image),
        ),
      ],
    );
  }

  Widget build(BuildContext context) {
    if (this.mounted) {
      setState(() {});
    }
    return createCustomStatisticCard();
  }
}
