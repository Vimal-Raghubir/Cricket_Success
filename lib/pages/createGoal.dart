import 'package:flutter/material.dart';
import 'package:cricket_app/administration/goalManagement.dart';
import 'package:cricket_app/header/header.dart';

//Used to handle the tutorial page
class NewGoal extends StatefulWidget {

  //Stores passed in goal information in goal variable
  final goal;

  const NewGoal({Key key, this.goal}) : super(key: key);
  
  _NewGoalState createState() => _NewGoalState();
}

class _NewGoalState extends State<NewGoal> {

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
          Header().createHeader(context, 2),
          Container(
            //Create a form using dialogBox.dart implementation but not a dialog box.
            child: GoalManagement(notifyParent: refresh, passedGoal: widget.goal, type: "new"),
          )
        ],)
      
    );
  }
}