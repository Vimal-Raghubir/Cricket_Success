
import 'package:cricket_app/cardDecoration/customStatisticCard.dart';
import 'package:cricket_app/classes/statistics.dart';
import 'package:cricket_app/database/database.dart';
import 'package:cricket_app/graphs/serieslegend.dart';
import 'package:cricket_app/pages/createStatistic.dart';
import 'package:cricket_app/pages/statisticDetails.dart';
import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;

List<StatisticInformation> statistics = [];

//Used to handle the fielding page
class FieldingTab extends StatefulWidget {
  @override
  _MyFieldingTabState createState() => new _MyFieldingTabState();
}

class _MyFieldingTabState extends State<FieldingTab> {
  
  //Variables below are used for header stats table
  var catchingRatio = 0.0;
  var runOutRatio = 0.0;
  var stumpingRatio = 0.0;
  var width;

  @protected
  @mustCallSuper
  initState() {
    super.initState();
    //Extract passed in goal and initializes dynamic variables with their values. Starting point
    refresh();
  }

  refresh() async {
    //Had to make read asynchronous to wait on the results of the database retrieval before rendering the UI
    await _read();
    if (this.mounted){
      print("Refresh was called");
      setState(() {
      });
    }
  }

  Widget build(BuildContext context) {
    width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: ListView(children: <Widget>[
      createStatsTable(),
      SimpleSeriesLegend(_createFieldingChart('Taken', 'Dropped', "Catches"), animate: true, title: "Catches Taken vs. Dropped"),
      SimpleSeriesLegend(_createFieldingChart('Taken', 'Missed', "Run Outs"), animate: true, title: "Successful vs. Missed Run Outs"),
      SimpleSeriesLegend(_createFieldingChart('Taken', 'Missed', "Stumpings"), animate: true, title: "Successful vs. Missed Stumpings"),
      //Add datatable here
      statList(),
    ]),
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
            refresh();
        },
        child: Icon(Icons.add),
        backgroundColor: Colors.green,
      ),
    );
  }

  //Used to render the datatable for the stats
  DataTable createStatsTable() {
    //Need to call this to set the catches, run outs, and stumpings
    generateFieldingStats();
    //Might need to change the horizontalMargin if issues with space
    return DataTable( horizontalMargin: 30, columnSpacing: 0, columns: [
      //DataColumn(label: Text('Matches Played')),
      DataColumn(label: Text('Catching Ratio')),
      DataColumn(label: Text('Run Out Ratio')),
      DataColumn(label: Text('Stumping Ratio')),
    ], 
    rows: [
      DataRow(cells: [
        //DataCell(Text(statistics.length.toString())),
        DataCell(Text(catchingRatio.toStringAsFixed(2))),
        DataCell(Text(runOutRatio.toStringAsFixed(2))),
        DataCell(Text(stumpingRatio.toStringAsFixed(2))),
      ])
    ]);
  }
  //Used to add up all the catches, run outs, and stumpings
  generateFieldingStats() {
    var totalCatches = 0;
    var totalCatchesTaken = 0;
    var totalRunOuts = 0;
    var totalRunOutsTaken = 0;
    var totalStumpings = 0;
    var totalStumpingsTaken = 0;

    catchingRatio = 0.0;
    runOutRatio = 0.0;
    stumpingRatio = 0.0;

    for (int i = 0; i < statistics.length; i++) {
      totalCatches += (statistics[i].catches + statistics[i].catchesMissed);
      totalRunOuts += (statistics[i].runOuts + statistics[i].runOutsMissed);
      totalStumpings += (statistics[i].stumpings + statistics[i].stumpingsMissed);

      totalCatchesTaken += statistics[i].catches;
      totalRunOutsTaken += statistics[i].runOuts;
      totalStumpingsTaken += statistics[i].stumpings;
    }

    if (totalCatches != 0 && totalCatchesTaken != 0) {
      catchingRatio = (totalCatchesTaken / totalCatches) * 100;
    }

    if (totalRunOuts != 0 && totalRunOutsTaken != 0) {
      runOutRatio = (totalRunOutsTaken / totalRunOuts) * 100;
    }

    if (totalStumpings != 0 && totalStumpingsTaken != 0) {
      stumpingRatio = (totalStumpingsTaken / totalStumpings) * 100;
    }
  }

  //Used to generate the fielding chart which is a series bar chart
  List<charts.Series<SeriesChartData, String>> _createFieldingChart(String firstKey, String secondKey, String type) {
    List<SeriesChartData> takenList;
    List<SeriesChartData> missedList;

    if (type == "Catches") {
      takenList = statistics.map((stat) => SeriesChartData(stat.name, stat.catches)).toList();
      missedList = statistics.map((stat) => SeriesChartData(stat.name, stat.catchesMissed)).toList();
    } else if (type == "Run Outs") {
      takenList = statistics.map((stat) => SeriesChartData(stat.name, stat.runOuts)).toList();
      missedList = statistics.map((stat) => SeriesChartData(stat.name, stat.runOutsMissed)).toList();
    } else if (type == "Stumpings") {
      takenList = statistics.map((stat) => SeriesChartData(stat.name, stat.stumpings)).toList();
      missedList = statistics.map((stat) => SeriesChartData(stat.name, stat.stumpingsMissed)).toList();     
    }


    return [
      new charts.Series<SeriesChartData, String>(
        id: firstKey,
        domainFn: (SeriesChartData runs, _) => runs.xAxis,
        measureFn: (SeriesChartData runs, _) => runs.yAxis,
        //Catches is denoted by a blue bar
        colorFn: (_, __) => charts.MaterialPalette.green.shadeDefault,
        data: takenList,
      ),
      new charts.Series<SeriesChartData, String>(
        id: secondKey,
        domainFn: (SeriesChartData runs, _) => runs.xAxis,
        measureFn: (SeriesChartData runs, _) => runs.yAxis,
        //Catches is denoted by a blue bar
        colorFn: (_, __) => charts.MaterialPalette.red.shadeDefault,
        data: missedList,
      ),
    ];
  }

  Widget statList() {
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
                child: CustomStatisticCard(object: statistics[index], width: width,type: 2)
              );  
            }
        );
  }

   //Function to read all statistics from the database for rendering
  _read() async {
    DatabaseHelper helper = DatabaseHelper.instance;
    //statistics now stores the index of each statistics in the database
    statistics = await helper.getStatistics();
  }
}