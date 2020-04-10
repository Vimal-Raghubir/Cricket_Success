/// Line chart example
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter/material.dart';

class DonutPieChart extends StatelessWidget {
  final List<charts.Series> seriesList;
  final bool animate;
  final String title;

  DonutPieChart(this.seriesList, {this.animate, this.title});



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
              Text(title,
              style: Theme.of(context).textTheme.body2,
              ),
              Expanded(
                child: charts.PieChart(seriesList, animate: animate, defaultRenderer: new charts.ArcRendererConfig(arcWidth: 50,arcRendererDecorators: [new charts.ArcLabelDecorator()])),
              ),
            ],
          )
        )
      )
    );

  }
}

/// Sample ordinal data type.
class Pie_ChartData {
  final int xAxis;
  final double yAxis;

  Pie_ChartData(this.xAxis, this.yAxis);
}