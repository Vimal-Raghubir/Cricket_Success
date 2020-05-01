import 'package:cricket_app/classes/statistics.dart';
import 'package:cricket_app/graphs/bar_chart.dart';
import 'package:cricket_app/graphs/line_chart.dart';
import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;

class BowlingTab {
  final List<Color> barColors = [Colors.amber, Colors.blue, Colors.green, Colors.red, Colors.orange, Colors.purple, Colors.yellow[700], Colors.cyan, Colors.indigo, Colors.lightGreen, Colors.deepOrange, Colors.teal]; 
  List<StatisticInformation> statistics = [];

    Widget bowlingPage(List<StatisticInformation> allStatistics) {
      statistics = allStatistics;
      return ListView(children: <Widget>[
        SimpleBarChart(_createBarChart("Wickets"), animate: true, title: "Wickets per Game"),
        SimpleLineChart(_createLineData("Bowling Average"), animate: true, title: "Bowling Average Progression"),
        SimpleBarChart(_createBarChart("Economy Rate"), animate: true, title: "Economy Rate Frequency"),
        //Put Datatable here
      ]);
    }

      /// Create one series with sample hard coded data.
  List<charts.Series<BarChartData, String>> _createBarChart(String type) {
    List<BarChartData> list = [];
    if (type == "Wickets") {
      int j = 0;
      for (int i = 0; i < statistics.length; i++) {
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

  List<BarChartData> generateEconomyRate() {
    var economyRates = [0, 0, 0, 0, 0];
    var ranges = ["0-4", "4-6", "6-8", "8-10", "10+"];

    List<BarChartData> finalList = [];

    for (int i = 0; i < statistics.length; i++) {
      if (statistics[i].overs == 0 || statistics[i].runsConceeded == 0) {
        economyRates[0] += 1;
      } else {
        double economy = statistics[i].runsConceeded / statistics[i].overs;

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
      if (j == (barColors.length - 1)) {
        j = 0;
      }
      finalList.add(BarChartData(ranges[i], economyRates[i], barColors[j]));
      j++;
    }
    
    return finalList;
  }

      /// Create one series with sample hard coded data.
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

  List<LineChartData> generateBowlingAverage() {
    List<int> dismissals = [];
    List<int> totalRunsConceeded = [];

    List<LineChartData> finalList = [];

    for (int i = 0; i < statistics.length; i++) {
      if (i == 0) {
        totalRunsConceeded.add(statistics[i].runsConceeded);
        dismissals.add(statistics[i].wickets);
      } else {
        totalRunsConceeded.add(totalRunsConceeded[i-1] + statistics[i].runsConceeded);
        dismissals.add(dismissals[i-1] + statistics[i].wickets);
      }
    }

    for (int i = 0; i < statistics.length; i++) {
      double average = 0;
      if (dismissals[i] == 0 || totalRunsConceeded[i] == 0) {
        average = totalRunsConceeded[i].toDouble();
      } else {
        average = totalRunsConceeded[i] / dismissals[i];
      }
      finalList.add(LineChartData(i, average));
    } 
    return finalList;
  }
}