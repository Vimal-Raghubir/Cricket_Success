import 'package:flutter/material.dart';
import 'package:cricket_app/database/database.dart';
import 'package:cricket_app/classes/statistics.dart';
import 'package:toast/toast.dart';

class StatisticManagement extends StatefulWidget {
  //Receives either a default Statistic or already built Statistic and stores it in passedStatistic
  final passedStatistic;

  //This describes the type of page. Either a dialog or something else
  final type;

  const StatisticManagement({Key key, this.notifyParent, this.passedStatistic, this.type}) : super(key: key);

  @override
  _MyStatisticManagementState createState() => new _MyStatisticManagementState();

  //This function is used to call the Statistic page refresh function to setState
  final Function() notifyParent;
}


class _MyStatisticManagementState extends State<StatisticManagement> {
  var selectedStatisticName;
  var selectedStatisticRuns;
  var selectedStatisticBallsFaced;
  var selectedStatisticNotOut;
  var selectedStatisticWickets;
  var selectedStatisticOvers;

  var selectedStatisticRunsConceeded;
  var selectedStatisticRunOuts;
  var selectedStatisticCatches;
  var selectedStatisticStumpings;
  var selectedStatisticRating;
  //Stores all Statistic names for the Statistic name field. Used to prevent duplicate Statistic names
  List statisticNames = [];
  int index;
  final List<String> notOutOptions = ['No', 'Yes'];
  bool batting = false;
  bool bowling = false;
  bool fielding = false;

  //Key used to validate form input
  final _formKey = GlobalKey<FormState>();

  @protected
  @mustCallSuper
  initState() {
    super.initState();
    //Extract passed in Statistic and initializes dynamic variables with their values. Starting point
    selectedStatisticName = widget.passedStatistic.name;
    selectedStatisticRuns = widget.passedStatistic.runs;
    selectedStatisticBallsFaced = widget.passedStatistic.balls_faced;
    selectedStatisticNotOut = widget.passedStatistic.not_out;
    selectedStatisticWickets = widget.passedStatistic.wickets;

    selectedStatisticOvers = widget.passedStatistic.overs;
    selectedStatisticRunsConceeded = widget.passedStatistic.runs_conceeded;
    selectedStatisticRunOuts = widget.passedStatistic.run_outs;
    selectedStatisticCatches = widget.passedStatistic.catches;
    selectedStatisticStumpings = widget.passedStatistic.stumpings;
    selectedStatisticRating = widget.passedStatistic.rating;
    //Retrieves a list of all Statisticnames in the database
    _getStatisticNames();
  }

Widget createStatisticNameField() {
  return TextFormField(
    textCapitalization: TextCapitalization.words,
    //Starts with the passed in Statistic as initial value
    initialValue: widget.passedStatistic.name,
    keyboardType: TextInputType.text ,
    decoration: InputDecoration(
      labelText: "What would you like to name this match?",
      hintText: "e.g. Match 3",
    ),
    textInputAction: TextInputAction.next,
    //Used to validate user input
    validator: (value) {
      RegExp regex = new RegExp(r"^[a-zA-Z0-9\s]*$");
      //Checks if the value is empty or else return error message
      if (value.isEmpty) {
        return 'Please enter a value';
      } else if(!regex.hasMatch(value)) {
        return 'Invalid characters detected';
      
      //Checks if the database Statistic names contain the passed in value to prevent duplicates and you are trying to create a new Statistic
      } else if(statisticNames.contains(value.toLowerCase()) && widget.type == "new") {
        print("CHECK IS WORKING");
        return 'A match with the same name already exists';
      //Checks if the statistic name already exists in the database and the initial statistic name has been modified. This guards against changing an existing statistic name to another existing statistic name
      } else if (statisticNames.contains(value.toLowerCase()) && widget.passedStatistic.name != value) {
        return 'An existing match has that name';
      } else {
        return null;
      }
    },
    onSaved: (value)=> selectedStatisticName = value,
  );
}

Widget createTextHeader(String message) {
  //Allows dynamic dropdown header
  return Container(
    padding: const EdgeInsets.all(12),
    child: Text(
      message,
      softWrap: true,
    ),
  );
}


Widget createRunsField() {
  return TextFormField(
    textCapitalization: TextCapitalization.words,
    //Start with passed in statistic description
    initialValue: widget.passedStatistic.runs.toString(),   //widget.passedStatistic.runs
    keyboardType: TextInputType.text,
    decoration: InputDecoration(
      labelText: "How much runs did you score?",
    ),
    textInputAction: TextInputAction.next,
    validator: (value) {
      RegExp regex = new RegExp(r"^[0-9\s]*$");
      if (value.isEmpty) {
        return 'Please enter a value';
      } else if(!regex.hasMatch(value)) {
        return 'Invalid characters detected';
      }
      else {
        return null;
      }
    },
    onSaved: (value)=> selectedStatisticRuns = value as int,
  );
}

Widget createBallsFacedField() {
  return TextFormField(
    textCapitalization: TextCapitalization.words,
    //Start with passed in statistic description
    initialValue: widget.passedStatistic.balls_faced.toString(),
    keyboardType: TextInputType.text,
    decoration: InputDecoration(
      labelText: "How much balls did you face?",
    ),
    textInputAction: TextInputAction.next,
    validator: (value) {
      RegExp regex = new RegExp(r"^[0-9\s]*$");
      if (value.isEmpty) {
        return 'Please enter a value';
      } else if(!regex.hasMatch(value)) {
        return 'Invalid characters detected';
      }
      else {
        return null;
      }
    },
    onSaved: (value)=> selectedStatisticBallsFaced = value as int,
  );
}

Widget checkNotOut() {
  //This is used to make the dropdown menu look like a form
  return InputDecorator(
    decoration: InputDecoration(
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(5.0))),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          hint: Text("No"),
          value: notOutOptions[selectedStatisticNotOut],
          isDense: true,
          onChanged: (String newValue) {
            setState(() {
              
              if (newValue == 'No') {
                selectedStatisticNotOut = 0;
              } else {
                selectedStatisticNotOut = 1;
              }
              print(selectedStatisticNotOut);
            });
          },
          items: notOutOptions.map((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value),
            );
          }).toList(),
          ),
        ),
    );
}

Widget overSlider(int minimum, int maximum, int divisions) {
  return Slider(
    value: selectedStatisticOvers.toDouble(),
    onChanged: (newRating) {
      setState(() {
        selectedStatisticOvers = newRating.toInt();
      });
    },
    min: minimum.toDouble(),
    max: maximum.toDouble(),
    //Divisions help to show a label above the slider
    divisions: divisions,
    label: "$selectedStatisticOvers",
  );
}

Widget wicketSlider(int minimum, int maximum, int divisions) {
  return Slider(
    value: selectedStatisticWickets.toDouble(),
    onChanged: (newRating) {
      setState(() {
        selectedStatisticWickets = newRating.toInt();
      });
    },
    min: minimum.toDouble(),
    max: maximum.toDouble(),
    //Divisions help to show a label above the slider
    divisions: divisions,
    label: "$selectedStatisticWickets",
  );
}

Widget createRunsConceededField() {
  return TextFormField(
    textCapitalization: TextCapitalization.words,
    //Start with passed in statistic description
    initialValue: widget.passedStatistic.runs_conceeded.toString(),
    keyboardType: TextInputType.text,
    decoration: InputDecoration(
      labelText: "How much runs did you conceed?",
    ),
    textInputAction: TextInputAction.next,
    validator: (value) {
      RegExp regex = new RegExp(r"^[0-9\s]*$");
      if (value.isEmpty) {
        return 'Please enter a value';
      } else if(!regex.hasMatch(value)) {
        return 'Invalid characters detected';
      }
      else {
        return null;
      }
    },
    onSaved: (value)=> selectedStatisticRunsConceeded = value as int,
  );
}

Widget catchesSlider(int minimum, int maximum, int divisions) {
  return Slider(
    value: selectedStatisticCatches.toDouble(),
    onChanged: (newRating) {
      setState(() {
        selectedStatisticCatches = newRating.toInt();
      });
    },
    min: minimum.toDouble(),
    max: maximum.toDouble(),
    //Divisions help to show a label above the slider
    divisions: divisions,
    label: "$selectedStatisticCatches",
  );
}

Widget runOutSlider(int minimum, int maximum, int divisions) {
  return Slider(
    value: selectedStatisticRunOuts.toDouble(),
    onChanged: (newRating) {
      setState(() {
        selectedStatisticRunOuts = newRating.toInt();
      });
    },
    min: minimum.toDouble(),
    max: maximum.toDouble(),
    //Divisions help to show a label above the slider
    divisions: divisions,
    label: "$selectedStatisticRunOuts",
  );
}

Widget stumpingSlider(int minimum, int maximum, int divisions) {
  return Slider(
    value: selectedStatisticStumpings.toDouble(),
    onChanged: (newRating) {
      setState(() {
        selectedStatisticStumpings = newRating.toInt();
      });
    },
    min: minimum.toDouble(),
    max: maximum.toDouble(),
    //Divisions help to show a label above the slider
    divisions: divisions,
    label: "$selectedStatisticStumpings",
  );
}

Widget submitButton(String buttonText) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 16.0),
    child: RaisedButton(
      onPressed: () {
      // Validate returns true if the form is valid
      if (_formKey.currentState.validate()) {
        _formKey.currentState.save();
        //Create a new statistic object with the parameters
        StatisticInformation newStatistic = new StatisticInformation(selectedStatisticName, selectedStatisticRuns, selectedStatisticBallsFaced, selectedStatisticNotOut, selectedStatisticWickets, selectedStatisticOvers, selectedStatisticRunsConceeded, selectedStatisticRunOuts, selectedStatisticCatches, selectedStatisticStumpings, selectedStatisticRating);
        if (buttonText == "Submit") {
            //Insert the newStatistic into the database
          _save(newStatistic);
          //Calls the function in the Statistics.dart class to refresh the Statistics page with setState. This is used to fix cards not appearing on the Statistics page after submitting this form
          widget.notifyParent();
          //Navigates back to the previous page and in this case the Statistics page
          Navigator.pop(context);
          //Toast message to indicate the Statistic was created
          Toast.show("Successfully created your Match Details!", context, duration: Toast.LENGTH_SHORT, gravity:  Toast.BOTTOM);
        } else if (buttonText == "Update") {
          //Retrieve the index of the passed in Statistic
          index = widget.notifyParent();

          //Updates Statistic with newStatistic content and id
          _updateStatistic(newStatistic, index);
          //Goes back to previous page which in this case is Statistics.dart
          Navigator.pop(context);
          //Toast message to indicate the Statistic was updated
          Toast.show("Successfully updated your Statistic!", context, duration: Toast.LENGTH_SHORT, gravity:  Toast.BOTTOM);
        } 
      }                     
    },
      child: Text(buttonText),
    ),
  );
}

Widget deleteButton(BuildContext context) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 16.0),
    child: RaisedButton(
      onPressed: () {
        //confirmDelete(context);
        _deleteStatistic(widget.passedStatistic.id);
        Navigator.pop(context);
      },
      child: Text("Delete")
    )
    
  );
}

Widget showBattingDetails() {
  return ExpansionTile(
    title: Text("                 Did you bat during this match?"),
    children: <Widget>[
      createRunsField(),
      createBallsFacedField(),
      createTextHeader("Were you not out in this innings?"),
      checkNotOut()
    ],
  ); 
}

Widget showBowlingDetails() {
  return ExpansionTile(
    title: Text("                Did you bowl during this match?"),
    children: <Widget>[
      createTextHeader("How many overs did you bowl?"),
      overSlider(0, 50, 50),
      createTextHeader("How many wickets did you take?"),
      wicketSlider(0, 10, 10),
      createRunsConceededField(),
    ],
  );
  
}

Widget showFieldingDetails() {
  return ExpansionTile(
    title: Text("              Did you get any fielding dismissals?"),
    children: <Widget>[
      createTextHeader("Did you take any catches? If yes then how many?"),
      catchesSlider(0, 10, 10),
      createTextHeader("Did you initiate any run outs? If yes then how many?"),
      runOutSlider(0, 10, 10),
      createTextHeader("Did you have any stumpings? If yes then how many?"),
      stumpingSlider(0, 10, 10),
    ],
  );
  
}

//This widget is responsible for creating all the contents of the form
Widget newPage() {
  return Column(
    children: <Widget>[
      createStatisticNameField(),
      showBattingDetails(),

      showBowlingDetails(),

      showFieldingDetails(),
      submitButton("Submit"),    
    ],
  );
}

//This widget is responsible for creating all the contents of the form
Widget updatePage() {
  return Column(
    children: <Widget>[
      createStatisticNameField(),
      showBattingDetails(),
      showBowlingDetails(),
      showFieldingDetails(),
      ButtonBar(
        alignment: MainAxisAlignment.center,
        children: <Widget> [
          deleteButton(context),
          submitButton("Update")
        ]
      ),    
    ],
  );
}
  
  Widget build(BuildContext context) {
    //If the passed in widget type is a new Statistic then the call is being made from Statistics.dart
    print(selectedStatisticName);
    if (widget.type == "new") {
      return Expanded(
        child: ListView(
        children: <Widget>[
          Form(
            key: _formKey,
            //Pass in correct variables for assignment
            child: newPage()
          ),
        ],
        ),
      ); 
    // If the passed in widget type is not a new Statistic then it comes from StatisticDetails.dart
    } else {
      return Expanded(
        child: ListView(
          children: <Widget>[
            Form(
              key: _formKey,
              child: updatePage()
            )
          ],
        ),
      );  
    }
  }
  
  void dispose() {
    super.dispose();
  }
  //Function to insert a Statistic into the database
  _save(StatisticInformation statistic) async {
    DatabaseHelper helper = DatabaseHelper.instance;
    int id = await helper.insertStatistic(statistic);
    print('inserted row: $id');
  }



  //Function to retrieve a Statistic by id and update in the database
  _updateStatistic(StatisticInformation statistic, int index) async {
    DatabaseHelper helper = DatabaseHelper.instance;
    await helper.updateStatistics(statistic, index);
  }

  //Function to get all statistic names in the database
  _getStatisticNames() async {
    DatabaseHelper helper = DatabaseHelper.instance;
    statisticNames = await helper.getStatisticNames();
  }

  _deleteStatistic(int id) async {
    DatabaseHelper helper = DatabaseHelper.instance;
    await helper.deleteStatistic(id);
  }
}  