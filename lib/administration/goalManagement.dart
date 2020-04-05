import 'package:flutter/material.dart';
import 'package:cricket_app/pages/goals.dart';
import 'package:cricket_app/database/database.dart';
import 'package:cricket_app/classes/goalInformation.dart';
import 'package:flutter/scheduler.dart';
import 'package:toast/toast.dart';

GlobalKey<_NumberCountDemoState> key = new GlobalKey<_NumberCountDemoState>();

class GoalManagement extends StatefulWidget {
  //Receives either a default goal or already built goal and stores it in passedGoal
  final passedGoal;

  //This describes the type of page. Either a dialog or something else
  final type;

  const GoalManagement({Key key, this.notifyParent, this.passedGoal, this.type}) : super(key: key);

  @override
  _MyGoalManagementState createState() => new _MyGoalManagementState();

  //This function is used to call the Goal page refresh function to setState
  final Function() notifyParent;
}


class _MyGoalManagementState extends State<GoalManagement> {
  var selectedGoal;
  var selectedGoalIndex;
  var selectedGoalLength;
  var selectedGoalName;
  var selectedGoalDescription;
  var currentProgress;
  //Stores all goal names for the goal name field. Used to prevent duplicate goal names
  List goalNames = [];
  int index;
  final List<String> goalOptions = ['Process Goal', 'Performance Goal', 'Outcome Goal'];

  //Key used to validate form input
  final _formKey = GlobalKey<FormState>();

  @protected
  @mustCallSuper
  initState() {
    super.initState();
    //Extract passed in goal and initializes dynamic variables with their values. Starting point
    selectedGoal = widget.passedGoal.type;
    selectedGoalIndex = widget.passedGoal.typeIndex;
    selectedGoalLength = widget.passedGoal.length.toDouble();
    selectedGoalName = widget.passedGoal.name;
    selectedGoalDescription = widget.passedGoal.description;
    currentProgress = widget.passedGoal.currentProgress;
    //Retrieves a list of all goalnames in the database
    _getGoalNames();
  }

Widget createDropDownHeader(String dropDownMessage) {
  //Allows dynamic dropdown header
  return Container(
    padding: const EdgeInsets.all(12),
    child: Text(
      dropDownMessage,
      softWrap: true,
    ),
  );
}

Widget createDropdownMenu() {
  //This is used to make the dropdown menu look like a form
  return InputDecorator(
    decoration: InputDecoration(
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(5.0))),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          hint: Text(selectedGoal),
          value: selectedGoal,
          isDense: true,
          onChanged: (String newValue) {
            setState(() {
              selectedGoal = newValue;
              if (selectedGoal == 'Process Goal') {
                //selectedGoalIndex is the index of the dropdown menu item selected and is used in the card creation
                selectedGoalIndex = 0;
              } else if (selectedGoal == 'Performance Goal') {
                selectedGoalIndex = 1;
              } else if (selectedGoal == 'Outcome Goal') {
                selectedGoalIndex = 2;
              }
              print(selectedGoal);
            });
          },
          items: goalOptions.map((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value),
            );
          }).toList(),
          ),
        ),
    );
}

Widget createGoalNameField() {
  return TextFormField(
    textCapitalization: TextCapitalization.words,
    //Starts with the passed in goal as initial value
    initialValue: widget.passedGoal.name,
    keyboardType: TextInputType.text ,
    decoration: InputDecoration(
      labelText: "What is your goal?",
      hintText: "e.g. Work on bowling run up",
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
      
      //Checks if the database goal names contain the passed in value to prevent duplicates and you are trying to create a new goal
      } else if(goalNames.contains(value.toLowerCase()) && widget.type == "new") {
        print("CHECK IS WORKING");
        return 'A goal with the same name already exists';
      //Checks if the goal name already exists in the database and the initial goal name has been modified. This guards against changing an existing goal name to another existing goal name
      } else if (goalNames.contains(value.toLowerCase()) && widget.passedGoal.name != value) {
        return 'An existing goal has that name';
      } else {
        return null;
      }
    },
    onSaved: (value)=> selectedGoalName = value,
  );
}

Widget createDescriptionField() {
  return TextFormField(
    textCapitalization: TextCapitalization.words,
    //Start with passed in goal description
    initialValue: widget.passedGoal.description,
    keyboardType: TextInputType.text ,
    decoration: InputDecoration(
      labelText: "Any additional details?",
    ),
    textInputAction: TextInputAction.next,
    validator: (value) {
      RegExp regex = new RegExp(r"^[a-zA-Z0-9.\s]*$");
      if (value.isEmpty) {
        return 'Please enter a value';
      } else if(!regex.hasMatch(value)) {
        return 'Invalid characters detected';
      }
      else {
        return null;
      }
    },
    onSaved: (value)=> selectedGoalDescription = value,
  );
}

Widget dayPickerHeader() {
  return Container(
    padding: const EdgeInsets.symmetric(vertical: 12),
    child: Text(
      'How many days do you think before you can achieve this goal?',
      softWrap: true,
    ),
  );
}
Widget dayPicker() {
  return Slider(
    value: selectedGoalLength,
    onChanged: (newRating) {
      setState(() {
        selectedGoalLength = newRating;
      });
    },
    min: 1.0,
    max: 365.0,
    //Divisions help to show a label above the slider
    divisions: 91,
    label: "$selectedGoalLength",
  );
}

Widget progressHeader() {
  return Container(
    padding: const EdgeInsets.symmetric(vertical: 12),
    child: Text(
      'How many days have you completed for this goal so far?',
      softWrap: true,
    ),
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
        //Create a new goal object with the parameters
        GoalInformation newGoal = new GoalInformation(selectedGoalName, selectedGoal, selectedGoalIndex, selectedGoalDescription, selectedGoalLength, currentProgress);
        if (buttonText == "Submit") {
            //Insert the newGoal into the database
          _save(newGoal);
          //Calls the function in the goals.dart class to refresh the goals page with setState. This is used to fix cards not appearing on the goals page after submitting this form
          widget.notifyParent();
          //Navigates back to the previous page and in this case the goals page
          Navigator.pop(context);
          //Toast message to indicate the goal was created
          Toast.show("Successfully created your goal!", context, duration: Toast.LENGTH_SHORT, gravity:  Toast.BOTTOM);
        } else if (buttonText == "Update") {
          //Retrieve the index of the passed in goal
          index = widget.notifyParent();

          newGoal.currentProgress = key.currentState.finalProgress;
          //Updates goal with newGoal content and id
          _updateGoal(newGoal, index);
          //Goes back to previous page which in this case is goals.dart
          Navigator.pop(context);
          //Toast message to indicate the goal was updated
          Toast.show("Successfully updated your goal!", context, duration: Toast.LENGTH_SHORT, gravity:  Toast.BOTTOM);
        } 
      }                     
    },
      child: Text(buttonText),
    ),
  );
}

  //Alert box to confirm deletion of a goal
  void confirmDelete(BuildContext context) async {
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Are you sure you want to delete this goal?"),
          content: Text("This action cannot be undone."),
          actions: [
           FlatButton(child: Text("No"), onPressed: () {
             Navigator.pop(context);
           },),
           //Will delete the goal and pop back to the goals page
           FlatButton(child: Text("Yes"), onPressed: () {
              _deleteGoal(widget.passedGoal.id);
              //Removed the reference to confirmDelete preventing this nested navigator pop issue
             //Navigator.push(context, MaterialPageRoute(builder: (context) => Goals()));
             Toast.show("Successfully deleted this goal!", context, duration: Toast.LENGTH_SHORT, gravity:  Toast.BOTTOM);
           },),
          ],
          elevation: 24.0,
          backgroundColor: Colors.white,
          //shape: CircleBorder(),
        );
      }
    );
  }

Widget deleteButton(BuildContext context) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 16.0),
    child: RaisedButton(
      onPressed: () {
        //confirmDelete(context);
        _deleteGoal(widget.passedGoal.id);
        Navigator.pop(context);
      },
      child: Text("Delete")
    )
    
  );
}

//This widget is responsible for creating all the contents of the form
Widget newPage() {
  return Column(
    children: <Widget>[
      createDropDownHeader("What kind of goal would you like to create?"),
      createDropdownMenu(),
      createGoalNameField(),
      createDescriptionField(),
      dayPickerHeader(),
      //This is a slider used to handle the number of days for a goal
      dayPicker(),
      submitButton("Submit"),    
    ],
  );
}

//This widget is responsible for creating all the contents of the form
Widget updatePage() {
  return Column(
    children: <Widget>[
      createDropDownHeader("Do you want to change the type of goal?"),
      createDropdownMenu(),
      createGoalNameField(),
      createDescriptionField(),
      dayPickerHeader(),
      //This is a slider used to handle the number of days for a goal
      dayPicker(),
      //Header for progress portion
      progressHeader(),
      //Progress tracker
      NumberCountDemo(key: key, progress: currentProgress, dayLimit: selectedGoalLength),
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
    //If the passed in widget type is a new goal then the call is being made from goals.dart
    if (widget.type == "new") {
      return Column(
        children: <Widget>[
          Form(
            key: _formKey,
            //Pass in correct variables for assignment
            child: newPage()
          ),
        ],
      );
    // If the passed in widget type is not a new goal then it comes from goalDetails.dart
    } else {
      return Column(
        children: <Widget>[
          Form(
            key: _formKey,
            child: updatePage()
          )
      ],
      );  
    }
  }
  
  void dispose() {
    super.dispose();
  }
  //Function to insert a goal into the database
  _save(GoalInformation goal) async {
    DatabaseHelper helper = DatabaseHelper.instance;
    int id = await helper.insertGoal(goal);
    print('inserted row: $id');
  }



  //Function to retrieve a goal by id and update in the database
  _updateGoal(GoalInformation goal, int index) async {
    DatabaseHelper helper = DatabaseHelper.instance;
    await helper.updateGoal(goal, index);
  }

  //Function to get all goal names in the database
  _getGoalNames() async {
    DatabaseHelper helper = DatabaseHelper.instance;
    goalNames = await helper.getGoalNames();
  }

  _deleteGoal(int id) async {
    DatabaseHelper helper = DatabaseHelper.instance;
    await helper.deleteGoal(id);
  }
}  

//Stateful widget to keep track of progress on goals
class NumberCountDemo extends StatefulWidget {
  //passed in current progress for goal
  final progress;

  //passed in limit for days
  final dayLimit;
  const NumberCountDemo({Key key, this.progress, this.dayLimit}) : super(key: key);
  @override
  _NumberCountDemoState createState() => new _NumberCountDemoState();
  }
  
  class _NumberCountDemoState extends State<NumberCountDemo> {
    int _n = 0;
    //getter function to retrieve _n final value
  int get finalProgress => _n;
    @override
  void initState() {
    super.initState();
    _n = widget.progress;
    print(_n);
  }

    void add() {
      setState(() {
        //Prevent progress from exceeding day limit
        if (_n < widget.dayLimit) {
          _n++;
        }
      });
    }

    void minus() {
      setState(() {
        //Prevent negative values
      if (_n != 0)
        _n--;
      });
    }

  @override
  Widget build(BuildContext context) {
    return new Container(
      child: new Center(
        child: new Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            new FlatButton(
              onPressed: minus,
              child: new Icon(
               const IconData(0xe15b, fontFamily: 'MaterialIcons'),color: Colors.black)),

            new Text('$_n',style: new TextStyle(fontSize: 28.0)),

            new FlatButton(
              onPressed: add,
              child: new Icon(Icons.add, color: Colors.black)),
          ],
        ),
      ),
    );
  }
}