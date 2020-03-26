import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cricket_app/navigation/bottom_navigation.dart';
import 'package:cricket_app/header/header.dart';
import 'package:cricket_app/cardDecoration/customCard.dart';
import 'package:cricket_app/dialogBox/dialogBox.dart';

import 'dart:async';

import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

//Global list of goals that is updated by the dialogBox.dart file
final List<GoalInformation> goals = [];

// database table and column names
final String tableGoals = 'Goals';
final String column_id = 'ID';
final String column_name = 'Name';
final String column_type = 'Type';
final String column_type_index = 'Type Index';
final String column_description = 'Description';
final String column_length = 'Length';

//Custom class defining the structure of a goal
class GoalInformation {
  int id;
  String name;
  String type;
  int typeIndex;
  String description;
  String length;
  
  //Constructor initializing the values of the class variables
  GoalInformation(int goalIndex, String goalName, String goalType, int goalTypeIndex, String goalDescription, double goalLength) {
    id = goalIndex;
    name = goalName;
    type = goalType;
    typeIndex = goalTypeIndex;
    description = goalDescription;
    length = goalLength.toInt().toString() + " days";
  }

        // convenience constructor to create a Word object
  GoalInformation.fromMap(Map<String, dynamic> map) {
        id = map[column_id];
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
      column_description: description,
      column_length: length,
    };
    if (id != null) {
      map[column_id] = id;
      map[column_type_index] = typeIndex;
    }
      return map;
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
  double width;

  //Function that is called in the dialogBox.dart file to refresh this page and render the goals after submitting a form
  refresh() {
    setState(() {});
    print(goals.length);
  }

   Widget build(BuildContext context) {
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
              return MyDialog(notifyParent: refresh);
            });
        },
        child: Icon(Icons.add),
        backgroundColor: Colors.green,
      ),
    );
  }
}