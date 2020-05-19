final String tableJournals = 'Journals';
final String columnJournalId = 'ID';
final String columnJournalName = 'Name';
final String columnDetails = 'Details';
final String columnDate = 'Date';

class JournalInformation {
  int id;
  String name;
  String details;
  String date;

  //Constructor initializing the values of the class variables. The constructor has default values in case a default journal is needed
  JournalInformation(
      [String journalName = "",
      String journalDetails = "",
      String currentDate = "",
      int index = 0]) {
    //initialize this by default to 0
    id = index;
    name = journalName;
    details = journalDetails;
    date = currentDate;
  }

  // convenience constructor to create a Journal object
  JournalInformation.fromMap(Map<String, dynamic> map) {
    name = map[columnJournalName];
    details = map[columnDetails];
    date = map[columnDate];
  }

  // convenience method to create a Map from this Goal object
  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      columnJournalName: name,
      columnDetails: details,
      columnDate: date
    };

    return map;
  }
}
