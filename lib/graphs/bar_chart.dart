/// Bar chart example
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter/material.dart';

class SimpleBarChart extends StatelessWidget {
  final List<charts.Series> seriesList;
  final bool animate;
  final String title;

  SimpleBarChart(this.seriesList, {this.animate, this.title});

  @override
  Widget build(BuildContext context) {
    return Container(
        height: 300,
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
                      child: charts.BarChart(
                        seriesList,
                        animate: animate,
                        vertical: false,
                        defaultRenderer: new charts.BarRendererConfig(
                            cornerStrategy:
                                const charts.ConstCornerStrategy(30)),
                      ),
                    ),
                  ],
                ))));
  }
}

/// Used for bar charts
class BarChartData {
  final String xAxis;
  final int yAxis;
  final charts.Color color;

  BarChartData(this.xAxis, this.yAxis, Color color)
      : this.color = new charts.Color(
            r: color.red, g: color.green, b: color.blue, a: color.alpha);
}
