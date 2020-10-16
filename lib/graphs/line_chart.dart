/// Line chart example
import 'package:charts_flutter/flutter.dart' as charts;
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
                          defaultRenderer: new charts.LineRendererConfig(
                              includePoints: true)),
                    ),
                  ],
                ))));
  }
}

/// Sample ordinal data type.
class LineChartData {
  final int xAxis;
  final double yAxis;

  LineChartData(this.xAxis, this.yAxis);
}
