/// Bar chart example
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:cricket_app/theme/config.dart';
import 'package:flutter/material.dart';

class SimpleSeriesLegend extends StatelessWidget {
  final List<charts.Series> seriesList;
  final bool animate;
  final String title;

  SimpleSeriesLegend(this.seriesList, {this.animate, this.title});

  @override
  Widget build(BuildContext context) {
    return Container(
        height: 350,
        padding: EdgeInsets.all(20),
        child: Card(
            child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: <Widget>[
                    Text(
                      title,
                      style: Theme.of(context).textTheme.bodyText1,
                    ),
                    Expanded(
                      child: charts.BarChart(seriesList,
                          animate: animate,
                          vertical: false,
                          domainAxis: new charts.OrdinalAxisSpec(
                              renderSpec: new charts.SmallTickRendererSpec(

                                  // Tick and Label styling here.
                                  labelStyle: new charts.TextStyleSpec(
                                      fontSize: 14, // size in Pts.
                                      color: getChartColor(
                                          currentColor.currentColor())),

                                  // Change the line colors to match text color.
                                  lineStyle: new charts.LineStyleSpec(
                                      color: getChartColor(
                                          currentColor.currentColor())))),

                          /// Assign a custom style for the measure axis.
                          primaryMeasureAxis: new charts.NumericAxisSpec(
                              renderSpec: new charts.GridlineRendererSpec(

                                  // Tick and Label styling here.
                                  labelStyle: new charts.TextStyleSpec(
                                      fontSize: 14, // size in Pts.
                                      color: getChartColor(
                                          currentColor.currentColor())),

                                  // Change the line colors to match text color.
                                  lineStyle: new charts.LineStyleSpec(
                                      color: getChartColor(
                                          currentColor.currentColor())))),
                          barGroupingType: charts.BarGroupingType.grouped,
                          behaviors: [new charts.SeriesLegend()]),
                    ),
                  ],
                ))));
  }

  charts.Color getChartColor(Color color) {
    return charts.Color(
        r: color.red, g: color.green, b: color.blue, a: color.alpha);
  }
}

/// Sample ordinal data type.
class SeriesChartData {
  final String xAxis;
  final int yAxis;
  //final charts.Color color;

  SeriesChartData(this.xAxis, this.yAxis);
}
