class Tutorial {
  String name;
  String summary;
  String url;
  String credits;
  int type;

  Tutorial(tutorialName, tutorialSummary, tutorialURL, tutorialCredits, tutorialType) {
    name = tutorialName;
    summary = tutorialSummary;
    url = tutorialURL;
    credits = tutorialCredits;
    type = tutorialType;
  }
}


var bowling1 = new Tutorial("bowling1", "description here", "https://www.google.com", "my author", 1);
var bowling2 = new Tutorial("bowling2", "description here", "https://www.google.com", "my author", 1);
var bowling3 = new Tutorial("bowling3", "description here", "https://www.google.com", "my author", 1);
var bowling4 = new Tutorial("bowling4", "description here", "https://www.google.com", "my author", 1);
var bowling5 = new Tutorial("bowling5", "description here", "https://www.google.com", "my author", 1);

List<Tutorial> bowlingList = [bowling1, bowling2, bowling3, bowling4, bowling5];

var batting1 = new Tutorial("batting1", "description here", "https://www.example.com", "my author", 2);
var batting2 = new Tutorial("batting2", "description here", "https://www.example.com", "my author", 2);
var batting3 = new Tutorial("batting3", "description here", "https://www.example.com", "my author", 2);
var batting4 = new Tutorial("batting4", "description here", "https://www.example.com", "my author", 2);
var batting5 = new Tutorial("batting5", "description here", "https://www.example.com", "my author", 2);

List<Tutorial> battingList = [batting1, batting2, batting3, batting4, batting5];

var fielding1 = new Tutorial("fielding1", "description here", "https://www.example.com", "my author", 3);
var fielding2 = new Tutorial("fielding2", "description here", "https://www.example.com", "my author", 3);
var fielding3 = new Tutorial("fielding3", "description here", "https://www.example.com", "my author", 3);
var fielding4 = new Tutorial("fielding4", "description here", "https://www.example.com", "my author", 3);
var fielding5 = new Tutorial("fielding5", "description here", "https://www.example.com", "my author", 3);

List<Tutorial> fieldingList = [fielding1, fielding2, fielding3, fielding4, fielding5];

var mental1 = new Tutorial("mental1", "description here", "https://www.example.com", "my author", 4);
var mental2 = new Tutorial("mental2", "description here", "https://www.example.com", "my author", 4);
var mental3 = new Tutorial("mental3", "description here", "https://www.example.com", "my author", 4);
var mental4 = new Tutorial("mental4", "description here", "https://www.example.com", "my author", 4);
var mental5 = new Tutorial("mental5", "description here", "https://www.example.com", "my author", 4);

List<Tutorial> mentalList = [mental1, mental2, mental3, mental4, mental5];

var physical1 = new Tutorial("physical1", "description here", "https://www.example.com", "my author", 5);
var physical2 = new Tutorial("physical2", "description here", "https://www.example.com", "my author", 5);
var physical3 = new Tutorial("physical3", "description here", "https://www.example.com", "my author", 5);
var physical4 = new Tutorial("physical4", "description here", "https://www.example.com", "my author", 5);
var physical5 = new Tutorial("physical5", "description here", "https://www.example.com", "my author", 5);

List<Tutorial> physicalList = [physical1, physical2, physical3, physical4, physical5];