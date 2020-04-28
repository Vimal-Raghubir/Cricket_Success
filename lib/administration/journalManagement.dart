import 'package:flutter/material.dart';
import 'package:cricket_app/database/database.dart';
import 'package:cricket_app/classes/journalInformation.dart';
import 'package:intl/intl.dart';
import 'package:toast/toast.dart';

class JournalManagement extends StatefulWidget {
  //Receives either a default journal or already built journal and stores it in passedjournal
  final passedJournal;

  //This describes the type of page. Either a new journal or existing journal
  final type;

  const JournalManagement({Key key, this.notifyParent, this.passedJournal, this.type}) : super(key: key);

  @override
  _MyJournalManagementState createState() => new _MyJournalManagementState();

  //This function is used to call the Journal page refresh function to setState
  final Function() notifyParent;
}


class _MyJournalManagementState extends State<JournalManagement> {
  var selectedJournalName;
  var selectedJournalDetails;
  String parsedDate;
  String dateDisplay;

  Map<String, bool> values;

  DateTime selectedJournalDate;
  DateTime currentDate = DateTime.now();
  DateTime latestDate;
  //Stores all journal names for the journal name field. Used to prevent duplicate journal names
  List journalNames = [];
  int index;

  //Key used to validate form input
  final _formKey = GlobalKey<FormState>();

  @protected
  @mustCallSuper
  initState() {
    super.initState();
    //Extract passed in journal and initializes dynamic variables with their values. Starting point
    selectedJournalName = widget.passedJournal.name;
    selectedJournalDetails = widget.passedJournal.details;

    if (widget.passedJournal.date != "") {
      //Used to parse datetime object from a ISO string
      selectedJournalDate = DateTime.parse(widget.passedJournal.date);
    } else {
      selectedJournalDate = DateTime.now();
    }
    //Allows the date to be a day after the current day
    latestDate = DateTime(currentDate.year, currentDate.month, currentDate.day + 1);
    //Retrieves a list of all journal names in the database
    _getJournalNames();
  }

Widget createDropDownHeader(String dropDownMessage) {
  //Allows dynamic dropdown header
  return Container(
    padding: const EdgeInsets.all(12),
    child: Text(
      dropDownMessage,
      softWrap: true,
    ),
  );
}


Widget createJournalNameField() {
  return TextFormField(
    //Starts with the passed in journal as initial value
    initialValue: widget.passedJournal.name,
    keyboardType: TextInputType.text ,
    decoration: InputDecoration(
      labelText: "What would you like to name this journal entry?",
      hintText: "e.g. First training session",
    ),
    textInputAction: TextInputAction.next,
    //Used to validate user input
    validator: (value) {
      RegExp regex = new RegExp(r"^[a-zA-Z0-9\s]*$");
      //Checks if the value is empty or else return error message
      if (value.isEmpty) {
        return 'Please enter a value';
      } else if(!regex.hasMatch(value)) {
        return 'Invalid characters detected';
      
      //Checks if the database journal names contain the passed in value to prevent duplicates and you are trying to create a new journal
      } else if(journalNames.contains(value.toLowerCase()) && widget.type == "new") {
        return 'A journal with the same name already exists';
      //Checks if the journal name already exists in the database and the initial journal name has been modified. This guards against changing an existing journal name to another existing journal name
      } else if (journalNames.contains(value.toLowerCase()) && widget.passedJournal.name != value) {
        return 'An existing journal has that name';
      } else {
        return null;
      }
    },
    onSaved: (value)=> selectedJournalName = value,
  );
}

Widget createDetailField() {
  return TextFormField(
    //Start with passed in journal details
    initialValue: widget.passedJournal.details,
    keyboardType: TextInputType.text ,
    decoration: InputDecoration(
      labelText: "How was your session? How did you feel?",
    ),
    textInputAction: TextInputAction.next,
    validator: (value) {
      RegExp regex = new RegExp(r"^[a-zA-Z0-9.\s]*$");
      if (value.isEmpty) {
        return 'Please enter a value';
      } else if(!regex.hasMatch(value)) {
        return 'Invalid characters detected';
      }
      else {
        return null;
      }
    },
    onSaved: (value)=> selectedJournalDetails = value,
  );
}

Widget dayPickerHeader() {
  return Container(
    padding: const EdgeInsets.symmetric(vertical: 12),
    child: Text(
      'When did this session take place?',
      softWrap: true,
    ),
  );
}

  Future<Null> _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: selectedJournalDate,
        firstDate: DateTime(2019, 1),
        lastDate: latestDate);
    if (picked != null && picked != selectedJournalDate) {
      if (this.mounted) {
        setState(() {
          selectedJournalDate = picked;
        });
      }
    }
  }

Widget dateButton(BuildContext context) {
  return OutlineButton(
    onPressed: () => _selectDate(context),
      child: Text(dateDisplay),
  );
}

Widget submitButton(String buttonText) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 16.0),
    child: RaisedButton(
      onPressed: () {
      // Validate returns true if the form is valid
      if (_formKey.currentState.validate()) {
        _formKey.currentState.save();
        //Have to parse the datetime object to ISO string to be saved in the database
        parsedDate = selectedJournalDate.toIso8601String();
        //Create a new journal object with the parameters
        JournalInformation newJournal = new JournalInformation(selectedJournalName, selectedJournalDetails, parsedDate);
        if (buttonText == "Submit") {
            //Insert the new Journal into the database
          _save(newJournal);
          //Calls the function in the journals.dart class to refresh the journal page with setState. This is used to fix cards not appearing on the journal page after submitting this form
          widget.notifyParent();
          //Navigates back to the previous page and in this case the journal page
          Navigator.pop(context);
          //Toast message to indicate successful creation of journal
          Toast.show("Successfully created your journal entry!", context, duration: Toast.LENGTH_SHORT, gravity:  Toast.BOTTOM);
        } else if (buttonText == "Update") {
          //Retrieve the index of the passed in journal
          index = widget.notifyParent();
          //Updates journal with newJournal content and id
          _updateJournal(newJournal, index);
          //Goes back to previous page which in this case is journals.dart
          Navigator.pop(context);
          //Toast message to indicate successful creation of journal
          Toast.show("Successfully updated your journal entry!", context, duration: Toast.LENGTH_SHORT, gravity:  Toast.BOTTOM);
        } 
      }                     
    },
      child: Text(buttonText),
    ),
  );
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
             //Removed the reference to confirmDelete preventing this nested navigator pop issue
             _deleteJournal(widget.passedJournal.id);
             //Navigator.push(context, MaterialPageRoute(builder: (context) => Journal()));
             Toast.show("Successfully deleted your journal entry!", context, duration: Toast.LENGTH_SHORT, gravity:  Toast.BOTTOM);
           },),
          ],
          elevation: 24.0,
          backgroundColor: Colors.white,
        );
      }
    );
  }


Widget deleteButton(BuildContext context) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 16.0),
    child: RaisedButton(
      onPressed: () {
       // confirmDelete(context);
        _deleteJournal(widget.passedJournal.id);
        Navigator.pop(context);
        Toast.show("Successfully deleted your journal entry!", context, duration: Toast.LENGTH_LONG, gravity:  Toast.BOTTOM);
      },
      child: Text("Delete")
    )
    
  );
}

//This widget is responsible for creating all the contents of the form
Widget newPage() {
  return Column(
    children: <Widget>[
      createJournalNameField(),
      createDetailField(),
      dayPickerHeader(),
      dateButton(context),
      submitButton("Submit"),    
    ],
  );
}

//This widget is responsible for creating all the contents of the form
Widget updatePage(BuildContext context) {
  return Column(
    children: <Widget>[
      createJournalNameField(),
      createDetailField(),
      dayPickerHeader(),
      dateButton(context),
      ButtonBar(
        alignment: MainAxisAlignment.center,
        children: <Widget> [
          deleteButton(context),
          submitButton("Update")
        ]
      ),
        
    ],
  );
}
  
  Widget build(BuildContext context) {
    //_getGoalNames();
    var formatter = new DateFormat('MMMM dd,yyyy');
    dateDisplay = formatter.format(selectedJournalDate);
    //If the passed in widget type is a new journal then the call is being made from journals.dart
    if (widget.type == "new") {
      return Expanded(
        child: Column(
          children: <Widget>[
            Form(
              key: _formKey,
              //Pass in correct variables for assignment
              child: newPage()
            ),
          ],
        )
      );
    // If the passed in widget type is not a new journal then it comes from journalDetails.dart
    } else {
      return Expanded(
        child: Column(
          children: <Widget>[
            Form(
              key: _formKey,
              child: updatePage(context)
            )
          ],
        )
      );  
    }
  }
  //Function to insert a  journal into the database
  _save(JournalInformation journal) async {
    DatabaseHelper helper = DatabaseHelper.instance;
    int id = await helper.insertJournal(journal);
    print('inserted row: $id');
  }



  //Function to retrieve a journal by id and update in the database
  _updateJournal(JournalInformation journal, int index) async {
    DatabaseHelper helper = DatabaseHelper.instance;
    await helper.updateJournal(journal, index);
  }

  //Function to get all journal names in the database
  _getJournalNames() async {
    DatabaseHelper helper = DatabaseHelper.instance;
    journalNames = await helper.getJournalNames();
  }

    _deleteJournal(int id) async {
    DatabaseHelper helper = DatabaseHelper.instance;
    await helper.deleteJournal(id);
  }
}        