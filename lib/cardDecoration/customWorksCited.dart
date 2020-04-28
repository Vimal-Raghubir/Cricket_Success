import 'package:flutter/material.dart';

class CustomWorksCitedCard extends StatefulWidget {

  final object;
  final width;

  const CustomWorksCitedCard({Key key, this.object, this.width}) : super(key: key);

    _MyCustomWorksCitedCardState createState() => new _MyCustomWorksCitedCardState();
}

class _MyCustomWorksCitedCardState extends State<CustomWorksCitedCard> {
  double width;

  //Used to create the display for all the tutorial information itself
  Widget createCustomWorksCitedCard() {
    width = widget.width;
    return Container(
        height: 125,
        width: width - 10,
        decoration: BoxDecoration(
          border: Border(bottom: BorderSide(color: Colors.black))
        ),
        child: Row(
          children: <Widget>[
            Expanded(
                child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                SizedBox(height: 15),
                Container(
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    children: <Widget>[
                      Expanded(
                        child: Text(widget.object.name,
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 18,
                                fontWeight: FontWeight.bold)),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 15),
                Expanded(child: 
                  Text(widget.object.credits,
                    style: TextStyle(fontSize: 14, fontStyle: FontStyle.italic).copyWith(
                    fontSize: 14, color: Colors.black)
                  )
                ),
              ],
            ))
          ],
        ));
      }

  Widget build(BuildContext context) {
    if (this.mounted) {
      setState(() {});
    }
    return createCustomWorksCitedCard();
  }
}