import 'package:cricket_app/cardDecoration/customStatisticCard.dart';
import 'package:cricket_app/statisticsTabs/battingTab.dart';
import 'package:flutter/material.dart';
import 'package:cricket_app/navigation/bottom_navigation.dart';
import 'package:cricket_app/graphs/bar_chart.dart';
import 'package:cricket_app/graphs/line_chart.dart';
import 'package:cricket_app/graphs/serieslegend.dart';
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
  var width;
  final List<Color> barColors = [Colors.amber, Colors.blue, Colors.green, Colors.red, Colors.orange, Colors.purple, Colors.yellow[700], Colors.cyan, Colors.indigo, Colors.lightGreen, Colors.deepOrange, Colors.teal]; 

  initState() {
    super.initState();
    refresh();
  }

  refresh() async {
    //Had to make read asynchronous to wait on the results of the database retrieval before rendering the UI
    await _read();
    if (this.mounted){
      setState(() {});
    }
  }

  List<LineChartData> generateBowlingAverage() {
    List<int> dismissals = [];
    List<int> totalRunsConceeded = [];

    List<LineChartData> finalList = [];

    for (int i = 0; i < statistics.length; i++) {
      if (i == 0) {
        totalRunsConceeded.add(statistics[i].runsConceeded);
        dismissals.add(statistics[i].wickets);
      } else {
        totalRunsConceeded.add(totalRunsConceeded[i-1] + statistics[i].runsConceeded);
        dismissals.add(dismissals[i-1] + statistics[i].wickets);
      }
    }

    for (int i = 0; i < statistics.length; i++) {
      double average = 0;
      if (dismissals[i] == 0 || totalRunsConceeded[i] == 0) {
        average = totalRunsConceeded[i].toDouble();
      } else {
        average = totalRunsConceeded[i] / dismissals[i];
      }
      finalList.add(LineChartData(i, average));
    } 
    return finalList;
  }

  static List<charts.Series<SeriesChartData, String>> _createFieldingChart() {
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

   List<BarChartData> generateEconomyRate() {
    var economyRates = [0, 0, 0, 0, 0];
    var ranges = ["0-4", "4-6", "6-8", "8-10", "10+"];

    List<BarChartData> finalList = [];

    for (int i = 0; i < statistics.length; i++) {
      if (statistics[i].overs == 0 || statistics[i].runsConceeded == 0) {
        economyRates[0] += 1;
      } else {
        double economy = statistics[i].runsConceeded / statistics[i].overs;

        if (economy >= 0 && economy < 4) {
          economyRates[0] += 1;
        } else if (economy >= 4 && economy < 6) {
          economyRates[1] += 1;
        } else if (economy >= 6 && economy < 8) {
          economyRates[2] += 1;
        } else if (economy >= 8 && economy < 10) {
          economyRates[3] += 1;
        } else if (economy >= 10) {
          economyRates[4] += 1;
        }
      }
    }
    int j = 0;
    for (int i = 0; i < economyRates.length; i++) {
      if (j == (barColors.length - 1)) {
        j = 0;
      }
      finalList.add(BarChartData(ranges[i], economyRates[i], barColors[j]));
      j++;
    }
    
    return finalList;
  }


  /// Create one series with sample hard coded data.
  List<charts.Series<BarChartData, String>> _createBarChart(String type) {
    List<BarChartData> list = [];
    if (type == "Runs") {
      int j = 0;
      for (int i = 0; i < statistics.length; i++) {
        if (j == (barColors.length - 1)) {
          j = 0;
        }
        list.add(BarChartData(statistics[i].name, statistics[i].runs, barColors[j]));
        j++;
      }
    } else if (type == "Wickets") {
      int j = 0;
      for (int i = 0; i < statistics.length; i++) {
        if (j == (barColors.length - 1)) {
          j = 0;
        }
        list.add(BarChartData(statistics[i].name, statistics[i].wickets, barColors[j]));
        j++;
      }
    } else if (type == "Economy Rate") {
      //Need to fix
      list = generateEconomyRate();
    }

    return [
      new charts.Series<BarChartData, String>(
        id: type,
        domainFn: (BarChartData runs, _) => runs.xAxis,
        measureFn: (BarChartData runs, _) => runs.yAxis,
        colorFn: (BarChartData runs, _) => runs.color,
        data: list,
      )
    ];
  }

    /// Create one series with sample hard coded data.
  List<charts.Series<LineChartData, int>> _createLineData(String type) {
    List<LineChartData> list;
    
    if (type == "Bowling Average") {
      list = generateBowlingAverage();
    }


    return [
      new charts.Series<LineChartData, int>(
        id: type,
        colorFn: (_, __) => charts.MaterialPalette.green.shadeDefault,
        domainFn: (LineChartData sales, _) => sales.xAxis,
        measureFn: (LineChartData sales, _) => sales.yAxis,
        data: list,
      )
    ];
}

Widget statList(int type) {
  width = MediaQuery.of(context).size.width;
  return ListView.builder (
            shrinkWrap: true,
            physics: ScrollPhysics(),
            itemCount: statistics.length,
            itemBuilder: (BuildContext ctxt, int index) {
              return InkWell(
              //This needs to be asynchronous since you have to wait on the results of the update page
                onTap: () async {
                //Pass the statistic information to the statisticDetails.dart page
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
                child: CustomStatisticCard(object: statistics[index], width: width,type: type)
              );  
            }
        );
}

  Widget bowlingPage() {
    return ListView(children: <Widget>[
      SimpleBarChart(_createBarChart("Wickets"), animate: true, title: "Wickets per Game"),
      SimpleLineChart(_createLineData("Bowling Average"), animate: true, title: "Bowling Average Progression"),
      SimpleBarChart(_createBarChart("Economy Rate"), animate: true, title: "Economy Rate Frequency"),
      statList(1),
    ]);
  }

  Widget fieldingPage() {
    return ListView(children: <Widget>[
      SimpleSeriesLegend(_createFieldingChart(), animate: true, title: "Fielding Dismissals"),
      statList(2),
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: DefaultTabController(
        length: 3,
        child: Scaffold(
          bottomNavigationBar: BottomNavigation().createBottomNavigation(context, 4),
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
              BattingTab().battingPage(statistics),
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
  }
}