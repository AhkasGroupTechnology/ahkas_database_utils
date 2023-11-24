part of ahkas_database_utils;

class AhkasSqlite {
  static AhkasSqlite? _instance;
  static AhkasSqlite getInstance() {
    _instance = _instance ?? AhkasSqlite();
    return _instance!;
  }

  late Database database;
  final _migrationScript = [];
  late String _dataseName;

  Future<bool> ensureInitialize({
    required String databaseName,
    bool forceMigrate = false,
    bool withSeeder = false,
  }) async {
    _dataseName = databaseName;
    _migrationScript.addAll(await _readAllMigrationFile());
    database = await _connectDatabase();
    if (forceMigrate) {
      await _resetDatabase(database.path);
    }
    if (withSeeder) {
      await _seedDatabase();
    }
    return true;
  }

  Future<List<String>> _readAllMigrationFile() async {
    final result = <String>[];
    var assetsFile = await rootBundle.loadString('AssetManifest.json');
    final Map<String, dynamic> manifestMap = json.decode(assetsFile);
    final data = manifestMap.keys.where((String key) => key.contains('.sql')).toList();
    await Future.forEach(data, (element) async => result.add(await rootBundle.loadString(element)));
    return result;
  }

  Future<Database> _connectDatabase() async {
    return await openDatabase(
      '$_dataseName.db',
      version: _migrationScript.length + 1,
      onCreate: (Database db, int version) async {
        for (int i = 0; i < _migrationScript.length; i++) {
          await db.execute(_migrationScript.elementAt(i));
        }
        log('** database created');
        log('** created ${_migrationScript.length} table');
      },
      onUpgrade: (Database db, int oldVersion, int newVersion) async {
        for (int i = oldVersion - 1; i < newVersion - 1; i++) {
          await db.execute(_migrationScript.elementAt(i));
        }
        log('** database migrate success');
      },
    );
  }

  Future<void> _seedDatabase() async {}

  Future<void> _resetDatabase(String path) async {
    await deleteDatabase(path);
    database = await _connectDatabase();
  }
}
