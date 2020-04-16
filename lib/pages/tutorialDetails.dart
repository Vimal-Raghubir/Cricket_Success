import 'package:cricket_app/classes/tutorial.dart';
import 'package:flutter/material.dart';
import 'package:cricket_app/header/header.dart';

//Used to handle the tutorial page
class TutorialDetails extends StatelessWidget {

  //Stores passed in goal information in goal variable
  final String type;

  const TutorialDetails({Key key, this.type}) : super(key: key);

    @override
  Widget build(BuildContext context) {
    return Scaffold(
      //This helps to avoid page overflow issues
      resizeToAvoidBottomPadding: false,
      body: Column(
        children: <Widget>[
          Header().createHeader(context, 9),
          Container(
            //Create a form using dialogBox.dart implementation but not a dialog box.
            child: createList(),
          )
      ],) 
      
      
    );
  }

  Widget createList() {
    if (type == "Bowling Skills") {
      generateList(bowlingList);
    } else if (type == "Batting Skills") {
      generateList(battingList);
    } else if (type == "Fielding Skills") {
      generateList(fieldingList);
    } else if (type == "Mental Training") {
      generateList(mentalList);
    } else if (type == "Physical Training") {
      generateList(physicalList);
    }
    return Container();
  }

  Widget generateList(List<Tutorial> currentList) {
    return Container(child: Text("hello world"));
  }
}