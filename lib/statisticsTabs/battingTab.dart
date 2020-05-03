

import 'package:cricket_app/cardDecoration/customStatisticCard.dart';
import 'package:cricket_app/classes/statistics.dart';
import 'package:cricket_app/database/database.dart';
import 'package:cricket_app/graphs/bar_chart.dart';
import 'package:cricket_app/graphs/donut.dart';
import 'package:cricket_app/graphs/line_chart.dart';
import 'package:cricket_app/pages/createStatistic.dart';
import 'package:cricket_app/pages/statisticDetails.dart';
import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;

//Stores all the statistics in the database
List<StatisticInformation> statistics = [];

//Class to handle the creation of the batting statistic tab
class BattingTab extends StatefulWidget {
  @override
  _MyBattingTabState createState() => new _MyBattingTabState();

}

class _MyBattingTabState extends State<BattingTab> {

  //All of the variables below are used for the header stats table 
  var totalRuns = 0;
  var totalMatches = 0;
  var battingAverage = 0.0;
  var strikeRate = 0.0;
  var width;
  final List<Color> barColors = [Colors.amber, Colors.blue, Colors.green, Colors.red, Colors.orange, Colors.purple, Colors.yellow[700], Colors.cyan, Colors.indigo, Colors.lightGreen, Colors.deepOrange, Colors.teal]; 

    @protected
  @mustCallSuper
  initState() {
    super.initState();
    //Extract passed in goal and initializes dynamic variables with their values. Starting point
    refresh();
  }

  refresh() async {
    //Had to make read asynchronous to wait on the results of the database retrieval before rendering the UI
    await _read();
    if (this.mounted){
      setState(() {
      });
    }
  }

    Widget build(BuildContext context) {
      width = MediaQuery.of(context).size.width;
      return Scaffold(
        body: ListView(shrinkWrap: true, children: <Widget>[
          createStatsTable(),
          SimpleBarChart(_createBarChart("Runs"), animate: true, title: "Runs per Game"),
          SimpleLineChart(_createLineData("Batting Average"), animate: true, title: "Batting Average Progression"),
          SimpleBarChart(_createBarChart("Strike Rate"), animate: true, title: "Strike Rate Frequency"),
          DonutPieChart(_createDonutData("Not Out"), animate: true, title: "Not Out vs Dismissals", subtitle: "0 is Dismissals and 1 is Not Outs",),
          //call datatable code here
          statList(),
        ]),
        floatingActionButton: FloatingActionButton (
          //Need this to be asynchronous since you have to wait on the results of the new goal page
          onPressed: () async {
            await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => NewStatistic(
                  //Helps to prevent range issues
                  statistic: StatisticInformation(),
                )
              ),
            );
            refresh();
        },
        child: Icon(Icons.add),
        backgroundColor: Colors.green,
      ),
      );
    }

  //Used to render the datatable for the stats
  DataTable createStatsTable() {
    //Need to call this to set the batting average
    generateBattingAverage();
    //Might need to change the horizontalMargin if issues with space
    return DataTable( horizontalMargin: 30, columnSpacing: 0, columns: [
      //DataColumn(label: Text('Matches Played')),
      DataColumn(label: Text('Total Runs')),
      DataColumn(label: Text('Batting Average')),
      DataColumn(label: Text('Strike Rate')),
    ], 
    rows: [
      DataRow(cells: [
        //DataCell(Text(statistics.length.toString())),
        DataCell(Text(calculateRuns())),
        //ToStringAsFixed is used to set the precision of the double
        DataCell(Text(battingAverage.toStringAsFixed(2))),
        DataCell(Text(generateStrikeRateTotal())),
      ])
    ]);
  }

  //Used to generate strike rate by dividing total runs by number of balls faced
  String generateStrikeRateTotal() {
    var totalBalls = 0;
    for (int i = 0; i < statistics.length; i++) {
      totalBalls += statistics[i].ballsFaced;
    }

    if (totalRuns != 0 && totalBalls != 0) {
      strikeRate = (totalRuns / totalBalls) * 100;
    } else {
      strikeRate = 0.0;
    }
    return strikeRate.toStringAsFixed(2);
  }

  //Used to add up all the runs and store in totalRuns
  String calculateRuns() {
    totalRuns = 0;
    for (int i = 0; i < statistics.length; i++) {
      totalRuns += statistics[i].runs;
    }
    return totalRuns.toString();
  }

  //Handles the line chart creation
  List<charts.Series<LineChartData, int>> _createLineData(String type) {
    List<LineChartData> list;

    if (type == "Batting Average") {
      list = generateBattingAverage();
    }
    return [
      new charts.Series<LineChartData, int>(
        id: type,
        //Defines the color of the line
        colorFn: (_, __) => charts.MaterialPalette.green.shadeDefault,
        domainFn: (LineChartData sales, _) => sales.xAxis,
        measureFn: (LineChartData sales, _) => sales.yAxis,
        data: list,
      )
    ];
  }
  //Used to generate the batting average after each game
  List<LineChartData> generateBattingAverage() {
    List<int> dismissals = [];
    List<int> totalRuns = [];

    List<LineChartData> finalList = [];

    for (int i = 0; i < statistics.length; i++) {
      if (i == 0) {
        totalRuns.add(statistics[i].runs);
        //Checks if the person actually batted in this inning. If they did not (balls faced = 0) then set their dismissals to 0.
        if (statistics[i].ballsFaced != 0) {
          //This handles the first index of the dismissals array since you cannot add to previous element
          if (statistics[i].notOut != 0) { 
            dismissals.add(0);
          } else {
            dismissals.add(1);
          }
        } else {
          dismissals.add(0);
        }
      } else {
        //Need to add the current runs scored to previous total Runs
        totalRuns.add(totalRuns[i-1] + statistics[i].runs);
        //Checks if the person actually batted in this inning. If they did not (balls faced = 0) then set their dismissals to the previous dismissal count.
        if (statistics[i].ballsFaced != 0) {
          if (statistics[i].notOut != 0) {
            dismissals.add(dismissals[i-1]);    //Copies the previous total dismissals to this index
          } else {
            dismissals.add(dismissals[i-1] + 1);  //Add the previous total dismissals by 1
          }
        } else {
          dismissals.add(dismissals[i-1]);
        }
      }
    }

    for (int i = 0; i < statistics.length; i++) {
      double average = 0;
      if (dismissals[i] == 0 || totalRuns[i] == 0) {    //Checks if the person was out or if they scored 0
        average = totalRuns[i].toDouble();              //Their average for that game will simply be the runs they scored
      } else {
        average = totalRuns[i] / dismissals[i];         //Their average will be divided by the total dismissals
      }

      if (i == statistics.length - 1) {
        battingAverage = average;                       //Set current batting average for stats table
      }

      finalList.add(LineChartData(i, average));
    } 
    return finalList;
  }

    /// Create bar chart data
  List<charts.Series<BarChartData, String>> _createBarChart(String type) {
    List<BarChartData> list = [];
    if (type == "Runs") {
      int j = 0;
      for (int i = 0; i < statistics.length; i++) {
        //Resets the index for the colors if it reaches the end of the color list
        if (j == (barColors.length - 1)) {
          j = 0;                          
        }
        list.add(BarChartData(statistics[i].name, statistics[i].runs, barColors[j]));
        j++;
      }
    } else if (type == "Strike Rate") {
      list = generateStrikeRate();
    } 

    return [
      new charts.Series<BarChartData, String>(
        id: type,
        domainFn: (BarChartData runs, _) => runs.xAxis,
        measureFn: (BarChartData runs, _) => runs.yAxis,
        colorFn: (BarChartData runs, _) => runs.color,
        data: list,
      )
    ];
  }

  //Handles the strike rate calculation
  List<BarChartData> generateStrikeRate() {
    //Sets the array for the strike rate buckets
    var strikeRates = [0, 0, 0, 0, 0, 0];
    //Defines the strike rate bucket criteria
    var ranges = ["0-60", "60-80", "80-100", "100-120", "120-140", "140+"];

    List<BarChartData> finalList = [];

    double totalStrikeRate = 0.0;

    for (int i = 0; i < statistics.length; i++) {
      //If the person did not score any runs and actually batted in this innings (ballsFaced != 0) then add 1 to the first bucket
      if (statistics[i].ballsFaced != 0 && statistics[i].runs == 0) {
        strikeRates[0] += 1;
      } else {
        //Calculates their strike rate for that inning
        double economy = (statistics[i].runs / statistics[i].ballsFaced) * 100;
        //Adds it to the totalStrikeRate for header stats table
        totalStrikeRate += economy;

        //Setting the array element relevant to the bucket which the strike rate falls within
        if (economy >= 0 && economy < 60) {
          strikeRates[0] += 1;
        } else if (economy >= 60 && economy < 80) {
          strikeRates[1] += 1;
        } else if (economy >= 80 && economy < 100) {
          strikeRates[2] += 1;
        } else if (economy >= 100 && economy < 120) {
          strikeRates[3] += 1;
        } else if (economy >= 120 && economy < 140) {
          strikeRates[4] += 1;
        } else if (economy >= 140) {
          strikeRates[5] += 1;
        }
      }
    }
    int j = 0;
    for (int i = 0; i < strikeRates.length; i++) {
      //Resets color list index
      if (j == (barColors.length - 1)) {
        j = 0;
      }
      finalList.add(BarChartData(ranges[i], strikeRates[i], barColors[j]));
      j++;
    }

    //If strike rate and their is matches then calculate the average strike rate for stats header table
    if (totalStrikeRate > 0.0 && statistics.length != 0) {
      strikeRate = totalStrikeRate / statistics.length;
    }
    return finalList;
  }

  //Create not out donut chart
  List<DonutChartData> createNotOutChart() {
    double notOuts = 0;
    double dismissals = 0;
    List<DonutChartData> finalList = [];

    for (int i = 0; i < statistics.length; i++) {
      //If the batsman actually batted in this innings then handle their dismissals
      if (statistics[i].ballsFaced != 0) {
        if (statistics[i].notOut == 0) {
          dismissals += 1;
        } else {
          notOuts += 1;
        }
      }
    }
    finalList.add(DonutChartData(0, dismissals, Colors.red));
    finalList.add(DonutChartData(1, notOuts, Colors.green));
    
    return finalList;
  }

      /// Create one series with sample hard coded data.
  List<charts.Series<DonutChartData, int>> _createDonutData(String type) {
    List<DonutChartData> list;
    if (type == "Not Out") {
      list = createNotOutChart();
    }
    return [
      new charts.Series<DonutChartData, int>(
        id: type,
        domainFn: (DonutChartData notOut, _) => notOut.xAxis,
        measureFn: (DonutChartData notOut, _) => notOut.yAxis,
        colorFn: (DonutChartData notOut, _) => notOut.color,
        data: list,
      )
    ];
  }

  Widget statList() {
    return ListView.builder (
      shrinkWrap: true,
      physics: ScrollPhysics(),
      itemCount: statistics.length,
      itemBuilder: (BuildContext ctxt, int index) {
        return InkWell(
        //This needs to be asynchronous since you have to wait on the results of the update page
          onTap: () async {
            //Pass the statistic information to the statisticDetails.dart page
            await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => StatisticDetails(
                  //Helps to prevent range issues
                  statistic: statistics?.elementAt(index) ?? "",
                )
              ),
            );
            //Then rebuild the widget
            refresh();
          },
            //Render custom card for each goal
            child: CustomStatisticCard(object: statistics[index], width: width,type: 0)
          );  
      }
    );
  }

      //Function to read all goals from the database for rendering
  _read() async {
    DatabaseHelper helper = DatabaseHelper.instance;
    //goals now stores the index of each goalInformation in the database
    statistics = await helper.getStatistics();
  }
}