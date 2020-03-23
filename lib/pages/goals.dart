import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cricket_app/navigation/bottom_navigation.dart';
import 'package:cricket_app/header/header.dart';
import 'package:cricket_app/cardDecoration/customCard.dart';
import 'package:cricket_app/dialogBox/dialogBox.dart';


final List<GoalInformation> goals = [];
class GoalInformation {
  String name;
  String type;
  int typeIndex;
  String description;
  String length;
  
  GoalInformation(String goalName, String goalType, int goalTypeIndex, String goalDescription, double goalLength) {
    name = goalName;
    type = goalType;
    typeIndex = goalTypeIndex;
    description = goalDescription;
    length = goalLength.toInt().toString() + " days";
  }
}

class Goals extends StatefulWidget {
  _GoalState createState() => _GoalState();
}

class _GoalState extends State<Goals> {
  var selectedGoal = 'Process Goal';
  var selectedGoalIndex = 0;
  var goalLength = 1.0;
  var goalName;
  var goalDescription;
  String hintGoal = 'Process Goal';
  final List<String> goalOptions = ['Process Goal', 'Performance Goal', 'Outcome Goal'];

  final TextEditingController description = new TextEditingController();
  final TextEditingController length = new TextEditingController();
  double width;

  final _formKey = GlobalKey<FormState>();

  Future createDialogBox(BuildContext context) {
    /* return showDialog(context: context, builder: (context) {
      return StatefulBuilder(
        builder: (context, setState) {
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
                        description.clear();
                        length.clear();
                        super.setState(() {});
                        Navigator.pop(context);
                      }
                      },
                      child: Text('Submit'),
                    ),
                  ),      
            ],),),
            //dialogBox().createDialogBoxForm(context, _formKey),
          ],);
        });
      }); */
  }

  refresh() {
    setState(() {});
    print(goals.length);
  }

   Widget build(BuildContext context) {
     width = MediaQuery.of(context).size.width;
    return Scaffold(
      bottomNavigationBar: Bottom_Navigation().createBottomNavigation(context, 1),
      body: Container(
          child: Column(
            children: <Widget>[
              Header().createHeader(context, 1),
              Container(
                padding: const EdgeInsets.all(16),
                child: Text(
                  'Insert Description here',
                  softWrap: true,
                ),
              ),
              Expanded(
                child: new ListView.builder (
                  physics: BouncingScrollPhysics(),
                  itemCount: goals.length,
                  itemBuilder: (BuildContext ctxt, int index) {
                    return InkWell(
                      onTap: () {
                        print("YOU CLICKED!");
                      },
                      child: CustomCard().createCustomCard(goals[index], width),
                    );  
                  }
                )
              ),
            ],
          ),
        ),
      floatingActionButton: FloatingActionButton (
        onPressed: () {
          //createDialogBox(context);

          showDialog(
            context: context,
            builder: (_) {
              return MyDialog(notifyParent: refresh);
            });
        },
        child: Icon(Icons.add),
        backgroundColor: Colors.green,
      ),
    );
  }
}