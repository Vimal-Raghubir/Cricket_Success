final String tableStatistics = 'Statistics';
final String column_statistics_id = 'ID';
final String column_statistics_name = 'Name';
final String column_statistics_runs = 'Runs';
final String column_statistics_balls_faced = 'Balls_Faced';
final String column_statistics_not_out = 'Not_Out';

final String column_statistics_wickets = 'Wickets';
final String column_statistics_overs = 'Overs_Bowled';
final String column_statistics_runs_conceeded = 'Runs_Conceeded';


final String column_statistics_run_outs = 'Run_Outs';
final String column_statistics_catches = 'Catches';
final String column_statistics_stumpings = 'Stumpings';

final String column_statistics_rating = 'Rating';

class StatisticInformation {
  int id;
  String name;
  int runs;
  int balls_faced;
  bool not_out;
  
  int wickets;
  int overs;
  int runs_conceeded;

  int run_outs;
  int catches;
  int stumpings;
  int rating;


    //Constructor initializing the values of the class variables. The constructor has default values in case a default statistic is needed
  StatisticInformation([String statName = "", int statRuns = 0, int statBalls = 0, bool statNotOut = false, int statWickets = 0, int statOvers = 0, int statRunsConceeded = 0, int statRunOuts = 0, int statCatches = 0, int statStumpings = 0, int statRating = 0, int index = 0]) {
    //initialize this by default to 0
    id = index;
    name = statName;
    runs = statRuns;
    balls_faced = statBalls;
    not_out = statNotOut;
    wickets = statWickets;
    overs = statOvers;
    runs_conceeded = statRunsConceeded;
    run_outs = statRunOuts;
    catches = statCatches;
    stumpings = statStumpings;
    rating = statRating;
  }

  // convenience constructor to create a Statistics object
  StatisticInformation.fromMap(Map<String, dynamic> map) {
    name = map[column_statistics_name];
    runs = map[column_statistics_runs];
    balls_faced = map[column_statistics_balls_faced];
    not_out = map[column_statistics_not_out];
    wickets = map[column_statistics_wickets];
    overs = map[column_statistics_overs];
    runs_conceeded = map[column_statistics_runs_conceeded];
    run_outs = map[column_statistics_run_outs];
    catches = map[column_statistics_catches];
    stumpings = map[column_statistics_stumpings];
    rating = map[column_statistics_rating];
  }

    // convenience method to create a Map from this Statistics object
  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      column_statistics_name: name,
      column_statistics_runs: runs,
      column_statistics_balls_faced: balls_faced,
      column_statistics_not_out: not_out,
      column_statistics_wickets: wickets,
      column_statistics_overs: overs,
      column_statistics_runs_conceeded: runs_conceeded,
      column_statistics_run_outs: run_outs,
      column_statistics_catches: catches,
      column_statistics_stumpings: stumpings,
      column_statistics_rating: rating
    };
    
      return map;
    } 
}