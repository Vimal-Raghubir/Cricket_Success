import 'package:flutter/material.dart';
import 'package:cricket_app/administration/journalManagement.dart';

//Used to handle the tutorial page
class NewJournal extends StatefulWidget {

  //Stores passed in journal information in journal variable
  final journal;

  const NewJournal({Key key, this.journal}) : super(key: key);
  
  _NewJournalState createState() => _NewJournalState();
}

class _NewJournalState extends State<NewJournal> {

  refresh() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //Appbar is needed for drawer and back button
      appBar: AppBar(backgroundColor: Colors.lime, title: Text("               New Journal")),
      //This helps to avoid page overflow issues
      resizeToAvoidBottomPadding: false,
      body: Container(
        //Create a form using dialogBox.dart implementation but not a dialog box.
        child: JournalManagement(notifyParent: refresh, passedJournal: widget.journal, type: "new"),
      )
    );
  }
}