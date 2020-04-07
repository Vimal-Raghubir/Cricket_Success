import 'dart:io';
import 'package:cricket_app/classes/statistics.dart';
import 'package:cricket_app/pages/statistics.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import 'package:cricket_app/classes/goalInformation.dart';
import 'package:cricket_app/classes/journalInformation.dart';

// singleton class to manage the database
    class DatabaseHelper {

      // This is the actual database filename that is saved in the docs directory.
      static final _databaseName = "dynamic_database.db";
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
                $column_goal_id INTEGER PRIMARY KEY AUTOINCREMENT,
                $column_goal_name TEXT NOT NULL,
                $column_type TEXT NOT NULL,
                $column_type_index INTEGER NOT NULL,
                $column_description TEXT NOT NULL,
                $column_length INTEGER NOT NULL,
                $column_progress INTEGER NOT NULL
              )''');

        await db.execute('''
              CREATE TABLE $tableJournals (
                $column_journal_id INTEGER PRIMARY KEY AUTOINCREMENT,
                $column_journal_name TEXT NOT NULL,
                $column_details TEXT NOT NULL,
                $column_date TEXT NOT NULL
              )''');

        await db.execute('''
              CREATE TABLE $tableStatistics (
                $column_statistics_id INTEGER PRIMARY KEY AUTOINCREMENT,
                $column_statistics_name TEXT NOT NULL,
                $column_statistics_runs INTEGER NOT NULL,
                $column_statistics_balls_faced INTEGER NOT NULL,
                $column_statistics_not_out INTEGER NOT NULL,
                $column_statistics_wickets INTEGER NOT NULL,
                $column_statistics_overs INTEGER NOT NULL,
                $column_statistics_runs_conceeded INTEGER NOT NULL,
                $column_statistics_run_outs INTEGER NOT NULL,
                $column_statistics_catches INTEGER NOT NULL,
                $column_statistics_stumpings INTEGER NOT NULL,
                $column_statistics_rating INTEGER NOT NULL
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
            columns: [column_journal_id, column_journal_name, column_details, column_date],
            where: '$column_journal_id = ?',
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
          return JournalInformation(maps[i][column_journal_name], maps[i][column_details], maps[i][column_date], maps[i][column_journal_id]);
        });
      }

      //Function to retrieve all journal names from the database
      Future<List> getJournalNames() async {
        Database db = await database;
        var maps = await db.query(tableJournals, columns: [column_journal_name]);
        return List.generate(maps.length, (i) {
          return maps[i][column_journal_name].toLowerCase();
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
          where: "$column_journal_id = ?",
          // Pass the Journal's id as a whereArg to prevent SQL injection.
          whereArgs: [index],
        );
      }

      //Handles the deletion of a journal object 
      Future<int> deleteJournal(int id) async {
        final db = await database;
        return await db.delete(tableJournals, where: '$column_journal_id = ?', whereArgs: [id]);
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
            columns: [column_goal_id, column_goal_name, column_type, column_type_index, column_description, column_length, column_progress],
            where: '$column_goal_id = ?',
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
          return GoalInformation(maps[i][column_goal_name], maps[i][column_type], maps[i][column_type_index], maps[i][column_description], maps[i][column_length].toDouble(), maps[i][column_progress], maps[i][column_goal_id]);
        });
      }

      //Function to retrieve all goal names from the database
      Future<List<String>> getGoalNames() async {
        Database db = await database;
        var maps = await db.query(tableGoals, columns: [column_goal_name]);
        return List.generate(maps.length, (i) {
          return maps[i][column_goal_name].toLowerCase();
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
          where: "$column_goal_id = ?",
          // Pass the Goal's id as a whereArg to prevent SQL injection.
          whereArgs: [index],
        );
      }

      //Handles the deletion of a goal object 
      Future<int> deleteGoal(int id) async {
        final db = await database;
        return await db.delete(tableGoals, where: '$column_goal_id = ?', whereArgs: [id]);
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
            columns: [column_statistics_id, column_statistics_name, column_statistics_runs, column_statistics_balls_faced, column_statistics_not_out, column_statistics_wickets, column_statistics_overs, column_statistics_runs_conceeded, column_statistics_run_outs, column_statistics_catches, column_statistics_stumpings, column_statistics_rating],
            where: '$column_statistics_id = ?',
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
          return StatisticInformation(maps[i][column_statistics_name], maps[i][column_statistics_runs], maps[i][column_statistics_balls_faced], maps[i][column_statistics_not_out], maps[i][column_statistics_wickets], maps[i][column_statistics_overs], maps[i][column_statistics_runs_conceeded], maps[i][column_statistics_run_outs], maps[i][column_statistics_catches], maps[i][column_statistics_stumpings], maps[i][column_statistics_rating]);
        });
      }

      //Function to retrieve all statistic names from the database
      Future<List<String>> getStatisticNames() async {
        Database db = await database;
        var maps = await db.query(tableStatistics, columns: [column_statistics_name]);
        return List.generate(maps.length, (i) {
          return maps[i][column_statistics_name].toLowerCase();
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
          where: "$column_statistics_id = ?",
          // Pass the Statistic's id as a whereArg to prevent SQL injection.
          whereArgs: [index],
        );
      }

      //Handles the deletion of a statistic object 
      Future<int> deleteStatistic(int id) async {
        final db = await database;
        return await db.delete(tableStatistics, where: '$column_statistics_id = ?', whereArgs: [id]);
      }


}