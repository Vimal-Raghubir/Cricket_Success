

import 'package:cricket_app/classes/statistics.dart';
import 'package:cricket_app/graphs/bar_chart.dart';
import 'package:cricket_app/graphs/donut.dart';
import 'package:cricket_app/graphs/line_chart.dart';
import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;

class BattingTab {
  final List<Color> barColors = [Colors.amber, Colors.blue, Colors.green, Colors.red, Colors.orange, Colors.purple, Colors.yellow[700], Colors.cyan, Colors.indigo, Colors.lightGreen, Colors.deepOrange, Colors.teal]; 
  List<StatisticInformation> statistics = [];

    Widget battingPage(List<StatisticInformation> allStatistics) {
      statistics = allStatistics;
      return ListView(children: <Widget>[
        SimpleBarChart(_createBarChart("Runs"), animate: true, title: "Runs per Game"),
        SimpleLineChart(_createLineData("Batting Average"), animate: true, title: "Batting Average Progression"),
        SimpleBarChart(_createBarChart("Strike Rate"), animate: true, title: "Strike Rate Frequency"),
        DonutPieChart(_createDonutData("Not Out"), animate: true, title: "Not Out vs Dismissals", subtitle: "0 is Dismissals and 1 is Not Outs",),
        //call datatable code here
      ]);
    }

  List<charts.Series<LineChartData, int>> _createLineData(String type) {
    List<LineChartData> list;

    if (type == "Batting Average") {
      list = generateBattingAverage();
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

  List<LineChartData> generateBattingAverage() {
    List<int> dismissals = [];
    List<int> totalRuns = [];

    List<LineChartData> finalList = [];

    for (int i = 0; i < statistics.length; i++) {
      if (i == 0) {
        totalRuns.add(statistics[i].runs);
        if (statistics[i].notOut != 0) {
          dismissals.add(0);
        } else {
          dismissals.add(1);
        }
      } else {
        totalRuns.add(totalRuns[i-1] + statistics[i].runs);
        if (statistics[i].notOut != 0) {
          dismissals.add(dismissals[i-1]);
        } else {
          dismissals.add(dismissals[i-1] + 1);
        }
      }
    }

    for (int i = 0; i < statistics.length; i++) {
      double average = 0;
      if (dismissals[i] == 0 || totalRuns[i] == 0) {
        average = totalRuns[i].toDouble();
      } else {
        average = totalRuns[i] / dismissals[i];
      }
      finalList.add(LineChartData(i, average));
    } 
    return finalList;
  }

    /// Create one series with sample hard coded data.
  List<charts.Series<BarChartData, String>> _createBarChart(String type) {
    List<BarChartData> list = [];
    if (type == "Runs") {
      int j = 0;
      for (int i = 0; i < statistics.length; i++) {
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

  List<BarChartData> generateStrikeRate() {
    var strikeRates = [0, 0, 0, 0, 0, 0];
    var ranges = ["0-60", "60-80", "80-100", "100-120", "120-140", "140+"];

    List<BarChartData> finalList = [];

    for (int i = 0; i < statistics.length; i++) {
      if (statistics[i].ballsFaced == 0 || statistics[i].runs == 0) {
        strikeRates[0] += 1;
      } else {
        double economy = (statistics[i].runs / statistics[i].ballsFaced) * 100;

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
      if (j == (barColors.length - 1)) {
        j = 0;
      }
      finalList.add(BarChartData(ranges[i], strikeRates[i], barColors[j]));
      j++;
    }
    
    return finalList;
  }

  List<DonutChartData> createNotOutChart() {
    double notOuts = 0;
    double dismissals = 0;
    List<DonutChartData> finalList = [];

    for (int i = 0; i < statistics.length; i++) {
      if (statistics[i].notOut == 0) {
        dismissals += 1;
      } else {
        notOuts += 1;
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
}