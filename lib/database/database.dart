import 'dart:io';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import 'package:cricket_app/pages/goals.dart';

// singleton class to manage the database
    class DatabaseHelper {

      // This is the actual database filename that is saved in the docs directory.
      static final _databaseName = "custom_database.db";
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
                $column_id INTEGER PRIMARY KEY AUTOINCREMENT,
                $column_name TEXT NOT NULL,
                $column_type TEXT NOT NULL,
                $column_type_index INTEGER NOT NULL,
                $column_description TEXT NOT NULL,
                $column_length INTEGER NOT NULL,
                $column_progress INTEGER NOT NULL
              )''');
      }

      // Database helper methods:

      Future<int> insert(GoalInformation goal) async {
        Database db = await database;
        int id = await db.insert(tableGoals, goal.toMap());
        return id;
      }

      //Function to query only one goal from the list
      Future<GoalInformation> queryGoal(int id) async {
        Database db = await database;
        List<Map> maps = await db.query(tableGoals,
            columns: [column_id, column_name, column_type, column_type_index, column_description, column_length, column_progress],
            where: '$column_id = ?',
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
          return GoalInformation(maps[i][column_name], maps[i][column_type], maps[i][column_type_index], maps[i][column_description], maps[i][column_length].toDouble(), maps[i][column_progress], maps[i][column_id]);
        });
      }

      //Function to retrieve all goal names from the database
      Future<List> getGoalNames() async {
        Database db = await database;
        var maps = await db.query(tableGoals, columns: [column_name]);
        return List.generate(maps.length, (i) {
          return maps[i][column_name].toLowerCase();
        });
      }
      
      //Function to update a specific goal based on unique goal id
      Future<void> update(GoalInformation goal, int index) async {
        // Get a reference to the database.
        final db = await database;

        // Update the given Goal.
        await db.update(
          tableGoals,
          goal.toMap(),
          // Ensure that the Goal has a matching id.
          where: "$column_id = ?",
          // Pass the Goal's id as a whereArg to prevent SQL injection.
          whereArgs: [index],
        );
      }

      //GoalInformation goal, 
      Future<int> deleteGoal(int id) async {
        final db = await database;
        return await db.delete(tableGoals, where: '$column_id = ?', whereArgs: [id]);
        //return await db.delete(tableGoals, where: '$column_name = ?', whereArgs: [goal.name]);
      }
}