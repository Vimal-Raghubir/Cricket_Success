
import 'package:cricket_app/classes/statistics.dart';
import 'package:cricket_app/graphs/serieslegend.dart';
import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;

//Used to handle the fielding page
class FieldingTab {
  List<StatisticInformation> statistics = [];
  //Variables below are used for header stats table
  var totalCatches = 0;
  var totalRunOuts = 0;
  var totalStumpings = 0;

  //Handles all the content of the fielding page itself
  Widget fieldingPage(List<StatisticInformation> allStatistics) {
    //Set the statistics list passed from the statistics.dart
    statistics = allStatistics;
    return ListView(children: <Widget>[
      createStatsTable(),
      SimpleSeriesLegend(_createFieldingChart(), animate: true, title: "Fielding Dismissals"),
      //Add datatable here
    ]);
  }
  //Used to render the datatable for the stats
  DataTable createStatsTable() {
    //Need to call this to set the catches, run outs, and stumpings
    generateFieldingStats();
    //Might need to change the horizontalMargin if issues with space
    return DataTable( horizontalMargin: 30, columnSpacing: 0, columns: [
      //DataColumn(label: Text('Matches Played')),
      DataColumn(label: Text('Total Catches')),
      DataColumn(label: Text('Total Run Outs')),
      DataColumn(label: Text('Total Stumpings')),
    ], 
    rows: [
      DataRow(cells: [
        //DataCell(Text(statistics.length.toString())),
        DataCell(Text(totalCatches.toString())),
        DataCell(Text(totalRunOuts.toString())),
        DataCell(Text(totalStumpings.toString())),
      ])
    ]);
  }
  //Used to add up all the catches, run outs, and stumpings
  generateFieldingStats() {
    for (int i = 0; i < statistics.length; i++) {
      totalCatches += statistics[i].catches;
      totalRunOuts += statistics[i].runOuts;
      totalStumpings += statistics[i].stumpings;
    }
  }

  //Used to generate the fielding chart which is a series bar chart
  List<charts.Series<SeriesChartData, String>> _createFieldingChart() {
    List<SeriesChartData> catchesList;
    List<SeriesChartData> runOutsList;
    List<SeriesChartData> stumpingsList;

    catchesList = statistics.map((stat) => SeriesChartData(stat.name, stat.catches)).toList();
    runOutsList = statistics.map((stat) => SeriesChartData(stat.name, stat.runOuts)).toList();
    stumpingsList = statistics.map((stat) => SeriesChartData(stat.name, stat.stumpings)).toList();


    return [
      new charts.Series<SeriesChartData, String>(
        id: 'Catches',
        domainFn: (SeriesChartData runs, _) => runs.xAxis,
        measureFn: (SeriesChartData runs, _) => runs.yAxis,
        //Catches is denoted by a blue bar
        colorFn: (_, __) => charts.MaterialPalette.blue.shadeDefault,
        data: catchesList,
      ),
      new charts.Series<SeriesChartData, String>(
        id: 'Run Outs',
        domainFn: (SeriesChartData runs, _) => runs.xAxis,
        measureFn: (SeriesChartData runs, _) => runs.yAxis,
        //Run Outs is denoted by a red bar
        colorFn: (_, __) => charts.MaterialPalette.red.shadeDefault,
        data: runOutsList,
      ),
      new charts.Series<SeriesChartData, String>(
        id: 'Stumpings',
        domainFn: (SeriesChartData runs, _) => runs.xAxis,
        measureFn: (SeriesChartData runs, _) => runs.yAxis,
        //Stumpings is denoted by a green bar
        colorFn: (_, __) => charts.MaterialPalette.green.shadeDefault,
        data: stumpingsList,
      ),
    ];
  }
}