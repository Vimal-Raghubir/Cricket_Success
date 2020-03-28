import 'package:flutter/material.dart';
import 'package:cricket_app/dialogBox/dialogBox.dart';

//Used to handle the tutorial page
class GoalDetails extends StatefulWidget {

  //Stores passed in goal information in goal variable
  final goal;

  //Stores passed in goal id as well
  final id;

  const GoalDetails({Key key, this.goal, this.id}) : super(key: key);
  
  _GoalDetailState createState() => _GoalDetailState();
}

class _GoalDetailState extends State<GoalDetails> {
  getId() {
    return widget.id;
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        //Create a form using dialogBox.dart implementation but not a dialog box.
        child: MyDialog(notifyParent: getId, passedGoal: widget.goal, type: "detail"),
      )
    );
  }
}