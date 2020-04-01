import 'package:cricket_app/pages/goalDetails.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cricket_app/navigation/bottom_navigation.dart';
import 'package:cricket_app/header/header.dart';
import 'package:cricket_app/cardDecoration/customCard.dart';
import 'package:cricket_app/administration/goalDialog.dart';
import 'package:cricket_app/database/database.dart';
import 'dart:async';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:cricket_app/classes/goalInformation.dart';

//Global list of goals that is updated by the dialogBox.dart file
List<GoalInformation> goals = [];
int totalGoalEntries = 0;

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
              //Header for the page
              Header().createHeader(context, 1),

              //Expansion tile is the dropdown menu for more information
              ExpansionTile(
                title: Text("                              See more Details"),
                children: <Widget>[
                  Container(
                    padding: const EdgeInsets.all(16),
                    child: Text(
                      'There are 3 main types of goals that you will need to use.',
                      textAlign: TextAlign.justify,
                      softWrap: true,
                    ),
                  ),
                  RichText(
                    textAlign: TextAlign.justify,
                    text: TextSpan(
                      children: <TextSpan>[
                        TextSpan(text: 'Process Goals', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black, fontSize: 14),
                        ),
                        TextSpan(text: ' are strategies that help you to achieve success. These include small controllable habits such as',
                          style: TextStyle(fontStyle: FontStyle.normal, color: Colors.black, fontSize: 14),
                        ),
                        TextSpan(text: ' watching the ball. (Usually short term)',
                          style: TextStyle(fontStyle: FontStyle.italic, color: Colors.black, fontSize: 14),
                        )
                      ]
                    )
                  ),
              
                  SizedBox(height: 15),
                  RichText(
                    textAlign: TextAlign.justify,
                    text: TextSpan(
                      children: <TextSpan>[
                        TextSpan(text: 'Performance Goals',
                          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black, fontSize: 14),
                        ),
                        TextSpan(text: ' are goals that define a level of performance you desire to reach. These include amibitions such as',
                          style: TextStyle(fontStyle: FontStyle.normal, color: Colors.black, fontSize: 14),
                        ),
                        TextSpan(text: ' scoring a century. (Mix of short and long-term)',
                          style: TextStyle(fontStyle: FontStyle.italic, color: Colors.black, fontSize: 14),
                        )
                      ]
                    )
                  ),
                  SizedBox(height: 15),
                  RichText(
                    textAlign: TextAlign.justify,
                    text: TextSpan(
                      children: <TextSpan>[
                        TextSpan(text: 'Outcome Goals',
                          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black, fontSize: 14),
                        ),
                        TextSpan(text: ' are goals that define the desired end result. These include large successes such as',
                          style: TextStyle(fontStyle: FontStyle.normal, color: Colors.black, fontSize: 14),
                        ),
                        TextSpan(text: ' winning the player of the tournament award. (Mostly long-term)',
                          style: TextStyle(fontStyle: FontStyle.italic, color: Colors.black, fontSize: 14),
                        )
                      ]
                    )
                  ),
                ],
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
                        //Pass the goal information to the goalDetails.dart page
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => GoalDetails(
                            //Helps to prevent range issues
                            goal: goals?.elementAt(index) ?? "",
                            )
                          ),
                        );
                        //Add other logic here
                      },
                      //Render custom card for each goal
                      child: CustomCard().createCustomGoalCard(goals[index], width),
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
              return GoalDialog(notifyParent: refresh, passedGoal: defaultGoal, type: "dialog");
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
    //goals now stores the index of each goalInformation in the database
    goals = await helper.getGoals();
  }
}