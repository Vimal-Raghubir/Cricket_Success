import 'package:flutter/material.dart';
import 'package:cricket_app/administration/statisticManagement.dart';
import 'package:cricket_app/header/header.dart';

//Used to handle the tutorial page
class StatisticDetails extends StatefulWidget {
  //Stores passed in goal information in goal variable
  final statistic;

  const StatisticDetails({Key key, this.statistic}) : super(key: key);

  _StatisticDetailsState createState() => _StatisticDetailsState();
}

class _StatisticDetailsState extends State<StatisticDetails> {
  //Will return the goal id
  getId() {
    //This stores the passed in goal's id from the goals.dart page
    return widget.statistic.id;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () {
          FocusScopeNode currentFocus = FocusScope.of(context);
          if (!currentFocus.hasPrimaryFocus) {
            currentFocus.unfocus();
          }
        },
        child: Scaffold(
            //This helps to avoid page overflow issues
            resizeToAvoidBottomPadding: false,
            body: Column(
              children: <Widget>[
                Header().createHeader(context, 9),
                Container(
                  //Create a form using dialogBox.dart implementation but not a dialog box.
                  child: StatisticManagement(
                      notifyParent: getId,
                      passedStatistic: widget.statistic,
                      type: "detail"),
                )
              ],
            )));
  }
}
