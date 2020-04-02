import 'package:flutter/material.dart';
import 'package:cricket_app/administration/goalDialog.dart';
import 'package:cricket_app/database/database.dart';
import 'package:cricket_app/pages/goals.dart';
import 'package:cricket_app/classes/goalInformation.dart';
import 'package:toast/toast.dart';

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


  //Alert box to confirm deletion of a goal
  void confirmDelete(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Are you sure you want to delete this goal?"),
          content: Text("This action cannot be undone."),
          actions: [
           FlatButton(child: Text("No"), onPressed: () {
             Navigator.pop(context);
           },),
           //Will delete the goal and pop back to the goals page
           FlatButton(child: Text("Yes"), onPressed: () {
             _deleteGoal(widget.goal.id);
             Navigator.push(context, MaterialPageRoute(builder: (context) => Goals()));
             Toast.show("Successfully deleted this goal!", context, duration: Toast.LENGTH_SHORT, gravity:  Toast.BOTTOM);
           },),
          ],
          elevation: 24.0,
          backgroundColor: Colors.white,
          //shape: CircleBorder(),
        );
      }

    
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //Appbar is needed for drawer and back button
      appBar: AppBar(backgroundColor: Colors.lime, title: Text("              Goal Details")),
      endDrawer: Drawer(
        child: ListView(
          children: <Widget>[
            ListTile(
              leading: Icon(Icons.delete),
              title: Text('Delete Goal'),
              onTap: () {
                confirmDelete(context);
              }
            ),

            //Add a listTile to handle updating progress
            ListTile(
               leading: Icon(Icons.update),
               title: Text('Update Progress'),
               onTap: () {
                 widget.goal.updateProgress();
                 _updateGoal(widget.goal, widget.goal.id);
                 Navigator.pop(context);
                 Toast.show("Successfully updated the progress!", context, duration: Toast.LENGTH_SHORT, gravity:  Toast.BOTTOM);
               }                       
            ),
            ListTile(
               leading: Icon(Icons.clear),
               title: Text('Clear Progress'),
               onTap: () {
                 widget.goal.currentProgress = 0; 
                 _updateGoal(widget.goal, widget.goal.id);
                 Navigator.pop(context);
                 Toast.show("Successfully cleared your progress!", context, duration: Toast.LENGTH_SHORT, gravity:  Toast.BOTTOM);
               }                       
            ,)
          ]
        )
      ),
      //This helps to avoid page overflow issues
      resizeToAvoidBottomPadding: false,
      body: Container(
        //Create a form using dialogBox.dart implementation but not a dialog box.
        child: GoalDialog(notifyParent: getId, passedGoal: widget.goal, type: "detail"),
      )
    );
  }

  _deleteGoal(int id) async {
    DatabaseHelper helper = DatabaseHelper.instance;
    await helper.deleteGoal(id);
  }

  //Function to update goal for the update progress button
  _updateGoal(GoalInformation goal, int index) async {
    DatabaseHelper helper = DatabaseHelper.instance;
    await helper.updateGoal(goal, index);
  }
}