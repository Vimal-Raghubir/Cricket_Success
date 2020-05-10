import 'package:cricket_app/pages/goals.dart';
import 'package:cricket_app/pages/journals.dart';
import 'package:cricket_app/pages/statistics.dart';
import 'package:cricket_app/pages/tutorialDetails.dart';
import 'package:cricket_app/pages/tutorials.dart';
import 'package:flutter/material.dart';

class CustomGridTile {
    //var tutorialList = { "Bowling Skills": "assets/images/tutorial/bowling_steyn.jpg", "Batting Skills": "assets/images/tutorial/brian_batting.jpg", "Fielding Skills": "assets/images/tutorial/fielding.jpg", "Mental Training": "assets/images/tutorial/mental_training.jpg", "Physical Training": "assets/images/tutorial/cardio.jpeg"};
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
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.0),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            AspectRatio(
              aspectRatio: 14.0 / 12.0,
              child: Image.asset(
                entry.value,
                fit: BoxFit.fill,
              ),
            ),
            new Padding(
              padding: EdgeInsets.fromLTRB(40.0, 7.5, 4.0, 2.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    entry.key,
                    textAlign: TextAlign.center,
                    overflow: TextOverflow.ellipsis,
                  ),
                ]
              )
            ),
          ]
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
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.0),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            AspectRatio(
              aspectRatio: 14.0 / 12.0,
              child: Image.asset(
                entry.value,
                fit: BoxFit.fill,
              ),
            ),
            new Padding(
              padding: EdgeInsets.fromLTRB(70.0, 7.5, 4.0, 2.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    entry.key,
                    textAlign: TextAlign.center,
                    overflow: TextOverflow.ellipsis,
                  ),
                ]
              )
            ),
          ]
        )
      ),
    );
  }
}