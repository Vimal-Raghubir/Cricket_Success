import 'package:cricket_app/pages/goals.dart';
import 'package:cricket_app/pages/journals.dart';
import 'package:cricket_app/pages/statistics.dart';
import 'package:cricket_app/pages/tutorialDetails.dart';
import 'package:cricket_app/pages/tutorials.dart';
import 'package:flutter/material.dart';

class CustomGridTile {
    var tutorialList = { "Bowling Skills": "assets/images/tutorial/bowling_steyn.jpg", "Batting Skills": "assets/images/tutorial/brian_batting.jpg", "Fielding Skills": "assets/images/tutorial/fielding.jpg", "Mental Training": "assets/images/tutorial/mental_training.jpg", "Physical Training": "assets/images/tutorial/cardio.jpeg"};
    var mainPageList = { "Goals": "assets/images/homepage/goal.png", "Journal": "assets/images/homepage/journal.png", "Tutorials": "assets/images/homepage/tutorial.png", "Statistics": "assets/images/homepage/statistic.png"};
    var height = 0.0;
    var width = 0.0;

  Widget buildGrid(BuildContext context, int type) {
    width = MediaQuery.of(context).size.width;
    height = MediaQuery.of(context).size.height;
    return GridView.extent(
      maxCrossAxisExtent: 250,
      padding: const EdgeInsets.all(4),
      mainAxisSpacing: 4,
      crossAxisSpacing: 4,
      children: _buildGridTileCards(context, type)
    );
  }

  List<GestureDetector> _buildGridTileCards(BuildContext context, int type) {
    List<GestureDetector> finalList = [];
    Map<String, String> currentList = {};

    if (type == 0) {
      currentList = tutorialList;
      for (MapEntry e in currentList.entries) {
        finalList.add(createTutorialTile(e, context));  
      }
    } else {
      currentList = mainPageList;
      for (MapEntry e in currentList.entries) {
        finalList.add(createMainPageTile(e, context));
      }
    }
    return finalList;
  }

  Widget createTutorialTile(MapEntry entry, BuildContext context) {
    return GestureDetector(
      onTap: () async {
        await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => TutorialDetails(
              //Helps to prevent range issues
              type: entry.key,
            )
          ),
        );
      },
      child:  Container(
        height: 300,
        width: width * .34,
        margin: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(Radius.circular(20)),
            boxShadow: <BoxShadow>[
              BoxShadow(
                  offset: Offset(0, 5),
                  blurRadius: 10,
                  color: Color(0x12000000))
            ]),
        child: ClipRRect(
          borderRadius: BorderRadius.all(Radius.circular(20)),
          child: Stack(
      children: <Widget>[
        //This is used to render the process.png image instead of previous card decoration
        Positioned(
          top: 0,
          bottom: height * 0.04,
          right: 0,
          left: 0,
          child: Image.asset(entry.value, fit: BoxFit.fill),
        ),
        Positioned(
          top: height * 0.19,
          bottom: 0,
          right: 0,
          left: width * .08,
          child: Text(entry.key, style: TextStyle(color: Colors.black,fontSize: 16)),
        ),
      ],
    ),
    )
    ),
    );
  }

  Widget createMainPageTile(MapEntry entry, BuildContext context) {
    return GestureDetector(
      onTap: () async {
        if (entry.key == "Goals") {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => Goals()),
          );
        } else if (entry.key == "Journal") {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => Journal()),
          );
        } else if (entry.key == "Tutorials") {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => Tutorials()),
          );
        } else if (entry.key == "Statistics") {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => Statistics()),
          );
        }
      },
      child:  Container(
        height: 300,
        width: width * .34,
        margin: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(Radius.circular(20)),
            boxShadow: <BoxShadow>[
              BoxShadow(
                  offset: Offset(0, 5),
                  blurRadius: 10,
                  color: Color(0x12000000))
            ]),
        child: ClipRRect(
          borderRadius: BorderRadius.all(Radius.circular(20)),
          child: Stack(
      children: <Widget>[
        //This is used to render the process.png image instead of previous card decoration
        Positioned(
          top: 0,
          bottom: height * 0.04,
          right: 0,
          left: 0,
          child: Image.asset(entry.value, fit: BoxFit.fill),
        ),
        Positioned(
          top: height * 0.19,
          bottom: 0,
          right: 0,
          left: width * .15,
          child: Text(entry.key, style: TextStyle(color: Colors.black,fontSize: 16)),
        ),
      ],
    ),
    )
    ),
    );
  }
}