import 'package:flutter/material.dart';
import 'package:cricket_app/administration/statisticManagement.dart';
import 'package:cricket_app/header/header.dart';

//Used to handle the tutorial page
class NewStatistic extends StatefulWidget {

  //Stores passed in goal information in goal variable
  final statistic;

  const NewStatistic({Key key, this.statistic}) : super(key: key);
  
  _NewStatisticState createState() => _NewStatisticState();
}

class _NewStatisticState extends State<NewStatistic> {

  refresh() {
    if (this.mounted) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //This helps to avoid page overflow issues
      resizeToAvoidBottomPadding: false,
      body: Column(
        children: <Widget>[
          Header().createHeader(context, 8),
          Container(
            //Create a form using dialogBox.dart implementation but not a dialog box.
            child: StatisticManagement(notifyParent: refresh, passedStatistic: widget.statistic, type: "new"),
          )
        ],)
      
    );
  }
}