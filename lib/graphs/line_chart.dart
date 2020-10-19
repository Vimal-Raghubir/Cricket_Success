/// Line chart example
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:cricket_app/theme/config.dart';
import 'package:flutter/material.dart';

class SimpleLineChart extends StatelessWidget {
  final List<charts.Series> seriesList;
  final bool animate;
  final String title;

  SimpleLineChart(this.seriesList, {this.animate, this.title});

  @override
  Widget build(BuildContext context) {
    return Container(
        height: 250,
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
                      child: charts.LineChart(seriesList,
                          animate: animate,

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
                          defaultRenderer: new charts.LineRendererConfig(
                              includePoints: true)),
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
class LineChartData {
  final int xAxis;
  final double yAxis;

  LineChartData(this.xAxis, this.yAxis);
}
