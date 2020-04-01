import 'package:flutter/material.dart';
import 'package:cricket_app/administration/journalDialog.dart';
import 'package:cricket_app/database/database.dart';
import 'package:cricket_app/pages/goals.dart';
import 'package:cricket_app/classes/journalInformation.dart';
import 'package:cricket_app/cardDecoration/customCard.dart';

//Used to handle the tutorial page
class JournalDetails extends StatefulWidget {

  //Stores passed in goal information in goal variable
  final journal;

  const JournalDetails({Key key, this.journal}) : super(key: key);
  
  _JournalDetailState createState() => _JournalDetailState();
}

class _JournalDetailState extends State<JournalDetails> {
  //Will return the goal id
  getId() {
    //This stores the passed in goal's id from the goals.dart page
    return widget.journal.id;
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
             _deleteJournal(widget.journal.id);
             Navigator.push(context, MaterialPageRoute(builder: (context) => Goals()));
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
                 widget.journal.updateProgress();
                 _updateJournal(widget.journal, widget.journal.id);
               }                       
            ,)
          ]
        )
      ),
      //This helps to avoid page overflow issues
      resizeToAvoidBottomPadding: false,
      body: Container(
        //Create a form using dialogBox.dart implementation but not a dialog box.
        child: JournalDialog(notifyParent: getId, passedJournal: widget.journal, type: "detail"),
      )
    );
  }

  _deleteJournal(int id) async {
    DatabaseHelper helper = DatabaseHelper.instance;
    await helper.deleteJournal(id);
  }

  //Function to update goal for the update progress button
  _updateJournal(JournalInformation journal, int index) async {
    DatabaseHelper helper = DatabaseHelper.instance;
    await helper.updateJournal(journal, index);
  }
}