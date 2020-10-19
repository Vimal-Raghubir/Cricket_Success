import 'package:cricket_app/theme/config.dart';
import 'package:flutter/material.dart';
import 'package:percent_indicator/percent_indicator.dart';

class CustomGoalCard extends StatefulWidget {
  final object;
  final width;
  final type;

  const CustomGoalCard({Key key, this.object, this.width, this.type})
      : super(key: key);

  _MyCustomGoalCardState createState() => new _MyCustomGoalCardState();
}

class _MyCustomGoalCardState extends State<CustomGoalCard> {
  double width;
  var progress;
  var viewProgress;
  //Colors for the different goal types
  var goalTypeColors = [Colors.blue, Colors.teal, Colors.deepOrange];
  //background colors corresponding to goal types
  var backgroundColors = [
    Colors.cyan[400],
    Colors.tealAccent[700],
    Colors.deepOrange[400]
  ];

  //Chip is for the goal type display circle
  Widget _chip(String text, Color textColor,
      {double height = 0, bool isPrimaryCard = false}) {
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

  //Used to render the Process Goal card
  Widget _decorationContainer(int index) {
    String image = 'assets/images/non-colored/process.png';
    switch (index) {
      case 0:
        {
          image = 'assets/images/non-colored/process.png';
        }
        break;
      case 1:
        {
          image = 'assets/images/non-colored/performance.png';
        }
        break;
      case 2:
        {
          image = 'assets/images/non-colored/outcome.jpg';
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

  //Used to create the display for all the goal information itself
  Widget createCustomGoalCard() {
    //Get the progress stored in the object and then multiply by 100 for viewing
    progress = widget.object.getProgress();
    viewProgress = (progress * 100).round();
    viewProgress = viewProgress.toString();
    viewProgress += "%";
    width = widget.width;
    var descriptionPreview = widget.object.description;
    var namePreview = widget.object.name;

    // This will generate a preview of the description to allow longer descriptions
    if (widget.object.description.length > 35) {
      descriptionPreview = widget.object.description.substring(0, 32);
      descriptionPreview += "...";
    }

    // This will generate a preview of the name to allow longer names
    if (widget.object.name.length > 25) {
      namePreview = widget.object.name.substring(0, 22);
      namePreview += "...";
    }

    var cardColor = currentColor.currentColor() == Colors.black
        ? Colors.white
        : Colors.grey[800];

    return Container(
        decoration: BoxDecoration(
            border:
                Border(bottom: BorderSide(color: currentColor.currentColor())),
            // color of the goal box
            color: cardColor),
        height: 170,
        width: width - 20,
        child: Row(
          children: <Widget>[
            AspectRatio(
              aspectRatio: .7,
              child: _card(
                  primaryColor: backgroundColors[widget.object.typeIndex],
                  backWidget: _decorationContainer(widget.object.typeIndex)),
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
                        backgroundColor:
                            backgroundColors[widget.object.typeIndex],
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      Text(widget.object.length.toString() + " days",
                          style: TextStyle(
                            color: currentColor.currentColor(),
                            fontSize: 14,
                          )),
                      SizedBox(width: 10)
                    ],
                  ),
                ),
                SizedBox(height: 15),
                Text(descriptionPreview,
                    style: TextStyle(fontSize: 14).copyWith(
                        fontSize: 12, color: currentColor.currentColor())),
                SizedBox(height: 15),

                //Putting progress text field
                Text("Current Progress",
                    style: TextStyle(fontSize: 14).copyWith(
                        fontSize: 12, color: currentColor.currentColor())),
                SizedBox(height: 5),

                //Progress bar
                LinearPercentIndicator(
                  width: width - 120,
                  lineHeight: 15.0,
                  progressColor: Colors.blue,
                  percent: progress,
                  center: Text("$viewProgress"),
                  animation: true,
                ),

                SizedBox(height: 15),
                Row(
                  children: <Widget>[
                    _chip(widget.object.type,
                        goalTypeColors[widget.object.typeIndex],
                        height: 5),
                    SizedBox(
                      width: 10,
                    ),
                  ],
                ),
              ],
            ))
          ],
        ));
  }

  Widget build(BuildContext context) {
    if (this.mounted) {
      setState(() {});
    }
    return createCustomGoalCard();
  }
}
