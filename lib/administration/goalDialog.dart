import 'package:flutter/material.dart';
import 'package:cricket_app/pages/goals.dart';
import 'package:cricket_app/database/database.dart';
import 'package:cricket_app/classes/goalInformation.dart';

class GoalDialog extends StatefulWidget {
  //Receives either a default goal or already built goal and stores it in passedGoal
  final passedGoal;

  //This describes the type of page. Either a dialog or something else
  final type;

  const GoalDialog({Key key, this.notifyParent, this.passedGoal, this.type}) : super(key: key);

  @override
  _MyGoalDialogState createState() => new _MyGoalDialogState();

  //This function is used to call the Goal page refresh function to setState
  final Function() notifyParent;
}


class _MyGoalDialogState extends State<GoalDialog> {
  var selectedGoal;
  var selectedGoalIndex;
  var selectedGoalLength;
  var selectedGoalName;
  var selectedGoalDescription;
  var currentProgress;
  //Stores all goal names for the goal name field. Used to prevent duplicate goal names
  List goalNames = [];
  int index;
  final List<String> goalOptions = ['Process Goal', 'Performance Goal', 'Outcome Goal'];

  //Key used to validate form input
  final _formKey = GlobalKey<FormState>();

  @protected
  @mustCallSuper
  initState() {
    //Extract passed in goal and initializes dynamic variables with their values. Starting point
    selectedGoal = widget.passedGoal.type;
    selectedGoalIndex = widget.passedGoal.typeIndex;
    selectedGoalLength = widget.passedGoal.length.toDouble();
    selectedGoalName = widget.passedGoal.name;
    selectedGoalDescription = widget.passedGoal.description;
    currentProgress = widget.passedGoal.currentProgress;
    //Retrieves a list of all goalnames in the database
    _getGoalNames();
  }

Widget createTitle(String title) {
  //Allows a title to be passed in dynamically
  return Text(title,
    style: TextStyle(fontSize: 18.0,fontWeight: FontWeight.bold, color: Colors.black),
    textAlign: TextAlign.center,
  );
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

Widget createDropdownMenu() {
  //This is used to make the dropdown menu look like a form
  return InputDecorator(
    decoration: InputDecoration(
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(5.0))),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          hint: Text(selectedGoal),
          value: selectedGoal,
          isDense: true,
          onChanged: (String newValue) {
            setState(() {
              selectedGoal = newValue;
              if (selectedGoal == 'Process Goal') {
                //selectedGoalIndex is the index of the dropdown menu item selected and is used in the card creation
                selectedGoalIndex = 0;
              } else if (selectedGoal == 'Performance Goal') {
                selectedGoalIndex = 1;
              } else if (selectedGoal == 'Outcome Goal') {
                selectedGoalIndex = 2;
              }
              print(selectedGoal);
            });
          },
          items: goalOptions.map((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value),
            );
          }).toList(),
          ),
        ),
    );
}

Widget createGoalNameField() {
  return TextFormField(
    textCapitalization: TextCapitalization.words,
    //Starts with the passed in goal as initial value
    initialValue: widget.passedGoal.name,
    keyboardType: TextInputType.text ,
    decoration: InputDecoration(
      labelText: "What is your goal?",
      hintText: "e.g. Work on bowling run up",
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
      
      //Checks if the database goal names contain the passed in value to prevent duplicates and you are trying to create a new goal
      } else if(goalNames.contains(value.toLowerCase()) && widget.type == "dialog") {
        print("CHECK IS WORKING");
        return 'A goal with the same name already exists';
      //Checks if the goal name already exists in the database and the initial goal name has been modified. This guards against changing an existing goal name to another existing goal name
      } else if (goalNames.contains(value.toLowerCase()) && widget.passedGoal.name != value) {
        return 'An existing goal has that name';
      } else {
        return null;
      }
    },
    onSaved: (value)=> selectedGoalName = value,
  );
}

Widget createDescriptionField() {
  return TextFormField(
    textCapitalization: TextCapitalization.words,
    //Start with passed in goal description
    initialValue: widget.passedGoal.description,
    keyboardType: TextInputType.text ,
    decoration: InputDecoration(
      labelText: "Any additional details?",
    ),
    textInputAction: TextInputAction.next,
    validator: (value) {
      RegExp regex = new RegExp(r"^[a-zA-Z0-9\s]*$");
      if (value.isEmpty) {
        return 'Please enter a value';
      } else if(!regex.hasMatch(value)) {
        return 'Invalid characters detected';
      }
      else {
        return null;
      }
    },
    onSaved: (value)=> selectedGoalDescription = value,
  );
}

Widget dayPickerHeader() {
  return Container(
    padding: const EdgeInsets.symmetric(vertical: 12),
    child: Text(
      'How many days do you think before you can achieve this goal?',
      softWrap: true,
    ),
  );
}
Widget dayPicker() {
  return Slider(
    value: selectedGoalLength,
    onChanged: (newRating) {
      setState(() {
        selectedGoalLength = newRating;
      });
    },
    min: 1.0,
    max: 365.0,
    //Divisions help to show a label above the slider
    divisions: 91,
    label: "$selectedGoalLength",
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
        //Create a new goal object with the parameters
        GoalInformation newGoal = new GoalInformation(selectedGoalName, selectedGoal, selectedGoalIndex, selectedGoalDescription, selectedGoalLength, currentProgress);
        if (buttonText == "Submit") {
            //Insert the newGoal into the database
          _save(newGoal);
          //Calls the function in the goals.dart class to refresh the goals page with setState. This is used to fix cards not appearing on the goals page after submitting this form
          widget.notifyParent();
          //Navigates back to the previous page and in this case the goals page
          Navigator.pop(context);
        } else if (buttonText == "Update") {
          //Retrieve the index of the passed in goal
          index = widget.notifyParent();
          //Updates goal with newGoal content and id
          _updateGoal(newGoal, index);
          //Goes back to previous page which in this case is goals.dart
          Navigator.pop(context);
        } 
      }                     
    },
      child: Text(buttonText),
    ),
  );
}

//This widget is responsible for creating all the contents of the form
Widget createDialogForm(String title, String dropdownMessage, String buttonText) {
  return Column(
    children: <Widget>[
      createTitle(title),
      createDropDownHeader(dropdownMessage),
      createDropdownMenu(),
      createGoalNameField(),
      createDescriptionField(),
      dayPickerHeader(),
      //This is a slider used to handle the number of days for a goal
      dayPicker(),
      submitButton(buttonText),    
    ],
  );
}
  
  Widget build(BuildContext context) {
    //If the passed in widget type is a dialog then the call is being made from goals.dart
    if (widget.type == "dialog") {
      return SimpleDialog(
        children: <Widget>[
          Form(
            key: _formKey,
            //Pass in correct variables for assignment
            child: createDialogForm("New Goal", "What kind of goal would you like to create?", "Submit")
          ),
        ],
      );
    // If the passed in widget type is not a dialog then it comes from goalDetails.dart
    } else {
      return Column(
        children: <Widget>[
          Form(
            key: _formKey,
            child: createDialogForm("Update Goal", "Do you want to change the type of goal?", "Update")
          )
      ],
      );  
    }
  }
  //Function to insert a goal into the database
  _save(GoalInformation goal) async {
    DatabaseHelper helper = DatabaseHelper.instance;
    int id = await helper.insertGoal(goal);
    print('inserted row: $id');
  }



  //Function to retrieve a goal by id and update in the database
  _updateGoal(GoalInformation goal, int index) async {
    DatabaseHelper helper = DatabaseHelper.instance;
    await helper.updateGoal(goal, index);
  }

  //Function to get all goal names in the database
  _getGoalNames() async {
    DatabaseHelper helper = DatabaseHelper.instance;
    goalNames = await helper.getGoalNames();
  }
}        