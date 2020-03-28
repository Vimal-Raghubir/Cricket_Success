import 'package:cricket_app/pages/goalDetails.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cricket_app/navigation/bottom_navigation.dart';
import 'package:cricket_app/header/header.dart';
import 'package:cricket_app/cardDecoration/customCard.dart';
import 'package:cricket_app/dialogBox/dialogBox.dart';
import 'package:cricket_app/database/database.dart';
import 'dart:async';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

//Global list of goals that is updated by the dialogBox.dart file
List<GoalInformation> goals = [];
int totalGoalEntries = 0;

// database table and column names
final String tableGoals = 'Goals';
final String column_id = 'ID';
final String column_name = 'Name';
final String column_type = 'Type';
final String column_type_index = 'Type_Index';
final String column_description = 'Description';
final String column_length = 'Length';

//Custom class defining the structure of a goal
class GoalInformation {
  String name;
  String type;
  int typeIndex;
  String description;
  int length;
  
  //Constructor initializing the values of the class variables. The constructor has default values in case a default goal is needed
  GoalInformation([String goalName = "", String goalType = "Process Goal", int goalTypeIndex = 0, String goalDescription = "", double goalLength = 1.0]) {
    name = goalName;
    type = goalType;
    typeIndex = goalTypeIndex;
    description = goalDescription;
    length = goalLength.toInt();
  }

  // convenience constructor to create a Word object
  GoalInformation.fromMap(Map<String, dynamic> map) {
    name = map[column_name];
    type = map[column_type];
    typeIndex = map[column_type_index];
    description = map[column_description];
    length = map[column_length];
  }

  // convenience method to create a Map from this Word object
  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      column_name: name,
      column_type: type,
      column_type_index: typeIndex,
      column_description: description,
      column_length: length,
    };
    
      return map;
    } 
}

class Goals extends StatefulWidget {
  _GoalState createState() => _GoalState();
}

class _GoalState extends State<Goals> {
  final List<String> goalOptions = ['Process Goal', 'Performance Goal', 'Outcome Goal'];
  double width;

  //Function that is called in the dialogBox.dart file to refresh this page and render the goals after submitting a form
  refresh() {
    setState(() {});
    _read();
    print(goals.length);
  }

   Widget build(BuildContext context) {
     _read();
     width = MediaQuery.of(context).size.width;
    return Scaffold(
      //Creates bottom navigation and passes the index of the current page in relation to main page
      bottomNavigationBar: Bottom_Navigation().createBottomNavigation(context, 1),
      body: Container(
          child: Column(
            children: <Widget>[
              //Creates custom header for goals page only
              Header().createHeader(context, 1),
              Container(
                padding: const EdgeInsets.all(16),
                child: Text(
                  'Insert Description here',
                  softWrap: true,
                ),
              ),
              Expanded(
                //Used to dynamically render the goals in a list format
                child: new ListView.builder (
                  physics: BouncingScrollPhysics(),
                  itemCount: goals.length,
                  itemBuilder: (BuildContext ctxt, int index) {
                    //Need to change below
                    return InkWell(
                      onTap: () {
                        print("YOU CLICKED!");
                        //Pass the goal information to the goalDetails.dart page
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => GoalDetails(
                            goal: goals[index],
                            id: index,
                            )
                          ),
                        );
                        //Add other logic here
                      },
                      //Render custom card for each goal
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
          //Creates the dialog whenever the button is pressed
          showDialog(
            context: context,
            builder: (_) {
              //Passes a function pointer to my custom dialog class so the dialog class can call setState on this page.
              GoalInformation defaultGoal = new GoalInformation();
              return MyDialog(notifyParent: refresh, passedGoal: defaultGoal, type: "dialog");
            });
        },
        child: Icon(Icons.add),
        backgroundColor: Colors.green,
      ),
    );
  }

  //Function to read all goals from the database for rendering
  _read() async {
    DatabaseHelper helper = DatabaseHelper.instance;
    goals = await helper.getGoals();
  }
}