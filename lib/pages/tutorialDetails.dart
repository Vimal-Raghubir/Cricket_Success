import 'package:cricket_app/cardDecoration/customTutorialCard.dart';
import 'package:cricket_app/classes/tutorial.dart';
import 'package:flutter/material.dart';
import 'package:cricket_app/header/header.dart';

//Used to handle the tutorial page
class TutorialDetails extends StatelessWidget {

  //Stores passed in goal information in goal variable
  String type;
  int index;
  var width;

  TutorialDetails({Key key, this.type, this.index}) : super(key: key);

    @override
  Widget build(BuildContext context) {
    width = MediaQuery.of(context).size.width;
    return Scaffold(
      //This helps to avoid page overflow issues
      resizeToAvoidBottomPadding: false,
      body: Column(
        children: <Widget>[
          setHeader(context),
          Container(
            //Create a form using dialogBox.dart implementation but not a dialog box.
            child: createList(),
          )
      ],) 
      
      
    );
  }

  Widget setHeader(BuildContext context) {
    Widget finalHeader;
    if (type == "Bowling Skills") {
      finalHeader = Header().createHeader(context, 10);
    } else if (type == "Batting Skills") {
      finalHeader = Header().createHeader(context, 11);
    } else if (type == "Fielding Skills") {
      finalHeader = Header().createHeader(context, 12);
    } else if (type == "Mental Training") {
      finalHeader = Header().createHeader(context, 13);
    } else if (type == "Physical Training") {
      finalHeader = Header().createHeader(context, 14);
    }
    return finalHeader;
  }

  Widget createList() {
    Widget finalOutput;
    if (type == "Bowling Skills") {
      finalOutput = generateList(bowlingList);
    } else if (type == "Batting Skills") {
      finalOutput = generateList(battingList);
    } else if (type == "Fielding Skills") {
      finalOutput = generateList(fieldingList);
    } else if (type == "Mental Training") {
      finalOutput = generateList(mentalList);
    } else if (type == "Physical Training") {
      finalOutput = generateList(physicalList);
    }
    return finalOutput;
  }

  Widget generateList(List<Tutorial> currentList) {
    
    return Expanded(
    //Used to dynamically render the goals in a list format
      child: new ListView.builder (
        physics: ScrollPhysics(),
        itemCount: currentList.length,
        itemBuilder: (BuildContext ctxt, int index) {
          return CustomTutorialCard(object: currentList[index],width: width);  
        }
      )
    );
  }
}