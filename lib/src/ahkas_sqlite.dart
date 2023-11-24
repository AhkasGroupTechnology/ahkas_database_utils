part of ahkas_database_utils;

class AhkasSqlite {
  static AhkasSqlite? _instance;
  static AhkasSqlite getInstance() {
    _instance = _instance ?? AhkasSqlite();
    return _instance!;
  }

  late Database database;
  final _migrationScript = [];

  Future<bool> ensureInitialize({required String databaseName}) async {
    _migrationScript.addAll(await _readAllMigrationFile());
    database = await openDatabase(
      '$databaseName.db',
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
}
