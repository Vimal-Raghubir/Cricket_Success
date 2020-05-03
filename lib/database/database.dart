import 'dart:io';
import 'package:cricket_app/classes/statistics.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import 'package:cricket_app/classes/goalInformation.dart';
import 'package:cricket_app/classes/journalInformation.dart';

// singleton class to manage the database
    class DatabaseHelper {

      // This is the actual database filename that is saved in the docs directory.
      static final _databaseName = "my_statistic_database.db";
      // Increment this version when you need to change the schema.
      static final _databaseVersion = 1;

      // Make this a singleton class.
      DatabaseHelper._privateConstructor();
      static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

      // Only allow a single open connection to the database.
      static Database _database;
      Future<Database> get database async {
        if (_database != null) return _database;
        _database = await _initDatabase();
        return _database;
      }

      // open the database
      _initDatabase() async {
        // The path_provider plugin gets the right directory for Android or iOS.
        Directory documentsDirectory = await getApplicationDocumentsDirectory();
        String path = join(documentsDirectory.path, _databaseName);
        // Open the database. Can also add an onUpdate callback parameter.
        return await openDatabase(path,
            version: _databaseVersion,
            onCreate: _onCreate);
      }

      // SQL string to create the database 
      Future _onCreate(Database db, int version) async {
        await db.execute('''
              CREATE TABLE $tableGoals (
                $columnGoalId INTEGER PRIMARY KEY AUTOINCREMENT,
                $columnGoalName TEXT NOT NULL,
                $columnType TEXT NOT NULL,
                $columnTypeIndex INTEGER NOT NULL,
                $columnDescription TEXT NOT NULL,
                $columnLength INTEGER NOT NULL,
                $columnProgress INTEGER NOT NULL
              )''');

        await db.execute('''
              CREATE TABLE $tableJournals (
                $columnJournalId INTEGER PRIMARY KEY AUTOINCREMENT,
                $columnJournalName TEXT NOT NULL,
                $columnDetails TEXT NOT NULL,
                $columnDate TEXT NOT NULL
              )''');

        await db.execute('''
              CREATE TABLE $tableStatistics (
                $columnStatisticsId INTEGER PRIMARY KEY AUTOINCREMENT,
                $columnStatisticsName TEXT NOT NULL,
                $columnStatisticsRuns INTEGER NOT NULL,
                $columnStatisticsBallsFaced INTEGER NOT NULL,
                $columnStatisticsNotOut INTEGER NOT NULL,
                $columnStatisticsWickets INTEGER NOT NULL,
                $columnStatisticsOvers INTEGER NOT NULL,
                $columnStatisticsRunsConceeded INTEGER NOT NULL,
                $columnStatisticsRunOuts INTEGER NOT NULL,
                $columnStatisticsCatches INTEGER NOT NULL,
                $columnStatisticsStumpings INTEGER NOT NULL,
                $columnStatisticsRunOutsMissed INTEGER NOT NULL,
                $columnStatisticsCatchesMissed INTEGER NOT NULL,
                $columnStatisticsStumpingsMissed INTEGER NOT NULL
              )''');
      }
      // Database helper methods for Journals:

      //Handles inserting a journal
      Future<int> insertJournal(JournalInformation journal) async {
        Database db = await database;
        int id = await db.insert(tableJournals, journal.toMap());
        return id;
      }

      //Function to query only one journal from the list
      Future<JournalInformation> queryJournal(int id) async {
        Database db = await database;
        List<Map> maps = await db.query(tableJournals,
            columns: [columnJournalId, columnJournalName, columnDetails, columnDate],
            where: '$columnJournalId = ?',
            whereArgs: [id]);
        if (maps.length > 0) {
          return JournalInformation.fromMap(maps.first);
        }
        return null;
      }

      //Get all journals in the database
      Future<List<JournalInformation>> getJournals() async {
        Database db = await database;
        final List<Map<String, dynamic>> maps = await db.query(tableJournals);
        return List.generate(maps.length, (i) {
          //Returns the column index along with the other fields since the journalinformation class has an id field
          return JournalInformation(maps[i][columnJournalName], maps[i][columnDetails], maps[i][columnDate], maps[i][columnJournalId]);
        });
      }

      //Function to retrieve all journal names from the database
      Future<List> getJournalNames() async {
        Database db = await database;
        var maps = await db.query(tableJournals, columns: [columnJournalName]);
        return List.generate(maps.length, (i) {
          return maps[i][columnJournalName].toLowerCase();
        });
      }

            //Function to update a specific journal based on unique goal id
      Future<void> updateJournal(JournalInformation journal, int index) async {
        // Get a reference to the database.
        final db = await database;

        // Update the given Journal.
        await db.update(
          tableJournals,
          journal.toMap(),
          // Ensure that the Journal has a matching id.
          where: "$columnJournalId = ?",
          // Pass the Journal's id as a whereArg to prevent SQL injection.
          whereArgs: [index],
        );
      }

      //Handles the deletion of a journal object 
      Future<int> deleteJournal(int id) async {
        final db = await database;
        return await db.delete(tableJournals, where: '$columnJournalId = ?', whereArgs: [id]);
      }
      
      // Database helper methods for Goals:

      //Handles inserting a goal
      Future<int> insertGoal(GoalInformation goal) async {
        Database db = await database;
        int id = await db.insert(tableGoals, goal.toMap());
        return id;
      }

      //Function to query only one goal from the list
      Future<GoalInformation> queryGoal(int id) async {
        Database db = await database;
        List<Map> maps = await db.query(tableGoals,
            columns: [columnGoalId, columnGoalName, columnType, columnTypeIndex, columnDescription, columnLength, columnProgress],
            where: '$columnGoalId = ?',
            whereArgs: [id]);
        if (maps.length > 0) {
          return GoalInformation.fromMap(maps.first);
        }
        return null;
      }

      //Get all goals in the database
      Future<List<GoalInformation>> getGoals() async {
        Database db = await database;
        final List<Map<String, dynamic>> maps = await db.query(tableGoals);
        return List.generate(maps.length, (i) {
          //Returns the column index along with the other fields since the goalinformation class has an id field
          return GoalInformation(maps[i][columnGoalName], maps[i][columnType], maps[i][columnTypeIndex], maps[i][columnDescription], maps[i][columnLength].toDouble(), maps[i][columnProgress], maps[i][columnGoalId]);
        });
      }

      //Function to retrieve all goal names from the database
      Future<List<String>> getGoalNames() async {
        Database db = await database;
        var maps = await db.query(tableGoals, columns: [columnGoalName]);
        return List.generate(maps.length, (i) {
          return maps[i][columnGoalName].toLowerCase();
        });
      }
      
      //Function to update a specific goal based on unique goal id
      Future<void> updateGoal(GoalInformation goal, int index) async {
        // Get a reference to the database.
        final db = await database;

        // Update the given Goal.
        await db.update(
          tableGoals,
          goal.toMap(),
          // Ensure that the Goal has a matching id.
          where: "$columnGoalId = ?",
          // Pass the Goal's id as a whereArg to prevent SQL injection.
          whereArgs: [index],
        );
      }

      //Handles the deletion of a goal object 
      Future<int> deleteGoal(int id) async {
        final db = await database;
        return await db.delete(tableGoals, where: '$columnGoalId = ?', whereArgs: [id]);
        //return await db.delete(tableGoals, where: '$column_name = ?', whereArgs: [goal.name]);
      }


      // Database helper methods for Statistics

      //Handles inserting a goal
      Future<int> insertStatistic(StatisticInformation statistics) async {
        Database db = await database;
        int id = await db.insert(tableStatistics, statistics.toMap());
        return id;
      }

      //Function to query only one goal from the list
      Future<StatisticInformation> queryStatistics(int id) async {
        Database db = await database;
        List<Map> maps = await db.query(tableStatistics,
            columns: [columnStatisticsId, columnStatisticsName, columnStatisticsRuns, columnStatisticsBallsFaced, columnStatisticsNotOut, columnStatisticsWickets, columnStatisticsOvers, columnStatisticsRunsConceeded, columnStatisticsRunOuts, columnStatisticsCatches, columnStatisticsStumpings, columnStatisticsRunOutsMissed, columnStatisticsCatchesMissed, columnStatisticsStumpingsMissed],
            where: '$columnStatisticsId = ?',
            whereArgs: [id]);
        if (maps.length > 0) {
          return StatisticInformation.fromMap(maps.first);
        }
        return null;
      }

      //Get all goals in the database
      Future<List<StatisticInformation>> getStatistics() async {
        Database db = await database;
        final List<Map<String, dynamic>> maps = await db.query(tableStatistics);
        return List.generate(maps.length, (i) {
          //Returns the column index along with the other fields since the goalinformation class has an id field
          return StatisticInformation(maps[i][columnStatisticsName], maps[i][columnStatisticsRuns], maps[i][columnStatisticsBallsFaced], maps[i][columnStatisticsNotOut], maps[i][columnStatisticsWickets], maps[i][columnStatisticsOvers], maps[i][columnStatisticsRunsConceeded], maps[i][columnStatisticsRunOuts], maps[i][columnStatisticsCatches], maps[i][columnStatisticsStumpings], maps[i][columnStatisticsRunOutsMissed], maps[i][columnStatisticsCatchesMissed], maps[i][columnStatisticsStumpingsMissed], maps[i][columnStatisticsId]);
        });
      }

      //Function to retrieve all statistic names from the database
      Future<List<String>> getStatisticNames() async {
        Database db = await database;
        var maps = await db.query(tableStatistics, columns: [columnStatisticsName]);
        return List.generate(maps.length, (i) {
          return maps[i][columnStatisticsName].toLowerCase();
        });
      }
      
      //Function to update a specific statistic based on unique id
      Future<void> updateStatistics(StatisticInformation statistic, int index) async {
        // Get a reference to the database.
        final db = await database;

        // Update the given Statistic.
        await db.update(
          tableStatistics,
          statistic.toMap(),
          // Ensure that the Statistic has a matching id.
          where: "$columnStatisticsId = ?",
          // Pass the Statistic's id as a whereArg to prevent SQL injection.
          whereArgs: [index],
        );
      }

      //Handles the deletion of a statistic object 
      Future<int> deleteStatistic(int id) async {
        final db = await database;
        return await db.delete(tableStatistics, where: '$columnStatisticsId = ?', whereArgs: [id]);
      }


}