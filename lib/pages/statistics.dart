import 'dart:math';
import 'package:flutter/material.dart';
import 'package:cricket_app/navigation/bottom_navigation.dart';
import 'package:cricket_app/graphs/bar_chart.dart';
import 'package:cricket_app/graphs/line_chart.dart';
import 'package:cricket_app/graphs/donut.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:cricket_app/pages/createStatistic.dart';
import 'package:cricket_app/pages/statisticDetails.dart';
import 'package:cricket_app/classes/statistics.dart';
import 'package:cricket_app/database/database.dart';

var allBarColors = [Colors.red, Colors.blue, Colors.green, Colors.yellow, Colors.indigo, Colors.cyan, Colors.orange, Colors.teal, Colors.amber];

List<StatisticInformation> statistics = [];

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
  static List<charts.Series<Bar_ChartData, String>> _createRunsChart() {

    List<Bar_ChartData> list = statistics.map((stat) => Bar_ChartData(stat.name, stat.runs)).toList();

    return [
      new charts.Series<Bar_ChartData, String>(
        id: 'Runs',
        domainFn: (Bar_ChartData runs, _) => runs.xAxis,
        measureFn: (Bar_ChartData runs, _) => runs.yAxis,
        data: list,
      )
    ];
  }

    /// Create one series with sample hard coded data.
  static List<charts.Series<Bar_ChartData, String>> _createStrikeRateChart() {
    List<Bar_ChartData> list = statistics.map((stat) => Bar_ChartData(stat.name, stat.runs != 0 && stat.balls_faced != 0 ? (stat.runs / stat.balls_faced * 100).toInt(): 0)).toList();

    return [
      new charts.Series<Bar_ChartData, String>(
        id: 'Strike Rate',
        domainFn: (Bar_ChartData runs, _) => runs.xAxis,
        measureFn: (Bar_ChartData runs, _) => runs.yAxis,
        data: list,
      )
    ];
  }

    /// Create one series with sample hard coded data.
  static List<charts.Series<Line_ChartData, int>> _createLineData() {

    List<Line_ChartData> list = statistics.map((stat) => Line_ChartData(stat.id, stat.runs.toDouble())).toList();

    return [
      new charts.Series<Line_ChartData, int>(
        id: 'Average',
        colorFn: (_, __) => charts.MaterialPalette.blue.shadeDefault,
        domainFn: (Line_ChartData sales, _) => sales.xAxis,
        measureFn: (Line_ChartData sales, _) => sales.yAxis,
        data: list,
      )
    ];
}

    /// Create one series with sample hard coded data.
  static List<charts.Series<Pie_ChartData, int>> _createDonutData() {
    List<Pie_ChartData> list = statistics.map((stat) => Pie_ChartData(stat.id, stat.runs.toDouble())).toList();

    return [
      new charts.Series<Pie_ChartData, int>(
        id: 'Sales',
        domainFn: (Pie_ChartData sales, _) => sales.xAxis,
        measureFn: (Pie_ChartData sales, _) => sales.yAxis,
        data: list,
      )
    ];
}

  Widget battingPage() {
    return ListView(children: <Widget>[
      SimpleBarChart(_createRunsChart(), animate: true, title: "Runs per Game"),
      SimpleLineChart(_createLineData(), animate: true, title: "Batting Average progression"),
      SimpleBarChart(_createStrikeRateChart(), animate: true, title: "Strike Rate"),
      //DonutPieChart(_createDonutData(), animate: true, title: "Ways of scoring runs"),
      ListView.builder (
        shrinkWrap: true,
                  physics: BouncingScrollPhysics(),
                  itemCount: statistics.length,
                  itemBuilder: (BuildContext ctxt, int index) {
                    print("Creating list " + statistics.length.toString());
                    //Need to change below
                    return InkWell(
                      //This needs to be asynchronous since you have to wait on the results of the update page
                      onTap: () async {
                        //Pass the goal information to the goalDetails.dart page
                        await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => StatisticDetails(
                            //Helps to prevent range issues
                            statistic: statistics?.elementAt(index) ?? "",
                            )
                          ),
                        );
                        //Then rebuild the widget
                        refresh();
                      },
                      //Render custom card for each goal
                      child: Card(
                        child: Container(
                            width: 300,
                            height: 100,
                            child: Text(statistics[index].name),
                        ),
                      ),
                    );  
                  }
                )
    ]);
    
    //return SimpleBarChart(_createSampleData(), animate: true);
  }

  Widget bowlingPage() {
    return Container(alignment: Alignment.center, child: Text("Bowling"));
  }


  /// Create one series with sample hard coded data.
  static List<charts.Series<Bar_ChartData, String>> _createFieldingChart() {

    List<Bar_ChartData> list = statistics.map((stat) => Bar_ChartData(stat.name, (stat.catches + stat.run_outs + stat.stumpings))).toList();

    return [
      new charts.Series<Bar_ChartData, String>(
        id: 'Fielding',
        domainFn: (Bar_ChartData runs, _) => runs.xAxis,
        measureFn: (Bar_ChartData runs, _) => runs.yAxis,
        data: list,
      )
    ];
  }

  Widget fieldingPage() {
    return ListView(children: <Widget>[
      SimpleBarChart(_createFieldingChart(), animate: true, title: "Fielding dismissals"),
      ListView.builder (
        shrinkWrap: true,
                  physics: BouncingScrollPhysics(),
                  itemCount: statistics.length,
                  itemBuilder: (BuildContext ctxt, int index) {
                    //Need to change below
                    return InkWell(
                      //This needs to be asynchronous since you have to wait on the results of the update page
                      onTap: () async {
                        //Pass the goal information to the goalDetails.dart page
                        await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => StatisticDetails(
                            //Helps to prevent range issues
                            statistic: statistics?.elementAt(index) ?? "",
                            )
                          ),
                        );
                        //Then rebuild the widget
                        refresh();
                      },
                      //Render custom card for each goal
                      child: Card(
                        child: Container(
                            width: 300,
                            height: 100,
                            child: Text(statistics[index].name),
                        ),
                      ),
                    );  
                  }
                )
    ]);
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
                builder: (context) => NewStatistic(
                  //Helps to prevent range issues
                  statistic: StatisticInformation(),
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

    //Function to read all goals from the database for rendering
  _read() async {
    DatabaseHelper helper = DatabaseHelper.instance;
    //goals now stores the index of each goalInformation in the database
    statistics = await helper.getStatistics();
    print("Pulling from database " + statistics.length.toString());
  }
}