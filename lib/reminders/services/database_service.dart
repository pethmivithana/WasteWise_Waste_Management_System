import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:csse_waste_management/reminders/models/bin.dart';
import 'package:csse_waste_management/reminders/helpers/date_helper.dart';

class DatabaseService {
  // uses a singleton pattern to create a single instance of a database service
  // Any code calling new DatabaseService() will receive the same singleton instance
  static final DatabaseService _databaseService = DatabaseService._internal();
  DatabaseService._internal();
  factory DatabaseService() {
    return _databaseService;
  }

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    // Initialize the DB first time it is accessed
    _database = await _initDatabase();
    return _database!;
  }

  Future<String> getDatabaseFilename() async {
    final databasePath = await getDatabasesPath();
    return join(databasePath, 'bin_reminder.db');
  }

  Future<Database> _initDatabase() async {
    final path = await getDatabaseFilename();

    return await openDatabase(
      path,
      onCreate: (db, version) async {
        // Run the CREATE TABLE statement on the database.
        return await db.execute(
          'CREATE TABLE ${Bin.tableName} (${Bin.columnId} INTEGER PRIMARY KEY, '
          '${Bin.columnName} TEXT, '
          '${Bin.columnBinType} TEXT, '
          '${Bin.columnBinColor} TEXT, '
          '${Bin.columnCollectionDate} INTEGER, '
          '${Bin.columnCollectionFreq} TEXT, '
          '${Bin.columnIsPaused} INTEGER)',
        );
      },
      version: 1,
    );
  }

  Future<int> insertBin(Bin bin) async {
    final db = await _databaseService.database;
    return await db.insert(
      Bin.tableName,
      bin.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<Bin>> listBins() async {
    final db = await _databaseService.database;
    final List<Map<String, dynamic>> maps = await db.query(Bin.tableName,
        orderBy: '${Bin.columnIsPaused} ASC, ${Bin.columnCollectionDate} ASC');
    return List.generate(maps.length, (index) => Bin.fromMap(maps[index]));
  }

  Future<Bin> getBin(int id) async {
    final db = await _databaseService.database;
    final List<Map<String, dynamic>> maps = await db
        .query(Bin.tableName, where: '${Bin.columnId} = ?', whereArgs: [id]);
    return Bin.fromMap(maps[0]);
  }

  Future<void> updateBin(Bin bin) async {
    final db = await _databaseService.database;
    await db.update(Bin.tableName, bin.toMap(),
        where: '${Bin.columnId} = ?', whereArgs: [bin.id]);
  }

  Future<void> deleteBin(int id) async {
    final db = await _databaseService.database;
    await db
        .delete(Bin.tableName, where: '${Bin.columnId} = ?', whereArgs: [id]);
  }

  Future<void> deleteAll() async {
    final db = await _databaseService.database;
    await db.delete(Bin.tableName);
  }

  /// For any bins with collection dates in the past,
  /// update them to the next due date
  Future<void> updatePastCollectionDates() async {
    final int todayAsEpoch = DateHelper.getToday().millisecondsSinceEpoch;

    final db = await _databaseService.database;
    final List<Map<String, dynamic>> maps = await db.query(Bin.tableName,
        where: '${Bin.columnCollectionDate} < ?', whereArgs: [todayAsEpoch]);

    List<Bin> bins =
        List.generate(maps.length, (index) => Bin.fromMap(maps[index]));

    for (Bin b in bins) {
      Bin updated = Bin(
          id: b.id,
          name: b.name,
          binType: b.binType,
          binColor: b.binColor,
          collectionDate: DateHelper.getNextCollectionDate(
              b.collectionDate, b.collectionFrequency),
          collectionFrequency: b.collectionFrequency,
          isPaused: b.isPaused);

      await updateBin(updated);
    }
  }

  /// list all bins where the collection is due today or tomorrow
  Future<List<Bin>> listDueBins() async {
    // get the cutoff date.
    // 2 days in the future minus one second will give us tomorrow night
    final int collectionDueCutoffAsEpoch = DateHelper.getToday()
        .add(const Duration(days: 2))
        .subtract(const Duration(seconds: 1))
        .millisecondsSinceEpoch;

    final db = await _databaseService.database;
    final List<Map<String, dynamic>> maps = await db.query(Bin.tableName,
        where: '${Bin.columnIsPaused} = 0 AND ${Bin.columnCollectionDate} < ?',
        whereArgs: [collectionDueCutoffAsEpoch]);

    return List.generate(maps.length, (index) => Bin.fromMap(maps[index]));
  }
}
