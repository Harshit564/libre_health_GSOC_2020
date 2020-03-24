import 'package:librehealth/model/health.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite/sqlite_api.dart';

class DatabaseProvider {
  static const String TABLE_NAME = "name";
  static const String COLUMN_ID = "id";
  static const String COLUMN_NAME = "name";
  static const String COLUMN_CALORIES = "calories";
  static const String COLUMN_VEGAN = "isVegan";

  DatabaseProvider._();
  static final DatabaseProvider db = DatabaseProvider._();

  Database _database;

  Future<Database> get database async {
    print("database getter called");

    if (_database != null) {
      return _database;
    }

    _database = await createDatabase();

    return _database;
  }

  Future<Database> createDatabase() async {
    String dbPath = await getDatabasesPath();

    return await openDatabase(
      join(dbPath, 'nameDB.db'),
      version: 1,
      onCreate: (Database database, int version) async {
        print("Creating name table");

        await database.execute(
          "CREATE TABLE $TABLE_NAME ("
              "$COLUMN_ID INTEGER PRIMARY KEY,"
              "$COLUMN_NAME TEXT,"
              "$COLUMN_CALORIES TEXT,"
              "$COLUMN_VEGAN INTEGER"
              ")",
        );
      },
    );
  }

  Future<List<Name>> getNames() async {
    final db = await database;

    var names = await db
        .query(TABLE_NAME, columns: [COLUMN_ID, COLUMN_NAME, COLUMN_CALORIES, COLUMN_VEGAN]);

    List<Name> nameList = List<Name>();

    names.forEach((currentName) {
      Name name = Name.fromMap(currentName);

      nameList.add(name);
    });

    return nameList;
  }

  Future<Name> insert(Name name) async {
    final db = await database;
    name.id = await db.insert(TABLE_NAME, name.toMap());
    return name;
  }

  Future<int> delete(int id) async {
    final db = await database;

    return await db.delete(
      TABLE_NAME,
      where: "id = ?",
      whereArgs: [id],
    );
  }

  Future<int> update(Name name) async {
    final db = await database;

    return await db.update(
      TABLE_NAME,
      name.toMap(),
      where: "id = ?",
      whereArgs: [name.id],
    );
  }
}