final String tableSettings = 'Settings';
final String columnSettingsId = 'ID';
final String columnSettingsTheme = 'Theme';

class SettingsInformation {
  int id;
  int theme;

  //Constructor initializing the values of the class variables. The constructor has default values in case a default setting is needed
  SettingsInformation([int settingsTheme = 0, int index = 0]) {
    //initialize this by default to 0
    id = index;
    theme = settingsTheme;
  }

  // convenience constructor to create a Settings object
  SettingsInformation.fromMap(Map<String, dynamic> map) {
    theme = map[columnSettingsTheme];
  }

  // convenience method to create a Map from this Goal object
  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      columnSettingsTheme: theme,
    };

    return map;
  }
}
