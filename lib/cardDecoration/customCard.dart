import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:cricket_app/classes/goalInformation.dart';
import 'package:cricket_app/classes/journalInformation.dart';

class CustomCard extends StatefulWidget {

  final object;
  final width;
  final type;

  const CustomCard({Key key, this.object, this.width, this.type}) : super(key: key);

    _MyCustomCardState createState() => new _MyCustomCardState();
}

class _MyCustomCardState extends State<CustomCard> {
  double width;
  var progress;
  var viewProgress;
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
  Widget _decorationContainerA(Color primaryColor, double top, double left) {
    return Stack(
      children: <Widget>[
        //This is used to render the process.png image instead of previous card decoration
        Positioned(
          top: 0,
          bottom: 0,
          right: 0,
          left: 0,
          child: Image.asset('assets/images/non-colored/process.png'),
        ),
      ],
    );
  }

  //Used to render the Performance goal card
  Widget _decorationContainerB() {
    return Stack(
      children: <Widget>[
        //This is used to render the performance.png image instead of previous card decoration
        Positioned(
          top: 0,
          bottom: 0,
          right: 0,
          left: 0,
          child: Image.asset('assets/images/non-colored/performance.png'),
        ),
      ],
    );
  }

    //Used to render the Outcome Goal card
    Widget _decorationContainerC() {
    return Stack(
      children: <Widget>[
        //This is used to render the outcome.jpg image instead of previous card decoration
        Positioned(
          top: 0,
          bottom: 0,
          right: 0,
          left: 0,
          child: Image.asset('assets/images/non-colored/outcome.jpg'),
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
  Widget createCustomGoalCard() {

    //Get the progress stored in the object and then multiply by 100 for viewing
    progress = widget.object.getProgress();
    viewProgress = (progress * 100).round();
    viewProgress = viewProgress.toString();
    viewProgress += "%";
    width = widget.width;
    return Container(
        height: 170,
        width: width - 20,
        child: Row(
          children: <Widget>[
            AspectRatio(
              aspectRatio: .7,
              child: _card(primaryColor: backgroundColors[widget.object.typeIndex], backWidget: getDecoration(widget.object.typeIndex)),
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
                        child: Text(widget.object.name,
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 16,
                                fontWeight: FontWeight.bold)),
                      ),
                      CircleAvatar(
                        radius: 3,
                        backgroundColor: backgroundColors[widget.object.typeIndex],
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      Text(widget.object.length.toString() + " days",
                          style: TextStyle(
                            color: Colors.grey,
                            fontSize: 14,
                          )),
                      SizedBox(width: 10)
                    ],
                  ),
                ),
                SizedBox(height: 15),
                Text(widget.object.description,
                    style: TextStyle(fontSize: 14).copyWith(
                        fontSize: 12, color: Colors.black)),
                SizedBox(height: 15),

                //Putting progress text field
                Text("Current Progress",
                  style: TextStyle(fontSize: 14).copyWith(
                  fontSize: 12, color: Colors.black)),
                SizedBox(height: 5),

                //Progress bar
                LinearPercentIndicator(
                  width: 250.0,
                  lineHeight: 15.0,
                  progressColor: Colors.blue,
                  percent: progress,
                  center: Text("$viewProgress"),
                  animation: true,
                ),
                
                SizedBox(height: 15),
                Row(
                  children: <Widget>[
                    _chip(widget.object.type, goalTypeColors[widget.object.typeIndex], height: 5),
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

  //Used to create the display for all the journal information itself
  Widget createCustomJournalCard() {
    var journalDate = DateTime.parse(widget.object.date);
    var formatter = new DateFormat('MMMM dd,yyyy');
    String formatted = formatter.format(journalDate);

    width = widget.width;
    return Container(
        height: 170,
        width: width - 20,
        child: Row(
          children: <Widget>[
            AspectRatio(
              aspectRatio: .7,
              child: _card(primaryColor: Colors.blue, backWidget: _decorationContainerJournal()),
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
                        child: Text(widget.object.name,
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 16,
                                fontWeight: FontWeight.bold)),
                      ),
                      CircleAvatar(
                        radius: 3,
                        backgroundColor: Colors.blue,
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      Text(formatted,
                          style: TextStyle(
                            color: Colors.grey,
                            fontSize: 14,
                          )),
                      SizedBox(width: 10)
                    ],
                  ),
                ),
                SizedBox(height: 15),
                Text(widget.object.details,
                    style: TextStyle(fontSize: 14).copyWith(
                        fontSize: 12, color: Colors.black)),
                SizedBox(height: 15),
              ],
            ))
          ],
        ));
      }

          //Used to render the Outcome Goal card
    Widget _decorationContainerJournal() {
    return Stack(
      children: <Widget>[
        //This is used to render the outcome.jpg image instead of previous card decoration
        Positioned(
          top: 0,
          bottom: 0,
          right: 0,
          left: 0,
          child: Image.asset('assets/images/non-colored/outcome.jpg'),
        ),
      ],
    );
  }

  Widget build(BuildContext context) {
    setState(() {});
    if (widget.type == "goal") {
      //print("This is being called in customCard build " + widget.object.currentProgress.toString());
      return createCustomGoalCard();
    } else {
      return createCustomJournalCard();
    }
  }
}