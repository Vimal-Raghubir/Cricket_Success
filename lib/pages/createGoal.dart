import 'package:flutter/material.dart';
import 'package:cricket_app/administration/goalManagement.dart';

//Used to handle the tutorial page
class NewGoal extends StatefulWidget {

  //Stores passed in goal information in goal variable
  final goal;

  const NewGoal({Key key, this.goal}) : super(key: key);
  
  _NewGoalState createState() => _NewGoalState();
}

class _NewGoalState extends State<NewGoal> {

  refresh() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //Appbar is needed for drawer and back button
      appBar: AppBar(backgroundColor: Colors.lime, title: Text("                 New Goal")),
      //This helps to avoid page overflow issues
      resizeToAvoidBottomPadding: false,
      body: Container(
        //Create a form using dialogBox.dart implementation but not a dialog box.
        child: GoalManagement(notifyParent: refresh, passedGoal: widget.goal, type: "new"),
      )
    );
  }
}