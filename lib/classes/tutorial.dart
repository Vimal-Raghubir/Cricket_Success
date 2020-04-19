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

var batting1 = new Tutorial("The key to facing good fast bowling", "Tom Scollay, a cricket coach, provides tips on positioning and playing off the back foot against pace bowling.", "https://www.youtube.com/watch?v=eIg117MWUQs", "'THE KEY TO FACING GOOD FAST BOWLING | Net session with Scolls.' Youtube, uploaded by Cricket Mentoring- Online coaching, tips & advice, 17 January 2020, https://www.youtube.com/watch?v=eIg117MWUQs", 2);
var batting2 = new Tutorial("Batting for Beginners - Cricket Batting Tips", "Ben Williams, a cricket coach, teaches batting basics including hand position on the bat and feet positioning.", "https://www.youtube.com/watch?v=8oOj2x4_OMs", "'Batting for Beginners - Cricket Batting Tips.' Youtube, uploaded by Ben Williams - My Cricket Coach, 28 August 2017, https://www.youtube.com/watch?v=8oOj2x4_OMs", 2);
var batting3 = new Tutorial("A handy drill to improve against fast bowling", "In this video, a drill using tennis balls and a tennis racket is used to develop reflexes against quicker bowlers.", "https://www.youtube.com/watch?v=f_D-Ki_4WY8", "'How to Destroy Fast Bowling - Batting Drill.' Youtube, uploaded by weCricket, 30 March 2018, https://www.youtube.com/watch?v=f_D-Ki_4WY8", 2);
var batting4 = new Tutorial("3 of the best drills to improve your batting", "In this article, 3 drills are used to help focus on your hand grip, the length of the ball, and practice aggressive strokes.", "https://australiancricketinstitute.com/3-best-drills-improve-batting/", "Fitzpatrick, Nick. '3 OF THE BEST DRILLS TO IMPROVE YOUR BATTING.' Australian Cricket Institute, https://australiancricketinstitute.com/3-best-drills-improve-batting/. Accessed 19 April 2020.", 2);
var batting5 = new Tutorial("Batting Placement Drills", "A simple drill used to develop the habit of picking gaps while batting.", "https://cricket.co.za/category/15/Coach-Education/2374/Batting-Placement-drills/", "'Batting - Placement drills.' Cricket South Africa, 30 Nov 2014, https://cricket.co.za/category/15/Coach-Education/2374/Batting-Placement-drills/", 2);

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