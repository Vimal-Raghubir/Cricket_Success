import 'package:flutter/material.dart';
import 'package:cricket_app/database/database.dart';
import 'package:cricket_app/classes/statistics.dart';
import 'package:toast/toast.dart';

class StatisticManagement extends StatefulWidget {
  //Receives either a default Statistic or already built Statistic and stores it in passedStatistic
  final passedStatistic;

  //This describes the type of page. Either a dialog or something else
  final type;

  const StatisticManagement({Key key, this.notifyParent, this.passedStatistic, this.type}) : super(key: key);

  @override
  _MyStatisticManagementState createState() => new _MyStatisticManagementState();

  //This function is used to call the Statistic page refresh function to setState
  final Function() notifyParent;
}


class _MyStatisticManagementState extends State<StatisticManagement> {
  var selectedStatisticIndex;
  var selectedStatisticLength;
  var selectedStatisticName;
  var selectedStatisticDescription;
  var currentProgress;
  //Stores all Statistic names for the Statistic name field. Used to prevent duplicate Statistic names
  List statisticNames = [];
  int index;
  final List<String> StatisticOptions = ['Batting', 'Bowling', 'Fielding'];

  //Key used to validate form input
  final _formKey = GlobalKey<FormState>();

  @protected
  @mustCallSuper
  initState() {
    super.initState();
    //Extract passed in Statistic and initializes dynamic variables with their values. Starting point
    selectedStatistic = widget.passedStatistic.type;
    selectedStatisticIndex = widget.passedStatistic.typeIndex;
    selectedStatisticLength = widget.passedStatistic.length;
    selectedStatisticName = widget.passedStatistic.name;
    selectedStatisticDescription = widget.passedStatistic.description;
    currentProgress = widget.passedStatistic.currentProgress;
    //Retrieves a list of all Statisticnames in the database
    _getStatisticNames();
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

Widget createStatisticNameField() {
  return TextFormField(
    textCapitalization: TextCapitalization.words,
    //Starts with the passed in Statistic as initial value
    initialValue: widget.passedStatistic.name,
    keyboardType: TextInputType.text ,
    decoration: InputDecoration(
      labelText: "What would you like to name this match?",
      hintText: "e.g. Match 3",
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
      
      //Checks if the database Statistic names contain the passed in value to prevent duplicates and you are trying to create a new Statistic
      } else if(statisticNames.contains(value.toLowerCase()) && widget.type == "new") {
        print("CHECK IS WORKING");
        return 'A match with the same name already exists';
      //Checks if the statistic name already exists in the database and the initial statistic name has been modified. This guards against changing an existing statistic name to another existing statistic name
      } else if (statisticNames.contains(value.toLowerCase()) && widget.passedStatistic.name != value) {
        return 'An existing match has that name';
      } else {
        return null;
      }
    },
    onSaved: (value)=> selectedStatisticName = value,
  );
}

Widget createDescriptionField() {
  return TextFormField(
    textCapitalization: TextCapitalization.words,
    //Start with passed in statistic description
    initialValue: widget.passedStatistic.description,
    keyboardType: TextInputType.text ,
    decoration: InputDecoration(
      labelText: "Any additional details?",
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
    onSaved: (value)=> selectedstatisticDescription = value,
  );
}

Widget dayPickerHeader() {
  return Container(
    padding: const EdgeInsets.symmetric(vertical: 12),
    child: Text(
      'How many days do you think before you can achieve this statistic?',
      softWrap: true,
    ),
  );
}
Widget dayPicker() {
  return Slider(
    value: selectedStatisticLength,
    onChanged: (newRating) {
      setState(() {
        selectedStatisticLength = newRating;
      });
    },
    min: 1.0,
    max: 365.0,
    //Divisions help to show a label above the slider
    divisions: 91,
    label: "$selectedStatisticLength",
  );
}

Widget progressHeader() {
  return Container(
    padding: const EdgeInsets.symmetric(vertical: 12),
    child: Text(
      'How many days have you completed for this statistic so far?',
      softWrap: true,
    ),
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
        //Create a new statistic object with the parameters
        StatisticInformation newStatistic = new StatisticInformation(selectedStatisticName, selectedStatistic, selectedStatisticIndex, selectedStatisticDescription, selectedStatisticLength, currentProgress);
        if (buttonText == "Submit") {
            //Insert the newStatistic into the database
          _save(newStatistic);
          //Calls the function in the Statistics.dart class to refresh the Statistics page with setState. This is used to fix cards not appearing on the Statistics page after submitting this form
          widget.notifyParent();
          //Navigates back to the previous page and in this case the Statistics page
          Navigator.pop(context);
          //Toast message to indicate the Statistic was created
          Toast.show("Successfully created your Match!", context, duration: Toast.LENGTH_SHORT, gravity:  Toast.BOTTOM);
        } else if (buttonText == "Update") {
          //Retrieve the index of the passed in Statistic
          index = widget.notifyParent();

          newStatistic.currentProgress = key.currentState.finalProgress;
          //Updates Statistic with newStatistic content and id
          _updateStatistic(newStatistic, index);
          //Goes back to previous page which in this case is Statistics.dart
          Navigator.pop(context);
          //Toast message to indicate the Statistic was updated
          Toast.show("Successfully updated your Statistic!", context, duration: Toast.LENGTH_SHORT, gravity:  Toast.BOTTOM);
        } 
      }                     
    },
      child: Text(buttonText),
    ),
  );
}

  //Alert box to confirm deletion of a Statistic
  void confirmDelete(BuildContext context) async {
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Are you sure you want to delete this Statistic?"),
          content: Text("This action cannot be undone."),
          actions: [
           FlatButton(child: Text("No"), onPressed: () {
             Navigator.pop(context);
           },),
           //Will delete the Statistic and pop back to the Statistics page
           FlatButton(child: Text("Yes"), onPressed: () {
              _deleteStatistic(widget.passedStatistic.id);
              //Removed the reference to confirmDelete preventing this nested navigator pop issue
             //Navigator.push(context, MaterialPageRoute(builder: (context) => Statistics()));
             Toast.show("Successfully deleted this Statistic!", context, duration: Toast.LENGTH_SHORT, gravity:  Toast.BOTTOM);
           },),
          ],
          elevation: 24.0,
          backgroundColor: Colors.white,
          //shape: CircleBorder(),
        );
      }
    );
  }

Widget deleteButton(BuildContext context) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 16.0),
    child: RaisedButton(
      onPressed: () {
        //confirmDelete(context);
        _deleteStatistic(widget.passedStatistic.id);
        Navigator.pop(context);
      },
      child: Text("Delete")
    )
    
  );
}

//This widget is responsible for creating all the contents of the form
Widget newPage() {
  return Column(
    children: <Widget>[
      createDropDownHeader("What kind of Statistic would you like to create?"),
      createDropdownMenu(),
      createStatisticNameField(),
      createDescriptionField(),
      dayPickerHeader(),
      //This is a slider used to handle the number of days for a Statistic
      dayPicker(),
      submitButton("Submit"),    
    ],
  );
}

//This widget is responsible for creating all the contents of the form
Widget updatePage() {
  return Column(
    children: <Widget>[
      createDropDownHeader("Do you want to change the type of Statistic?"),
      createDropdownMenu(),
      createStatisticNameField(),
      createDescriptionField(),
      dayPickerHeader(),
      //This is a slider used to handle the number of days for a Statistic
      dayPicker(),
      //Header for progress portion
      progressHeader(),
      //Progress tracker
      NumberCountDemo(key: key, progress: currentProgress, dayLimit: selectedStatisticLength),
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
    //If the passed in widget type is a new Statistic then the call is being made from Statistics.dart
    if (widget.type == "new") {
      return Column(
        children: <Widget>[
          Form(
            key: _formKey,
            //Pass in correct variables for assignment
            child: newPage()
          ),
        ],
      );
    // If the passed in widget type is not a new Statistic then it comes from StatisticDetails.dart
    } else {
      return Column(
        children: <Widget>[
          Form(
            key: _formKey,
            child: updatePage()
          )
      ],
      );  
    }
  }
  
  void dispose() {
    super.dispose();
  }
  //Function to insert a Statistic into the database
  _save(StatisticInformation statistic) async {
    DatabaseHelper helper = DatabaseHelper.instance;
    int id = await helper.insertStatistic(statistic);
    print('inserted row: $id');
  }



  //Function to retrieve a Statistic by id and update in the database
  _updateStatistic(StatisticInformation statistic, int index) async {
    DatabaseHelper helper = DatabaseHelper.instance;
    await helper.updateStatistics(statistic, index);
  }

  //Function to get all statistic names in the database
  _getStatisticNames() async {
    DatabaseHelper helper = DatabaseHelper.instance;
    statisticNames = await helper.getStatisticNames();
  }

  _deleteStatistic(int id) async {
    DatabaseHelper helper = DatabaseHelper.instance;
    await helper.deleteStatistic(id);
  }
}  