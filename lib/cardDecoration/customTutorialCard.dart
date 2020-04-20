import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class CustomTutorialCard extends StatefulWidget {

  final object;
  final width;

  const CustomTutorialCard({Key key, this.object, this.width}) : super(key: key);

    _MyCustomTutorialCardState createState() => new _MyCustomTutorialCardState();
}

class _MyCustomTutorialCardState extends State<CustomTutorialCard> {
  double width;
  //background color
  var backgroundColor = Colors.cyan[100];

  //Card is the colorful display next to the tutorial information
  Widget _card({Color primaryColor = Colors.redAccent,String imgPath,Widget backWidget}) {
    return Container(
        height: 100,
        width: widget.width * .34,
        margin: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        decoration: BoxDecoration(
            color: primaryColor,
            borderRadius: BorderRadius.all(Radius.circular(20)),
            boxShadow: <BoxShadow>[
              BoxShadow(
                  offset: Offset(0, 5),
                  blurRadius: 10,
                  color: Color(0x12000000))
            ]),
        child: ClipRRect(
          borderRadius: BorderRadius.all(Radius.circular(20)),
          child: backWidget,
        ));
  }

  //Used to render the tutorial card card
  Widget _decorationContainer() {

    return Stack(
      children: <Widget>[
        //This is used to render the process.png image instead of previous card decoration
        Positioned(
          top: 0,
          bottom: 0,
          right: 0,
          left: 0,
          child: Image.asset('assets/images/tutorial/tutorial.png'),
        ),
      ],
    );
  }

  //Used to create the display for all the tutorial information itself
  Widget createCustomTutorialCard() {
    width = widget.width;
    return Container(
        height: 200,
        width: width - 100,
        child: Row(
          children: <Widget>[
            AspectRatio(
              aspectRatio: .6,
              child: _card(primaryColor: backgroundColor, backWidget: _decorationContainer()),
            ),
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
                SizedBox(height: 25),
                Text(widget.object.summary,
                    style: TextStyle(fontSize: 14).copyWith(
                        fontSize: 14, color: Colors.black)),
                SizedBox(height: 15),

                RichText(
                  text: new TextSpan(
                    text: widget.object.url,
                    style: new TextStyle(color: Colors.blue),
                    recognizer: new TapGestureRecognizer()
                        ..onTap = () { launch(widget.object.url);
                        }
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
    return createCustomTutorialCard();
  }
}