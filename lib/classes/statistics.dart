final String tableStatistics = 'Statistics';
final String columnStatisticsId = 'ID';
final String columnStatisticsName = 'Name';
final String columnStatisticsRuns = 'Runs';
final String columnStatisticsBallsFaced = 'Balls_Faced';
final String columnStatisticsNotOut = 'Not_Out';

final String columnStatisticsWickets = 'Wickets';
final String columnStatisticsOvers = 'Overs_Bowled';
final String columnStatisticsRunsConceeded = 'Runs_Conceeded';


final String columnStatisticsRunOuts = 'Run_Outs';
final String columnStatisticsCatches = 'Catches';
final String columnStatisticsStumpings = 'Stumpings';

final String columnStatisticsRating = 'Rating';

class StatisticInformation {
  int id;
  String name;
  int runs;
  int ballsFaced;
  int notOut;
  
  int wickets;
  int overs;
  int runsConceeded;

  int runOuts;
  int catches;
  int stumpings;
  int rating;


    //Constructor initializing the values of the class variables. The constructor has default values in case a default statistic is needed
  StatisticInformation([String statName = "", int statRuns = 0, int statBalls = 0, int statNotOut = 0, int statWickets = 0, int statOvers = 0, int statRunsConceeded = 0, int statRunOuts = 0, int statCatches = 0, int statStumpings = 0, int statRating = 0, int index = 0]) {
    //initialize this by default to 0
    id = index;
    name = statName;
    runs = statRuns;
    ballsFaced = statBalls;
    notOut = statNotOut;
    wickets = statWickets;
    overs = statOvers;
    runsConceeded = statRunsConceeded;
    runOuts = statRunOuts;
    catches = statCatches;
    stumpings = statStumpings;
    rating = statRating;
  }

  // convenience constructor to create a Statistics object
  StatisticInformation.fromMap(Map<String, dynamic> map) {
    name = map[columnStatisticsName];
    runs = map[columnStatisticsRuns];
    ballsFaced = map[columnStatisticsBallsFaced];
    notOut = map[columnStatisticsNotOut];
    wickets = map[columnStatisticsWickets];
    overs = map[columnStatisticsOvers];
    runsConceeded = map[columnStatisticsRunsConceeded];
    runOuts = map[columnStatisticsRunOuts];
    catches = map[columnStatisticsCatches];
    stumpings = map[columnStatisticsStumpings];
    rating = map[columnStatisticsRating];
  }

    // convenience method to create a Map from this Statistics object
  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      columnStatisticsName: name,
      columnStatisticsRuns: runs,
      columnStatisticsBallsFaced: ballsFaced,
      columnStatisticsNotOut: notOut,
      columnStatisticsWickets: wickets,
      columnStatisticsOvers: overs,
      columnStatisticsRunsConceeded: runsConceeded,
      columnStatisticsRunOuts: runOuts,
      columnStatisticsCatches: catches,
      columnStatisticsStumpings: stumpings,
      columnStatisticsRating: rating
    };
    
      return map;
    } 
}