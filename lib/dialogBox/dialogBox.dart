import 'package:flutter/material.dart';
import 'package:cricket_app/pages/goals.dart';
import 'package:cricket_app/database/database.dart';

class MyDialog extends StatefulWidget {
  const MyDialog({Key key, this.notifyParent}) : super(key: key);

  @override
  _MyDialogState createState() => new _MyDialogState();

  //This function is used to call the Goal page refresh function to setState
  final Function() notifyParent;
}


class _MyDialogState extends State<MyDialog> {
  var selectedGoal = 'Process Goal';
  var selectedGoalIndex = 0;
  var goalLength = 1.0;
  var goalName;
  var goalDescription;
  String hintGoal = 'Process Goal';
  final List<String> goalOptions = ['Process Goal', 'Performance Goal', 'Outcome Goal'];

  //Key used to validate form input
  final _formKey = GlobalKey<FormState>();

Widget createDescriptionField() {
  return TextFormField(
    textCapitalization: TextCapitalization.words,
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
    onSaved: (value)=> goalDescription = value,
  );
}

Widget createGoalNameField() {
  return TextFormField(
    textCapitalization: TextCapitalization.words,
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
      } else {
        return null;
      }
    },
    onSaved: (value)=> goalName = value,
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
          hint: Text("Process Goal"),
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
              print(selectedGoalIndex);
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
  
  Widget build(BuildContext context) {
          return SimpleDialog(
          children: <Widget>[
            Form(
              key: _formKey,
              child: Column(
                children: <Widget>[
                  Text('New Goal',
                    style: TextStyle(fontSize: 20.0,fontWeight: FontWeight.bold, color: Colors.black),
                    textAlign: TextAlign.center,
                  ),
                  Container(
                    padding: const EdgeInsets.all(12),
                    child: Text(
                      'What kind of goal would you like to create?',
                    softWrap: true,
                    ),
                  ),
                  createDropdownMenu(),
                  createGoalNameField(),
                  createDescriptionField(),
                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    child: Text(
                      'How many days do you think before you can achieve this goal?',
                    softWrap: true,
                    ),
                  ),
                  //This is a slider used to handle the number of days for a goal
                  Slider.adaptive(
                    value: goalLength,
                    onChanged: (newRating) {
                      setState(() {
                        goalLength = newRating;
                      });
                    },
                    min: 1.0,
                    max: 365.0,
                    //Need to fix this label since not showing
                    label: "$goalLength",
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                    child: RaisedButton(
                      onPressed: () {
                      // Validate returns true if the form is valid
                      if (_formKey.currentState.validate()) {
                        _formKey.currentState.save();
                        //Create a new goal object with the parameters
                        GoalInformation newGoal = new GoalInformation(goalName, selectedGoal, selectedGoalIndex, goalDescription, goalLength);
                        
                        //Insert the newGoal into the database
                        _save(newGoal);
                        //Calls the function in the goals.dart class to refresh the goals page with setState. This is used to fix cards not appearing on the goals page after submitting this form
                        widget.notifyParent();
                        //Navigates back to the previous page and in this case the goals page
                        Navigator.pop(context);
                      }
                      },
                      child: Text('Submit'),
                    ),
                  ),      
            ],),),
          ],);
        }
  //Function to insert a goal into the database
  _save(GoalInformation goal) async {
    DatabaseHelper helper = DatabaseHelper.instance;
    int id = await helper.insert(goal);
    print('inserted row: $id');
  }
}        