import 'package:flutter/material.dart';
import 'package:cricket_app/database/database.dart';
import 'package:cricket_app/classes/statistics.dart';
import 'package:flutter/services.dart';
import 'package:toast/toast.dart';

class StatisticManagement extends StatefulWidget {
  //Receives either a default Statistic or already built Statistic and stores it in passedStatistic
  final passedStatistic;

  //This describes the type of page. Either a dialog or something else
  final type;

  const StatisticManagement(
      {Key key, this.notifyParent, this.passedStatistic, this.type})
      : super(key: key);

  @override
  _MyStatisticManagementState createState() =>
      new _MyStatisticManagementState();

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

  var selectedStatisticRunOutsMissed;
  var selectedStatisticCatchesMissed;
  var selectedStatisticStumpingsMissed;

  var ballError = false;
  var overError = false;
  var runsConceededError = false;
  TextEditingController statisticController;
  //Stores all Statistic names for the Statistic name field. Used to prevent duplicate Statistic names
  List statisticNames = [];
  int index;
  final List<String> notOutOptions = ['No', 'Yes'];
  bool batting = false;
  bool bowling = false;
  bool fielding = false;

  //Key used to validate form input
  final _statisticFormKey = GlobalKey<FormState>();

  @protected
  @mustCallSuper
  initState() {
    super.initState();
    //Extract passed in Statistic and initializes dynamic variables with their values. Starting point
    selectedStatisticName = widget.passedStatistic.name;
    selectedStatisticRuns = widget.passedStatistic.runs;
    selectedStatisticBallsFaced = widget.passedStatistic.ballsFaced;
    selectedStatisticNotOut = widget.passedStatistic.notOut;
    selectedStatisticWickets = widget.passedStatistic.wickets;

    selectedStatisticOvers = widget.passedStatistic.overs;
    selectedStatisticRunsConceeded = widget.passedStatistic.runsConceeded;
    selectedStatisticRunOuts = widget.passedStatistic.runOuts;
    selectedStatisticCatches = widget.passedStatistic.catches;
    selectedStatisticStumpings = widget.passedStatistic.stumpings;
    selectedStatisticRunOutsMissed = widget.passedStatistic.runOutsMissed;

    selectedStatisticCatchesMissed = widget.passedStatistic.catchesMissed;
    selectedStatisticStumpingsMissed = widget.passedStatistic.stumpingsMissed;
    statisticController =
        new TextEditingController(text: selectedStatisticName);
    //Retrieves a list of all Statisticnames in the database
    _getStatisticNames();
  }

  Widget createStatisticNameField() {
    return TextFormField(
      //Starts with the passed in Statistic as initial value
      controller: statisticController,
      keyboardType: TextInputType.text,
      maxLength: 50,
      decoration: InputDecoration(
        labelText: "What would you like to name this match?",
        hintText: "e.g. Match 3",
      ),
      textInputAction: TextInputAction.next,
      //Used to validate user input
      validator: (value) {
        RegExp regex = new RegExp(r"^[a-zA-Z0-9'\s]*$");
        //Checks if the value is empty or else return error message
        if (value.isEmpty) {
          return 'Please enter a value';
        } else if (!regex.hasMatch(value)) {
          return 'Invalid characters detected';

          //Checks if the database Statistic names contain the passed in value to prevent duplicates and you are trying to create a new Statistic
        } else if (statisticNames.contains(value.toLowerCase()) &&
            widget.type == "new") {
          return 'A match with the same name already exists';
          //Checks if the statistic name already exists in the database and the initial statistic name has been modified. This guards against changing an existing statistic name to another existing statistic name
        } else if (statisticNames.contains(value.toLowerCase()) &&
            widget.passedStatistic.name != value) {
          return 'An existing match has that name';
        } else {
          return null;
        }
      },
      onSaved: (value) => selectedStatisticName = value,
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

  Widget runsSlider(int minimum, int maximum, int divisions) {
    return Slider(
      value: selectedStatisticRuns.toDouble(),
      onChanged: (newRating) {
        if (this.mounted) {
          setState(() {
            selectedStatisticRuns = newRating.toInt();
          });
        }
      },
      min: minimum.toDouble(),
      max: maximum.toDouble(),
      //Divisions help to show a label above the slider
      divisions: divisions,
      label: "$selectedStatisticRuns",
    );
  }

  Widget ballsFacedSlider(int minimum, int maximum, int divisions) {
    return Slider(
      value: selectedStatisticBallsFaced.toDouble(),
      onChanged: (newRating) {
        if (this.mounted) {
          setState(() {
            selectedStatisticBallsFaced = newRating.toInt();
          });
        }
      },
      min: minimum.toDouble(),
      max: maximum.toDouble(),
      //Divisions help to show a label above the slider
      divisions: divisions,
      label: "$selectedStatisticBallsFaced",
    );
  }

  Widget checkNotOut() {
    //This is used to make the dropdown menu look like a form
    return InputDecorator(
      decoration: InputDecoration(
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(5.0))),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          hint: Text("No"),
          value: notOutOptions[selectedStatisticNotOut],
          isDense: true,
          onChanged: (String newValue) {
            if (this.mounted) {
              setState(() {
                if (newValue == 'No') {
                  selectedStatisticNotOut = 0;
                } else {
                  selectedStatisticNotOut = 1;
                }
              });
            }
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
        if (this.mounted) {
          setState(() {
            selectedStatisticOvers = newRating.toInt();
          });
        }
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
        if (this.mounted) {
          setState(() {
            selectedStatisticWickets = newRating.toInt();
          });
        }
      },
      min: minimum.toDouble(),
      max: maximum.toDouble(),
      //Divisions help to show a label above the slider
      divisions: divisions,
      label: "$selectedStatisticWickets",
    );
  }

  Widget runsConceededSlider(int minimum, int maximum, int divisions) {
    return Slider(
      value: selectedStatisticRunsConceeded.toDouble(),
      onChanged: (newRating) {
        if (this.mounted) {
          setState(() {
            selectedStatisticRunsConceeded = newRating.toInt();
          });
        }
      },
      min: minimum.toDouble(),
      max: maximum.toDouble(),
      //Divisions help to show a label above the slider
      divisions: divisions,
      label: "$selectedStatisticRunsConceeded",
    );
  }

  Widget catchesSlider(int minimum, int maximum, int divisions) {
    return Slider(
      value: selectedStatisticCatches.toDouble(),
      onChanged: (newRating) {
        if (this.mounted) {
          setState(() {
            selectedStatisticCatches = newRating.toInt();
          });
        }
      },
      min: minimum.toDouble(),
      max: maximum.toDouble(),
      //Divisions help to show a label above the slider
      divisions: divisions,
      label: "$selectedStatisticCatches",
    );
  }

  Widget catchesMissedSlider(int minimum, int maximum, int divisions) {
    return Slider(
      value: selectedStatisticCatchesMissed.toDouble(),
      onChanged: (newRating) {
        if (this.mounted) {
          setState(() {
            selectedStatisticCatchesMissed = newRating.toInt();
          });
        }
      },
      min: minimum.toDouble(),
      max: maximum.toDouble(),
      //Divisions help to show a label above the slider
      divisions: divisions,
      label: "$selectedStatisticCatchesMissed",
    );
  }

  Widget runOutSlider(int minimum, int maximum, int divisions) {
    return Slider(
      value: selectedStatisticRunOuts.toDouble(),
      onChanged: (newRating) {
        if (this.mounted) {
          setState(() {
            selectedStatisticRunOuts = newRating.toInt();
          });
        }
      },
      min: minimum.toDouble(),
      max: maximum.toDouble(),
      //Divisions help to show a label above the slider
      divisions: divisions,
      label: "$selectedStatisticRunOuts",
    );
  }

  Widget runOutMissedSlider(int minimum, int maximum, int divisions) {
    return Slider(
      value: selectedStatisticRunOutsMissed.toDouble(),
      onChanged: (newRating) {
        if (this.mounted) {
          setState(() {
            selectedStatisticRunOutsMissed = newRating.toInt();
          });
        }
      },
      min: minimum.toDouble(),
      max: maximum.toDouble(),
      //Divisions help to show a label above the slider
      divisions: divisions,
      label: "$selectedStatisticRunOutsMissed",
    );
  }

  Widget stumpingSlider(int minimum, int maximum, int divisions) {
    return Slider(
      value: selectedStatisticStumpings.toDouble(),
      onChanged: (newRating) {
        if (this.mounted) {
          setState(() {
            selectedStatisticStumpings = newRating.toInt();
          });
        }
      },
      min: minimum.toDouble(),
      max: maximum.toDouble(),
      //Divisions help to show a label above the slider
      divisions: divisions,
      label: "$selectedStatisticStumpings",
    );
  }

  Widget stumpingMissedSlider(int minimum, int maximum, int divisions) {
    return Slider(
      value: selectedStatisticStumpingsMissed.toDouble(),
      onChanged: (newRating) {
        if (this.mounted) {
          setState(() {
            selectedStatisticStumpingsMissed = newRating.toInt();
          });
        }
      },
      min: minimum.toDouble(),
      max: maximum.toDouble(),
      //Divisions help to show a label above the slider
      divisions: divisions,
      label: "$selectedStatisticStumpingsMissed",
    );
  }

  Widget showBallError() {
    return Visibility(
      child: Text("You forgot to set the number of balls you faced!",
          style: TextStyle(color: Colors.red)),
      visible: ballError,
    );
  }

  Widget showOverError() {
    return Visibility(
      child: Text("You forgot to set the number of overs you bowled!",
          style: TextStyle(color: Colors.red)),
      visible: overError,
    );
  }

  Widget showRunsConceededError() {
    return Visibility(
      child: Text("You forgot to set the number of runs conceeded!",
          style: TextStyle(color: Colors.red)),
      visible: runsConceededError,
    );
  }

  bool validateBowling() {
    bool check = true;
    if (selectedStatisticOvers == 0 &&
        selectedStatisticRunsConceeded == 0 &&
        selectedStatisticWickets != 0) {
      check = false;
      overError = true;
      runsConceededError = true;
    } else if (selectedStatisticOvers == 0 &&
        selectedStatisticRunsConceeded != 0) {
      check = false;
      overError = true;
      runsConceededError = false;
    } else {
      overError = false;
      runsConceededError = false;
    }
    return check;
  }

  bool validateBatting() {
    bool check = true;
    if (selectedStatisticBallsFaced == 0 && selectedStatisticRuns != 0) {
      check = false;
      ballError = true;
    } else {
      ballError = false;
    }
    return check;
  }

  Widget submitButton(String buttonText) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: RaisedButton(
        onPressed: () {
          // Validate returns true if the form is valid
          if (_statisticFormKey.currentState.validate() &&
              validateBowling() &&
              validateBatting()) {
            _statisticFormKey.currentState.save();
            //Create a new statistic object with the parameters
            StatisticInformation newStatistic = new StatisticInformation(
                selectedStatisticName,
                selectedStatisticRuns,
                selectedStatisticBallsFaced,
                selectedStatisticNotOut,
                selectedStatisticWickets,
                selectedStatisticOvers,
                selectedStatisticRunsConceeded,
                selectedStatisticRunOuts,
                selectedStatisticCatches,
                selectedStatisticStumpings,
                selectedStatisticRunOutsMissed,
                selectedStatisticCatchesMissed,
                selectedStatisticStumpingsMissed);
            if (buttonText == "Submit") {
              //Insert the newStatistic into the database
              _save(newStatistic);
              //Calls the function in the Statistics.dart class to refresh the Statistics page with setState. This is used to fix cards not appearing on the Statistics page after submitting this form
              //widget.notifyParent();
              //Navigates back to the previous page and in this case the Statistics page
              Navigator.pop(context);
              //Toast message to indicate the Statistic was created
              Toast.show("Successfully created your Match Details!", context,
                  duration: Toast.LENGTH_SHORT, gravity: Toast.BOTTOM);
            } else if (buttonText == "Update") {
              //Retrieve the index of the passed in Statistic
              index = widget.notifyParent();

              //Updates Statistic with newStatistic content and id
              _updateStatistic(newStatistic, index);
              //Goes back to previous page which in this case is Statistics.dart
              Navigator.pop(context);
              //Toast message to indicate the Statistic was updated
              Toast.show("Successfully updated your Match Details!", context,
                  duration: Toast.LENGTH_SHORT, gravity: Toast.BOTTOM);
            }
          } else {
            if (mounted) {
              setState(() {});
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
              Toast.show("Successfully deleted your Match Details!", context,
                  duration: Toast.LENGTH_SHORT, gravity: Toast.BOTTOM);
            },
            child: Text("Delete")));
  }

  Widget showBattingDetails() {
    return ExpansionTile(
      title: Center(child: Text("Did you bat during this match?")),
      children: <Widget>[
        createTextHeader("How much runs did you score?"),
        runsSlider(0, 200, 200),
        createTextHeader("How many balls did you face?"),
        ballsFacedSlider(0, 300, 300),
        showBallError(),
        createTextHeader("Were you not out in this innings?"),
        checkNotOut()
      ],
    );
  }

  Widget showBowlingDetails() {
    return GestureDetector(
        onTap: () {
          FocusScopeNode currentFocus = FocusScope.of(context);
          if (!currentFocus.hasPrimaryFocus) {
            currentFocus.unfocus();
          }
        },
        child: ExpansionTile(
          title: Center(child: Text("Did you bowl during this match?")),
          children: <Widget>[
            createTextHeader("How many overs did you bowl?"),
            overSlider(0, 50, 50),
            showOverError(),
            createTextHeader("How many wickets did you take?"),
            wicketSlider(0, 10, 10),
            createTextHeader("How many runs did you conceed?"),
            runsConceededSlider(0, 200, 200),
            showRunsConceededError(),
          ],
        ));
  }

  Widget showFieldingDetails() {
    return GestureDetector(
        onTap: () {
          FocusScopeNode currentFocus = FocusScope.of(context);
          if (!currentFocus.hasPrimaryFocus) {
            currentFocus.unfocus();
          }
        },
        child: ExpansionTile(
          title: Center(child: Text("Did you get any fielding dismissals?")),
          children: <Widget>[
            createTextHeader("Did you take any catches? If yes then how many?"),
            catchesSlider(0, 10, 10),
            createTextHeader("Did you drop any catches? If yes then how many?"),
            catchesMissedSlider(0, 10, 10),
            createTextHeader(
                "Did you initiate any run outs? If yes then how many?"),
            runOutSlider(0, 10, 10),
            createTextHeader(
                "Did you miss any run outs? If yes then how many?"),
            runOutMissedSlider(0, 10, 10),
            createTextHeader(
                "Did you have any stumpings? If yes then how many?"),
            stumpingSlider(0, 10, 10),
            createTextHeader(
                "Did you miss any stumpings? If yes then how many?"),
            stumpingMissedSlider(0, 10, 10),
          ],
        ));
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
            children: <Widget>[deleteButton(context), submitButton("Update")]),
      ],
    );
  }

  Widget build(BuildContext context) {
    //If the passed in widget type is a new Statistic then the call is being made from Statistics.dart
    if (widget.type == "new") {
      return Expanded(
        child: ListView(
          children: <Widget>[
            Form(
                key: _statisticFormKey,
                //Pass in correct variables for assignment
                child: newPage()),
          ],
        ),
      );
      // If the passed in widget type is not a new Statistic then it comes from StatisticDetails.dart
    } else {
      return Expanded(
        child: ListView(
          children: <Widget>[Form(key: _statisticFormKey, child: updatePage())],
        ),
      );
    }
  }

  void dispose() {
    super.dispose();
    statisticController.dispose();
  }

  //Function to insert a Statistic into the database
  _save(StatisticInformation statistic) async {
    DatabaseHelper helper = DatabaseHelper.instance;
    int id = await helper.insertStatistic(statistic);
    //print('inserted row: $id');
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
