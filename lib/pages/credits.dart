import 'package:cricket_app/cardDecoration/customWorksCited.dart';
import 'package:cricket_app/classes/tutorial.dart';
import 'package:flutter/material.dart';
import 'package:cricket_app/header/header.dart';

//Used to handle the tutorial page
class Credits extends StatelessWidget {

  //Stores passed in goal information in goal variable
  String type;
  var width;

  Credits({Key key, this.type}) : super(key: key);

    @override
  Widget build(BuildContext context) {
    width = MediaQuery.of(context).size.width;
    return Scaffold(
      //This helps to avoid page overflow issues
      resizeToAvoidBottomPadding: false,
      body: Column(
        children: <Widget>[
          Header().createHeader(context, 15),
          Container(
            //Create a form using dialogBox.dart implementation but not a dialog box.
            child: createList(),
          )
      ],) 
      
      
    );
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
          return CustomWorksCitedCard(object: currentList[index],width: width);  
        }
      )
    );
  }
}