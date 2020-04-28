// database table and column names
final String tableGoals = 'Goals';
final String columnGoalId = 'ID';
final String columnGoalName = 'Name';
final String columnType = 'Type';
final String columnTypeIndex = 'Type_Index';
final String columnDescription = 'Description';
final String columnLength = 'Length';
final String columnProgress = 'Progress';

//Custom class defining the structure of a goal
class GoalInformation {
  //Will use this to keep track of ID in table
  int id;
  String name;
  String type;
  int typeIndex;
  String description;
  int length;
  int currentProgress;
  
  //Constructor initializing the values of the class variables. The constructor has default values in case a default goal is needed
  GoalInformation([String goalName = "", String goalType = "Process Goal", int goalTypeIndex = 0, String goalDescription = "", double goalLength = 1.0, int completedDays = 0, int index = 0]) {
    //initialize this by default to 0
    id = index;
    name = goalName;
    type = goalType;
    typeIndex = goalTypeIndex;
    description = goalDescription;
    length = goalLength.toInt();
    currentProgress = completedDays;
  }

  // convenience constructor to create a Goal object
  GoalInformation.fromMap(Map<String, dynamic> map) {
    name = map[columnGoalName];
    type = map[columnType];
    typeIndex = map[columnTypeIndex];
    description = map[columnDescription];
    length = map[columnLength];
    currentProgress = map[currentProgress];
  }

  //Convenience function set this value
  void setId(int index) {
    id = index;
  }

  //Function to updateProgress by 1 day
  double updateProgress() {
    currentProgress += 1;
    var progress = (currentProgress / length);
    return num.parse(progress.toStringAsFixed(2));
  }

  //Retrieve progress percentage fixed to 2 decimal points
  double getProgress() {
    if (currentProgress == 0) {
      return 0.0;
    } else {
      var progress = (currentProgress / length);
      return num.parse(progress.toStringAsFixed(2));
    }
  }

  // convenience method to create a Map from this Goal object
  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      columnGoalName: name,
      columnType: type,
      columnTypeIndex: typeIndex,
      columnDescription: description,
      columnLength: length,
      columnProgress: currentProgress
    };
    
      return map;
    } 
}