import 'package:flutter/material.dart';
import 'package:cricket_app/navigation/bottom_navigation.dart';
import 'package:cricket_app/header/header.dart';


//Used to handle the tutorial page
class Tutorials extends StatelessWidget {
  var width;
  static final showGrid = true; // Set to false to show ListView
  var imageList = { "Bowling Skills": "assets/images/tutorial/bowling_steyn.jpg", "Batting Skills": "assets/images/tutorial/brian_batting.jpg", "Fielding Skills": "assets/images/tutorial/fielding.jpg", "Mental Training": "assets/images/tutorial/mental_training.jpg", "Physical Training": "assets/images/tutorial/cardio.jpeg"};

  @override
  Widget build(BuildContext context) {
    width = MediaQuery.of(context).size.width;
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      bottomNavigationBar: Bottom_Navigation().createBottomNavigation(context, 3),
      body: Column(
        children: <Widget>[
          Header().createHeader(context, 4),
          Expanded(
            child:
              Center(child: _buildGrid()),
          )
        ],
      )
    );
  }

  // #docregion grid
  Widget _buildGrid() => GridView.extent(
      maxCrossAxisExtent: 250,
      padding: const EdgeInsets.all(4),
      mainAxisSpacing: 4,
      crossAxisSpacing: 4,
      children: _buildGridTileCards());

  List<Container> _buildGridTileCards() {
    List<Container> finalList = [];

    for (MapEntry e in imageList.entries) {
      finalList.add(createTutorialTile(e));  
    }
    print(finalList.length.toString());
    return finalList;
  }

  createTutorialTile(MapEntry entry) {
    return Container(
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
          bottom: 20,
          right: 0,
          left: 0,
          child: Image.asset(entry.value, fit: BoxFit.fill),
        ),
        Positioned(
          top: 150,
          bottom: 0,
          right: 0,
          left: width * .09,
          child: Text(entry.key, style: TextStyle(color: Colors.black,fontSize: 16)),
        ),
      ],
    ),
    )
    );
  }



}



