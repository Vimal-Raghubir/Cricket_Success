import 'package:flutter/material.dart';
import 'package:cricket_app/administration/journalManagement.dart';
import 'package:cricket_app/database/database.dart';
import 'package:cricket_app/pages/journal.dart';
import 'package:toast/toast.dart';
import 'package:cricket_app/header/header.dart';

//Used to handle the tutorial page
class JournalDetails extends StatefulWidget {

  //Stores passed in journal information in journal variable
  final journal;

  const JournalDetails({Key key, this.journal}) : super(key: key);
  
  _JournalDetailState createState() => _JournalDetailState();
}

class _JournalDetailState extends State<JournalDetails> {
  //Will return the journal id
  getId() {
    //This stores the passed in journal's id from the journals.dart page
    return widget.journal.id;
  }


  //Alert box to confirm deletion of a journal
  void confirmDelete(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Are you sure you want to delete this journal?"),
          content: Text("This action cannot be undone."),
          actions: [
           FlatButton(child: Text("No"), onPressed: () {
             Navigator.pop(context);
           },),
           //Will delete the journal and pop back to the journals page
           FlatButton(child: Text("Yes"), onPressed: () {
             _deleteJournal(widget.journal.id);
             Navigator.push(context, MaterialPageRoute(builder: (context) => Journal()));
             Toast.show("Successfully deleted your journal entry!", context, duration: Toast.LENGTH_SHORT, gravity:  Toast.BOTTOM);
           },),
          ],
          elevation: 24.0,
          backgroundColor: Colors.white,
        );
      }
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      endDrawer: Drawer(
        child: ListView(
          children: <Widget>[
            ListTile(
              leading: Icon(Icons.delete),
              title: Text('Delete Journal'),
              onTap: () {
                confirmDelete(context);
              }
            ),
          ]
        )
      ),
      //This helps to avoid page overflow issues
      resizeToAvoidBottomPadding: false,
      body: Column(
        children: <Widget>[
          Header().createHeader(context, 7),
          Container(
            //Create a form using dialogBox.dart implementation but not a dialog box.
            child: JournalManagement(notifyParent: getId, passedJournal: widget.journal, type: "detail"),
          )
      ],) 
      
      
    );
  }

  _deleteJournal(int id) async {
    DatabaseHelper helper = DatabaseHelper.instance;
    await helper.deleteJournal(id);
  }
}