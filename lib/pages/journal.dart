import 'package:cricket_app/pages/createjournal.dart';
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

  initState() {
    super.initState();
    //For the initial state you will wait for the journal list to be updated then generate the UI
    refresh();
  }

  refresh() async {
    //Had to make read asynchronous to wait on the results of the database retrieval before rendering the UI
    await _read();
    print("refresh is called");
    setState(() {});
  }


  @override
  Widget build(BuildContext context) {
    width = MediaQuery.of(context).size.width;
    return Scaffold(
      bottomNavigationBar: Bottom_Navigation().createBottomNavigation(context, 3),
      body: Column(
        children: <Widget> [
          Header().createHeader(context, 5),
          Container(
            padding: const EdgeInsets.all(32),
            child: Text(
              'Please see below!',
              softWrap: true,
            ),
          ),
          Expanded (
            //Used to dynamically render the journals in a list format
                child: new ListView.builder (
                  physics: BouncingScrollPhysics(),
                  itemCount: journals.length,
                  itemBuilder: (BuildContext ctxt, int index) {
                    //Need to change below
                    return InkWell(
                      //Need to wait for result of updates
                      onTap: () async {
                        //Pass the journal information to the journalDetails.dart page
                        await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => JournalDetails(
                            //Helps to prevent range issues
                            journal: journals?.elementAt(index) ?? "",
                            )
                          ),
                        );
                        //Then call refresh to rebuild widget
                        refresh();
                        //Add other logic here
                      },
                      //Render custom card for each journal
                      child: CustomCard(object: journals[index], width: width,type: "journal"),
                    );  
                  }
                )
              ),
        ]
      ),

      floatingActionButton: FloatingActionButton (
        //Need to wait on results from new journal creation
        onPressed: () async {
          await Navigator.push(
            context,
              MaterialPageRoute(
                builder: (context) => NewJournal(
                  //Helps to prevent range issues
                  journal: JournalInformation(),
                )
              ),
          );
          //Need to rebuild the widget
          refresh();
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