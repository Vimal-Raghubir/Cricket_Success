/// Bar chart example
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:cricket_app/theme/config.dart';
import 'package:flutter/material.dart';

class SimpleBarChart extends StatefulWidget {
  final List<charts.Series> seriesList;
  final bool animate;
  final String title;

  SimpleBarChart(this.seriesList, {this.animate, this.title});
  _SimpleBarChartState createState() => new _SimpleBarChartState();
}

class _SimpleBarChartState extends State<SimpleBarChart> {
  @override
  Widget build(BuildContext context) {
    Color axisColor = currentColor.currentColor();
    return Container(
        height: 300,
        padding: EdgeInsets.all(20),
        child: Card(
            child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: <Widget>[
                    Text(
                      widget.title,
                      style: Theme.of(context).textTheme.bodyText1,
                    ),
                    Expanded(
                      child: charts.BarChart(
                        widget.seriesList,
                        animate: widget.animate,
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

                        defaultRenderer: new charts.BarRendererConfig(
                            cornerStrategy:
                                const charts.ConstCornerStrategy(30)),
                      ),
                    ),
                  ],
                ))));
  }

  charts.Color getChartColor(Color color) {
    return charts.Color(
        r: color.red, g: color.green, b: color.blue, a: color.alpha);
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
