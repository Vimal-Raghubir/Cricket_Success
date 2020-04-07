import 'dart:math';
import 'package:flutter/material.dart';
import 'package:cricket_app/navigation/bottom_navigation.dart';
import 'package:cricket_app/graphs/bar_chart.dart';
import 'package:cricket_app/graphs/line_chart.dart';
import 'package:cricket_app/graphs/donut.dart';
import 'package:charts_flutter/flutter.dart' as charts;

var allBarColors = [Colors.red, Colors.blue, Colors.green, Colors.yellow, Colors.indigo, Colors.cyan, Colors.orange, Colors.teal, Colors.amber];

//Used to handle the tutorial page
class Statistics extends StatefulWidget {
  _StatisticsState createState() => _StatisticsState();
}

class _StatisticsState extends State<Statistics> {
  var index = 0;

  initState() {
    index = 0 + Random().nextInt(allBarColors.length - 1);
  }

  refresh() async {
    //Had to make read asynchronous to wait on the results of the database retrieval before rendering the UI
    await _read();
    print("refresh is called");
    if (!mounted) return;
    setState(() {});
  }


  /// Create one series with sample hard coded data.
  static List<charts.Series<Bar_ChartData, String>> _createBarData() {
    final data = [
      new Bar_ChartData('1', 5, Colors.red),
      new Bar_ChartData('2', 25, Colors.blue),
      new Bar_ChartData('3', 100, Colors.green),
      new Bar_ChartData('4', 75, Colors.yellow),
      new Bar_ChartData('4', 25, Colors.indigo),
      new Bar_ChartData('6', 10, Colors.cyan),
      new Bar_ChartData('7', 35, Colors.orange),
      new Bar_ChartData('8', 68, Colors.amber),
    ];

    return [
      new charts.Series<Bar_ChartData, String>(
        id: 'Sales',
        colorFn: (Bar_ChartData runs, _) => runs.color,
        domainFn: (Bar_ChartData runs, _) => runs.xAxis,
        measureFn: (Bar_ChartData runs, _) => runs.yAxis,
        data: data,
      )
    ];
  }

    /// Create one series with sample hard coded data.
  static List<charts.Series<Line_ChartData, int>> _createLineData() {
    final data = [
      new Line_ChartData(0, 5),
      new Line_ChartData(1, 30/2),
      new Line_ChartData(2, 130/3),
      new Line_ChartData(3, 205/4),
    ];

    return [
      new charts.Series<Line_ChartData, int>(
        id: 'Sales',
        colorFn: (_, __) => charts.MaterialPalette.blue.shadeDefault,
        domainFn: (Line_ChartData sales, _) => sales.xAxis,
        measureFn: (Line_ChartData sales, _) => sales.yAxis,
        data: data,
      )
    ];
}

    /// Create one series with sample hard coded data.
  static List<charts.Series<Pie_ChartData, int>> _createDonutData() {
    final data = [
      new Pie_ChartData(0, 100, Colors.blue),
      new Pie_ChartData(1, 75, Colors.red),
      new Pie_ChartData(2, 25, Colors.amber),
      new Pie_ChartData(3, 5, Colors.green),
    ];

    return [
      new charts.Series<Pie_ChartData, int>(
        id: 'Sales',
        domainFn: (Pie_ChartData sales, _) => sales.xAxis,
        measureFn: (Pie_ChartData sales, _) => sales.yAxis,
        colorFn: (Pie_ChartData sales, _) => sales.color,
        data: data,
      )
    ];
}

  Widget battingPage() {
    return ListView(children: <Widget>[
      SimpleBarChart(_createBarData(), animate: true, title: "Runs per Game"),
      SimpleLineChart(_createLineData(), animate: true, title: "Batting Average progression"),
      DonutPieChart(_createDonutData(), animate: true, title: "Ways of scoring runs")
    ]);
    
    //return SimpleBarChart(_createSampleData(), animate: true);
  }

  Widget bowlingPage() {
    return Container(alignment: Alignment.center, child: Text("Bowling"));
  }

  Widget fieldingPage() {
    return Container(alignment: Alignment.center, child: Text("Fielding"));
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: DefaultTabController(
        length: 3,
        child: Scaffold(
          bottomNavigationBar: Bottom_Navigation().createBottomNavigation(context, 4),
          appBar: AppBar(
            bottom: TabBar(
              tabs: [
                Tab(icon: Image.asset('assets/images/statistics/bat.png', width: 35, height: 35), text: "Batting"),
                Tab(icon: Image.asset('assets/images/statistics/ball.png', width: 35, height: 35), text: "Bowling"),
                Tab(icon: Image.asset('assets/images/statistics/fielding.png', width: 35, height: 35), text: "Fielding"),
              ],
            ),
            title: Text("Statistics"),
          ),
          body: TabBarView(
            children: [
              battingPage(),
              bowlingPage(),
              fieldingPage(),
            ],
          ),
          floatingActionButton: FloatingActionButton (
          //Need this to be asynchronous since you have to wait on the results of the new goal page
          onPressed: () async {
            await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => NewGoal(
                  //Helps to prevent range issues
                  goal: GoalInformation(),
                )
              ),
            );
          //Rebuild the widget
          refresh();
        },
        child: Icon(Icons.add),
        backgroundColor: Colors.green,
      ),
        ),
      ),
    );
  }
}