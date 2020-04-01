final String tableJournals = 'Journals';
final String column_journal_id = 'ID';
final String column_journal_name = 'Name';
final String column_details = 'Details';
final String column_date = 'Date';

class JournalInformation {
  int id;
  String name;
  String details;
  String date;


    //Constructor initializing the values of the class variables. The constructor has default values in case a default journal is needed
  JournalInformation([String journalName = "", String journalDetails = "", String currentDate = "", int index = 0]) {
    //initialize this by default to 0
    id = index;
    name = journalName;
    details = journalDetails;
    date = currentDate;
  }

  // convenience constructor to create a Journal object
  JournalInformation.fromMap(Map<String, dynamic> map) {
    name = map[column_journal_name];
    details = map[column_details];
    date = map[column_date];
  }

    // convenience method to create a Map from this Goal object
  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      column_journal_name: name,
      column_details: details,
      column_date: date
    };
    
      return map;
    } 
}