import 'package:cricket_app/administration/journalDialog.dart';
import 'package:flutter/material.dart';
import 'package:cricket_app/navigation/bottom_navigation.dart';
import 'package:cricket_app/header/header.dart';
import 'package:cricket_app/classes/journalInformation.dart';
import 'package:cricket_app/pages/journalDetails.dart';
import 'package:cricket_app/cardDecoration/customCard.dart';
import 'package:cricket_app/database/database.dart';


List<JournalInformation> journals = [];

//Used to handle the tutorial page
class Journal extends StatefulWidget {
  _JournalState createState() => _JournalState();
}

class _JournalState extends State<Journal> {

  double width;

  refresh() {
    setState(() {});
    _read();
  }


  @override
  Widget build(BuildContext context) {
    _read();
    width = MediaQuery.of(context).size.width;
    return Scaffold(
      bottomNavigationBar: Bottom_Navigation().createBottomNavigation(context, 3),
      body: Column(
        children: <Widget> [
          Header().createHeader(context, 3),
          Container(
            padding: const EdgeInsets.all(32),
            child: Text(
              'Please see below!',
              softWrap: true,
            ),
          ),

          Expanded(
                //Used to dynamically render the journals in a list format
                child: new ListView.builder (
                  physics: BouncingScrollPhysics(),
                  itemCount: journals.length,
                  itemBuilder: (BuildContext ctxt, int index) {
                    //Need to change below
                    return InkWell(
                      onTap: () {
                        //Pass the journal information to the journalDetails.dart page
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => JournalDetails(
                            //Helps to prevent range issues
                            journal: journals?.elementAt(index) ?? "",
                            )
                          ),
                        );
                        //Add other logic here
                      },
                      //Render custom card for each journal
                      child: CustomCard().createCustomJournalCard(journals[index], width),
                    );  
                  }
                )
              ),
        ]
      ),

      floatingActionButton: FloatingActionButton (
        onPressed: () {
          //Creates the dialog whenever the button is pressed
          showDialog(
            context: context,
            builder: (_) {
              //Passes a function pointer to my custom dialog class so the dialog class can call setState on this page.
              JournalInformation defaultJournal = new JournalInformation();
              return JournalDialog(notifyParent: refresh, passedJournal: defaultJournal, type: "dialog");
            });
        },
        child: Icon(Icons.add),
        backgroundColor: Colors.green,
      ),
    );
  }

    //Function to read all journals from the database for rendering
  _read() async {
    DatabaseHelper helper = DatabaseHelper.instance;
    //stores the index of each journalInformation in the database
    journals = await helper.getJournals();
  }
}