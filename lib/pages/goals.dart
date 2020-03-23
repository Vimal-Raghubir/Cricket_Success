import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cricket_app/navigation/bottom_navigation.dart';
import 'package:cricket_app/header/header.dart';
import 'package:cricket_app/cardDecoration/customCard.dart';

class GoalInformation {
  String name;
  String type;
  int typeIndex;
  String description;
  String length;
  
  GoalInformation(String goalName, String goalType, int goalTypeIndex, String goalDescription, String goalLength) {
    name = goalName;
    type = goalType;
    typeIndex = goalTypeIndex;
    description = goalDescription;
    length = goalLength;
  }
}

class Goals extends StatefulWidget {
  _GoalState createState() => _GoalState();
}

class _GoalState extends State<Goals> {
  var selectedGoal;
  var selectedGoalIndex;
  String hintGoal = 'Process Goal';
  //final List<String> goals = [];
  //final List<String> goalTypes = [];
  //final List<String> descriptions = [];
 // final List<String> lengths = [];
  final List<GoalInformation> goals = [];
  final List<String> goalOptions = ['Process Goal', 'Performance Goal', 'Outcome Goal'];


  final TextEditingController goal = new TextEditingController();
  final TextEditingController description = new TextEditingController();
  final TextEditingController length = new TextEditingController();
  double width;

  Future createDialogBox(BuildContext context) {
    return showDialog(context: context, builder: (context) {
        return SimpleDialog(
          title: Text('Create a new Goal',
              style: TextStyle(fontSize: 20.0,fontWeight: FontWeight.bold, color: Colors.black),
              textAlign: TextAlign.center,
            ),
          children: <Widget>[
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
              Text('What kind of goal would you like to create?', style: TextStyle(fontSize: 14.0, color: Colors.black)),
              
              FormField<String>(
                builder: (FormFieldState<String> state) {
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
                },
              ),
              
              Text('What is your goal?', style: TextStyle(fontSize: 14.0, color: Colors.black)),
              
              TextField(
                controller: goal, 
                decoration: new InputDecoration(hintText: "I want to improve at ...."),
                ),

              Text('Any additional details?', style: TextStyle(fontSize: 14.0, color: Colors.black)),
              TextField(
                controller: description, 
                decoration: new InputDecoration(hintText: "I need to achieve this goal because ...."),
                ),

              Text('It is always best to set yourself a timeframe. How long do you think you might take to achieve this goal?', style: TextStyle(fontSize: 14.0, color: Colors.black)),
              TextField(
                controller: length, 
                decoration: new InputDecoration(hintText: "30 days"),
                ),

                FlatButton(
                      child: new Text("Save"),
                      onPressed: (){
                          GoalInformation newGoal = new GoalInformation(goal.text, selectedGoal, selectedGoalIndex, description.text, length.text);
                          goals.add(newGoal);

                          goal.clear();
                          description.clear();
                          length.clear();
                          setState(() {});
                      Navigator.pop(context);
                      },
                    )
            ],)
            
          ],);
      });
  }

   Widget build(BuildContext context) {
     width = MediaQuery.of(context).size.width;
    return Scaffold(
      bottomNavigationBar: Bottom_Navigation().createBottomNavigation(context, 1),
      body: Container(
          child: Column(
            children: <Widget>[
              Header().createHeader(context, 1),
              //Text(
              //  'My Goals',
              //  style: TextStyle(fontSize: 30.0,fontWeight: FontWeight.bold, color: Colors.black)
             // ),
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
                      child: CustomCard().createCustomCard(goals[index], width),       //ListTile(
                                    //leading: Icon(Icons.play_arrow),
                                    //title: Text(goals[index].toString()),
                                    //trailing: Icon(Icons.more_vert),
                                    //subtitle: Text(goalTypes[index].toString()),
                                    //isThreeLine: true),
                    );  
                  }
                )
              ),
            ],
          ),
        ),
      floatingActionButton: FloatingActionButton (
        onPressed: () {
          createDialogBox(context);
        },
        child: Icon(Icons.add),
        backgroundColor: Colors.green,
      ),
    );
  }
}