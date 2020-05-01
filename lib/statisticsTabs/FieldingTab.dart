
import 'package:cricket_app/classes/statistics.dart';
import 'package:cricket_app/graphs/serieslegend.dart';
import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;

class FieldingTab {
  List<StatisticInformation> statistics = [];

  Widget fieldingPage(List<StatisticInformation> allStatistics) {
    statistics = allStatistics;
    return ListView(children: <Widget>[
      SimpleSeriesLegend(_createFieldingChart(), animate: true, title: "Fielding Dismissals"),
      //Add datatable here
    ]);
  }

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
        colorFn: (_, __) => charts.MaterialPalette.blue.shadeDefault,
        data: catchesList,
      ),
      new charts.Series<SeriesChartData, String>(
        id: 'Run Outs',
        domainFn: (SeriesChartData runs, _) => runs.xAxis,
        measureFn: (SeriesChartData runs, _) => runs.yAxis,
        colorFn: (_, __) => charts.MaterialPalette.red.shadeDefault,
        data: runOutsList,
      ),
      new charts.Series<SeriesChartData, String>(
        id: 'Stumpings',
        domainFn: (SeriesChartData runs, _) => runs.xAxis,
        measureFn: (SeriesChartData runs, _) => runs.yAxis,
        colorFn: (_, __) => charts.MaterialPalette.green.shadeDefault,
        data: stumpingsList,
      ),
    ];
  }
}