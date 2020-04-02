// database table and column names
final String tableGoals = 'Goals';
final String column_goal_id = 'ID';
final String column_goal_name = 'Name';
final String column_type = 'Type';
final String column_type_index = 'Type_Index';
final String column_description = 'Description';
final String column_length = 'Length';
final String column_progress = 'Progress';

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
    name = map[column_goal_name];
    type = map[column_type];
    typeIndex = map[column_type_index];
    description = map[column_description];
    length = map[column_length];
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
      column_goal_name: name,
      column_type: type,
      column_type_index: typeIndex,
      column_description: description,
      column_length: length,
      column_progress: currentProgress
    };
    
      return map;
    } 
}