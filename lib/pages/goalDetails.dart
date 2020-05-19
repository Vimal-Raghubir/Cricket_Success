import 'package:flutter/material.dart';
import 'package:cricket_app/administration/goalManagement.dart';
import 'package:cricket_app/header/header.dart';

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
    return widget.goal.id;
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
                Header().createHeader(context, 3),
                Container(
                  //Create a form using dialogBox.dart implementation but not a dialog box.
                  child: GoalManagement(
                      notifyParent: getId,
                      passedGoal: widget.goal,
                      type: "detail"),
                )
              ],
            )));
  }
}
