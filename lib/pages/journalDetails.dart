import 'package:flutter/material.dart';
import 'package:cricket_app/administration/journalManagement.dart';
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
                Header().createHeader(context, 7),
                Container(
                  //Create a form using dialogBox.dart implementation but not a dialog box.
                  child: JournalManagement(
                      notifyParent: getId,
                      passedJournal: widget.journal,
                      type: "detail"),
                )
              ],
            )));
  }
}
