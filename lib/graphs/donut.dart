/// Line chart example
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter/material.dart';

class DonutPieChart extends StatelessWidget {
  final List<charts.Series> seriesList;
  final bool animate;
  final String title;
  final String subtitle;

  DonutPieChart(this.seriesList, {this.animate, this.title, this.subtitle});

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
                      style: Theme.of(context).textTheme.body2,
                    ),
                    Text(
                      subtitle,
                      style: Theme.of(context).textTheme.caption,
                    ),
                    Expanded(
                      child: charts.PieChart(seriesList,
                          animate: animate,
                          behaviors: [new charts.DatumLegend()]),
                    ),
                  ],
                ))));
  }
}

/// used donut pie chart
class DonutChartData {
  final int xAxis;
  final double yAxis;
  final charts.Color color;

  DonutChartData(this.xAxis, this.yAxis, Color color)
      : this.color = new charts.Color(
            r: color.red, g: color.green, b: color.blue, a: color.alpha);
}
