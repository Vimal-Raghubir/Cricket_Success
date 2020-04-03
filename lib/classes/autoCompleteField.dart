import 'package:flutter/material.dart';
import 'package:cricket_app/database/database.dart';
import 'package:autocomplete_textfield/autocomplete_textfield.dart';

class AutoComplete extends StatefulWidget {

  @override
  _AutoCompleteState createState() => new _AutoCompleteState();
}

class _AutoCompleteState extends State<AutoComplete> {

  _AutoCompleteState();
  TextEditingController controller = new TextEditingController();
  AutoCompleteTextField searchTextField;
  final myKey = GlobalKey<AutoCompleteTextFieldState<String>>();
  List<String> goalNames = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: new Center(
            child: new Column(
                children: <Widget>[
                  new Column(children: <Widget>[
                    searchTextField = AutoCompleteTextField<String>(
                      style: TextStyle(color: Colors.black, fontSize: 14.0),
                      decoration: new InputDecoration(
                        suffixIcon: Container(
                          width: 85.0,
                          height: 60.0,
                        ),
                        contentPadding: EdgeInsets.fromLTRB(10.0, 30.0, 10.0, 20.0),
                        filled: true,
                        hintText: 'Search Goal Name',
                        hintStyle: TextStyle(color: Colors.black)),

                      itemSubmitted: (item) {
                        setState(() => searchTextField.textField.controller.text = item);
                      },
                      key: myKey, 
                      suggestions: goalNames, 
                      itemBuilder: (context, item) {
                        print(item);
                        return Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text(item, style: TextStyle(fontSize: 14.0)),
                          ],
                        );
                      }, 
                      itemSorter: (a, b) {
                        print(a);
                        return a.compareTo(b);
                      },
                      itemFilter: (item, query) {
                        print(item);
                        return item.toLowerCase().startsWith(query.toLowerCase());
                      }
                    )
                 ]),
                ]
            )
          )
        );
  }

    //Function to get all goal names in the database
  _getGoalNames() async {
    DatabaseHelper helper = DatabaseHelper.instance;
    goalNames = await helper.getGoalNames();
  }
}