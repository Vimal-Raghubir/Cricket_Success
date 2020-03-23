import 'package:flutter/material.dart';
import 'package:cricket_app/pages/goals.dart';

class MyDialog extends StatefulWidget {
  const MyDialog({Key key, this.notifyParent}) : super(key: key);

  @override
  _MyDialogState createState() => new _MyDialogState();

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
  final _formKey = GlobalKey<FormState>();
  
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
                  InputDecorator(
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
                        )
                    ),
                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    child: Text(
                      'What is your goal?',
                    softWrap: true,
                    ),
                  ),
                  TextFormField(
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'Please enter some text';
                      } else {
                        goalName = value;
                        return null;
                      }
                    },
                  ),

                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    child: Text(
                      'Any additional details?',
                    softWrap: true,
                    ),
                  ),
                  TextFormField(
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'Please enter some text';
                      }
                      goalDescription = value;
                      return null;
                    },
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    child: Text(
                      'How many days do you think before you can achieve this goal?',
                    softWrap: true,
                    ),
                  ),

                  Slider.adaptive(
                    value: goalLength,
                    onChanged: (newRating) {
                      setState(() {
                        goalLength = newRating;
                      });
                    },
                    min: 1.0,
                    max: 365.0,
                    label: "$goalLength",
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                    child: RaisedButton(
                      onPressed: () {
                      // Validate returns true if the form is valid, or false
                      // otherwise.
                      if (_formKey.currentState.validate()) {
                        GoalInformation newGoal = new GoalInformation(goalName, selectedGoal, selectedGoalIndex, goalDescription, goalLength);
                        goals.add(newGoal);
                        print(goals.length);
                        widget.notifyParent();
                        Navigator.pop(context);
                      }
                      },
                      child: Text('Submit'),
                    ),
                  ),      
            ],),),
          ],);
        }
      }        