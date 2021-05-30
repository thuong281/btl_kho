//Cols of table place_history
import 'dart:io';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:wemapgl/wemapgl.dart';

String tableName = 'place_history';
String colId = 'id';
String colName = 'name';
String colLat = 'lat';
String colLon = 'lon';
String colCity = 'cityState';
String colStreet = 'street';
String colDescription = 'description';
String colDate = 'last_updated';

class PlaceHistoryHelper {
  static Database _database; // Singleton Database
  // Make this a singleton class.
  PlaceHistoryHelper._privateConstructor();
  static final PlaceHistoryHelper instance =
      PlaceHistoryHelper._privateConstructor();

  // This is the actual database filename that is saved in the docs directory.
  static final _databaseName = "wemap.db";
  // Increment this version when you need to change the schema.
  static final _databaseVersion = 1;

  Future<Database> get database async {
    if (_database == null) {
      _database = await _initDatabase();
    }
    return _database;
  }

  Future<Database> _initDatabase() async {
    // Get the directory path for both Android and iOS to store database.
    Directory directory = await getApplicationDocumentsDirectory();
    String path = join(directory.path, _databaseName);

    // Open/create the database at a given path
    return await openDatabase(
      path,
      version: _databaseVersion,
      onCreate: _createDb,
    );
  }

  static void _createDb(Database db, int newVersion) async {
    await db.execute(
        'CREATE TABLE $tableName($colId INTEGER PRIMARY KEY AUTOINCREMENT, $colName TEXT, '
        '$colLat STRING, $colLon STRING, $colCity TEXT, $colStreet TEXT, $colDescription TEXT, $colDate DATETIME DEFAULT CURRENT_TIMESTAMP)');
  }

  // Insert Operation: Insert a Place object to database
  Future<int> insertPlace(WeMapPlace place) async {
    Database db = await this.database;
    int result = await db.insert(tableName, place.toMap());

    return result;
  }

  // Update Operation: Update a Place object and save it to database
  Future<int> updatePlace(WeMapPlace place) async {
    Database db = await this.database;
    int result = await db.update(tableName, place.toMap(),
        where: '$colId = ?', whereArgs: [place.placeId]);

    return result;
  }

  // Delete Operation: Delete a Place object from database
  Future<int> deletePlace(WeMapPlace place) async {
    Database db = await this.database;
    int result = await db
        .delete(tableName, where: '$colId = ?', whereArgs: [place.placeId]);

    return result;
  }

  // Delete Operation: Delete all object from database
  Future<int> deleteAll() async {
    Database db = await this.database;
    int result = await db.delete(tableName);

    return result;
  }

  // Check exist id Operation: check a exist Place object from database
  Future<bool> existPlace(int placeID) async {
    Database db = await this.database;
    List<Map<String, dynamic>> result = await db.query(
      tableName,
      where: '$colId = ?',
      whereArgs: [placeID],
    );

    return result.length == 0 ? false : true;
  }

  // Get number of Place objects in database
  Future<int> getCount() async {
    Database db = await this.database;
    List<Map<String, dynamic>> x =
        await db.rawQuery('SELECT COUNT (*) from $tableName');
    int result = Sqflite.firstIntValue(x);

    return result;
  }

  // Get the 'Map List' [ List<Map> ] and convert it to 'Place List' [ List<Place> ]
  Future<List<WeMapPlace>> getPlaceList(
      {int limit, int day, int month, int year, bool before}) async {
    Database db = await this.database;
    List<Map<String, dynamic>> placeMapList = await db.rawQuery('''
        SELECT * from $tableName
        ${day == null || month == null || year == null ? '' : ' WHERE '
            '${before == true ? 'strftime(\'%Y %m %d\',$colDate) <= \'$year ${month < 10 ? '0$month' : '$month'} ${day < 10 ? '0$day' : '$day'}\'' : 'strftime(\'%Y %m %d\',$colDate) = \'$year ${month < 10 ? '0$month' : '$month'} ${day < 10 ? '0$day' : '$day'}\''}'}
        order by $colDate DESC
        ${(limit == null ? '' : 'limit $limit')}
        '''); // Get 'Map List' from database
    List<WeMapPlace> placeList = List<WeMapPlace>();
    // For loop to create a 'Place List' fromgit a 'Map List'
    placeMapList.map((pre) {
      // add the place into the map og place list
      placeList.add(WeMapPlace.fromMapObject(pre));
    }).toList(); //tolist mapping the list of place
    return placeList;
  }
}
