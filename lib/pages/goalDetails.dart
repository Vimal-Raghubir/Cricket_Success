import 'package:flutter/material.dart';
import 'package:cricket_app/dialogBox/dialogBox.dart';
import 'package:cricket_app/database/database.dart';

//Used to handle the tutorial page
class GoalDetails extends StatefulWidget {

  //Stores passed in goal information in goal variable
  final goal;

  const GoalDetails({Key key, this.goal}) : super(key: key);
  
  _GoalDetailState createState() => _GoalDetailState();
}

class _GoalDetailState extends State<GoalDetails> {
  //Will return the goal id
  getId() {
    //This stores the passed in goal's id from the goals.dart page
    print(widget.goal.id);
    return widget.goal.id;
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

  _deleteGoal() async {
    DatabaseHelper helper = DatabaseHelper.instance;
    await helper.deleteGoal(9);
  }
}