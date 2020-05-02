
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
  var totalCatches = 0;
  var totalRunOuts = 0;
  var totalStumpings = 0;
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
      SimpleSeriesLegend(_createFieldingChart(), animate: true, title: "Fielding Dismissals"),
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
      DataColumn(label: Text('Total Catches')),
      DataColumn(label: Text('Total Run Outs')),
      DataColumn(label: Text('Total Stumpings')),
    ], 
    rows: [
      DataRow(cells: [
        //DataCell(Text(statistics.length.toString())),
        DataCell(Text(totalCatches.toString())),
        DataCell(Text(totalRunOuts.toString())),
        DataCell(Text(totalStumpings.toString())),
      ])
    ]);
  }
  //Used to add up all the catches, run outs, and stumpings
  generateFieldingStats() {
    totalCatches = totalRunOuts = totalStumpings = 0;
    for (int i = 0; i < statistics.length; i++) {
      totalCatches += statistics[i].catches;
      totalRunOuts += statistics[i].runOuts;
      totalStumpings += statistics[i].stumpings;
    }
  }

  //Used to generate the fielding chart which is a series bar chart
  List<charts.Series<SeriesChartData, String>> _createFieldingChart() {
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
        //Catches is denoted by a blue bar
        colorFn: (_, __) => charts.MaterialPalette.blue.shadeDefault,
        data: catchesList,
      ),
      new charts.Series<SeriesChartData, String>(
        id: 'Run Outs',
        domainFn: (SeriesChartData runs, _) => runs.xAxis,
        measureFn: (SeriesChartData runs, _) => runs.yAxis,
        //Run Outs is denoted by a red bar
        colorFn: (_, __) => charts.MaterialPalette.red.shadeDefault,
        data: runOutsList,
      ),
      new charts.Series<SeriesChartData, String>(
        id: 'Stumpings',
        domainFn: (SeriesChartData runs, _) => runs.xAxis,
        measureFn: (SeriesChartData runs, _) => runs.yAxis,
        //Stumpings is denoted by a green bar
        colorFn: (_, __) => charts.MaterialPalette.green.shadeDefault,
        data: stumpingsList,
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