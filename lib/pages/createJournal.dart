import 'package:flutter/material.dart';
import 'package:cricket_app/administration/journalManagement.dart';
import 'package:cricket_app/header/header.dart';

//Used to handle the tutorial page
class NewJournal extends StatefulWidget {

  //Stores passed in journal information in journal variable
  final journal;

  const NewJournal({Key key, this.journal}) : super(key: key);
  
  _NewJournalState createState() => _NewJournalState();
}

class _NewJournalState extends State<NewJournal> {

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
          Header().createHeader(context, 6),
          Container(
            //Create a form using dialogBox.dart implementation but not a dialog box.
            child: JournalManagement(notifyParent: refresh, passedJournal: widget.journal, type: "new"),
      )
      ],)
    );
  }
}