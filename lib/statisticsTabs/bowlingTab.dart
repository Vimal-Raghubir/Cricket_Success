import 'package:cricket_app/classes/statistics.dart';
import 'package:cricket_app/graphs/bar_chart.dart';
import 'package:cricket_app/graphs/line_chart.dart';
import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;

//Class to handle the creation of the bowling statistic tab
class BowlingTab {
  final List<Color> barColors = [Colors.amber, Colors.blue, Colors.green, Colors.red, Colors.orange, Colors.purple, Colors.yellow[700], Colors.cyan, Colors.indigo, Colors.lightGreen, Colors.deepOrange, Colors.teal]; 
  //Stores all the statistics in the database
  List<StatisticInformation> statistics = [];

  //All of the variables below are used for the header stats table 
  var totalWickets = 0;
  var totalMatches = 0;
  var bowlingAverage = 0.0;
  var economyRate = 0.0;

    //Responsible for the overall bowling page
    Widget bowlingPage(List<StatisticInformation> allStatistics) {
      //Set the statistics list passed from the statistics.dart
      statistics = allStatistics;
      return ListView(children: <Widget>[
        createStatsTable(),
        SimpleBarChart(_createBarChart("Wickets"), animate: true, title: "Wickets per Game"),
        SimpleLineChart(_createLineData("Bowling Average"), animate: true, title: "Bowling Average Progression"),
        SimpleBarChart(_createBarChart("Economy Rate"), animate: true, title: "Economy Rate Frequency"),
        //Put Datatable here
      ]);
    }

  //Used to render the datatable for the stats
  DataTable createStatsTable() {
    //Need to call this to set the bowling average
    generateBowlingAverage();
    //Need to call this to set the economy rate
    generateEconomyRate();
    //Might need to change the horizontalMargin if issues with space
    return DataTable( horizontalMargin: 30, columnSpacing: 0, columns: [
      //DataColumn(label: Text('Matches Played')),
      DataColumn(label: Text('Total Wickets')),
      DataColumn(label: Text('Bowling Average')),
      DataColumn(label: Text('Economy Rate')),
    ], 
    rows: [
      DataRow(cells: [
        //DataCell(Text(statistics.length.toString())),
        DataCell(Text(calculateWickets())),
        //ToStringAsFixed is used to set the precision of the double
        DataCell(Text(bowlingAverage.toStringAsFixed(2))),
        DataCell(Text(economyRate.toStringAsFixed(2))),
      ])
    ]);
  }
  //Used to add up all the wickets and store in totalWickets
  String calculateWickets() {
    for (int i = 0; i < statistics.length; i++) {
      totalWickets += statistics[i].wickets;
    }
    return totalWickets.toString();
  }

  //Handles the creation of a bar chart
  List<charts.Series<BarChartData, String>> _createBarChart(String type) {
    List<BarChartData> list = [];
    if (type == "Wickets") {
      int j = 0;
      for (int i = 0; i < statistics.length; i++) {
        //Resets the index for the colors if it reaches the end of the color list
        if (j == (barColors.length - 1)) {
          j = 0;
        }
        list.add(BarChartData(statistics[i].name, statistics[i].wickets, barColors[j]));
        j++;
      }
    } else if (type == "Economy Rate") {
      //Need to fix
      list = generateEconomyRate();
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
  //Handles the economy rate calculation
  List<BarChartData> generateEconomyRate() {
    //Sets the array for the economy rate buckets
    var economyRates = [0, 0, 0, 0, 0];
    //Defines the economy rate bucket criteria
    var ranges = ["0-4", "4-6", "6-8", "8-10", "10+"];

    List<BarChartData> finalList = [];
    double totalEconomyRate = 0.0;

    for (int i = 0; i < statistics.length; i++) {
      //If the person did not conceed runs or did not set their bowling overs then add 1 to the first bucket
      if (statistics[i].overs == 0 || statistics[i].runsConceeded == 0) {
        economyRates[0] += 1;
      } else {
        //Calculates their economy rate for that inning
        double economy = statistics[i].runsConceeded / statistics[i].overs;
        //Adds it to the totalEconomyRate for header stats table
        totalEconomyRate += economy;

        //Setting the array element relevant to the bucket which the economy rate falls within
        if (economy >= 0 && economy < 4) {
          economyRates[0] += 1;
        } else if (economy >= 4 && economy < 6) {
          economyRates[1] += 1;
        } else if (economy >= 6 && economy < 8) {
          economyRates[2] += 1;
        } else if (economy >= 8 && economy < 10) {
          economyRates[3] += 1;
        } else if (economy >= 10) {
          economyRates[4] += 1;
        }
      }
    }
    int j = 0;
    for (int i = 0; i < economyRates.length; i++) {
      //Resets color list index
      if (j == (barColors.length - 1)) {
        j = 0;
      }
      finalList.add(BarChartData(ranges[i], economyRates[i], barColors[j]));
      j++;
    }
    //If economy rate and their is matches then calculate the average economy rate for stats header table
    if (totalEconomyRate > 0.0 && statistics.length != 0) {
      economyRate = totalEconomyRate / statistics.length;
    }
    
    return finalList;
  }

  // Create a line chart for bowling average
  List<charts.Series<LineChartData, int>> _createLineData(String type) {
    List<LineChartData> list;
    
    if (type == "Bowling Average") {
      list = generateBowlingAverage();
    }


    return [
      new charts.Series<LineChartData, int>(
        id: type,
        colorFn: (_, __) => charts.MaterialPalette.green.shadeDefault,
        domainFn: (LineChartData sales, _) => sales.xAxis,
        measureFn: (LineChartData sales, _) => sales.yAxis,
        data: list,
      )
    ];
  }
  //Used to generate the bowling average after each game
  List<LineChartData> generateBowlingAverage() {
    List<int> dismissals = [];
    List<int> totalRunsConceeded = [];

    List<LineChartData> finalList = [];

    for (int i = 0; i < statistics.length; i++) {
      if (i == 0) {
        totalRunsConceeded.add(statistics[i].runsConceeded);
        dismissals.add(statistics[i].wickets);
      } else {
        //Need to add the current runs conceeded scored to previous total runs conceeded
        totalRunsConceeded.add(totalRunsConceeded[i-1] + statistics[i].runsConceeded);
        //Need to add the current wickets scored to previous total wickets
        dismissals.add(dismissals[i-1] + statistics[i].wickets);
      }
    }

    for (int i = 0; i < statistics.length; i++) {
      double average = 0;
      if (dismissals[i] == 0 || totalRunsConceeded[i] == 0) {
        //Their average for that game will simply be the runs conceeded they scored
        average = totalRunsConceeded[i].toDouble();
      } else {
        //Their average will be divided by the total dismissals
        average = totalRunsConceeded[i] / dismissals[i];
      }

      if (i == statistics.length - 1) {
        //Set current bowling average for stats table
        bowlingAverage = average;
      }

      finalList.add(LineChartData(i, average));
    } 
    return finalList;
  }
}