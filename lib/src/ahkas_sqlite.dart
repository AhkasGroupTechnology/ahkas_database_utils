part of ahkas_database_utils;

class AhkasSqlite {
  static AhkasSqlite? _instance;
  static AhkasSqlite getInstance() {
    _instance = _instance ?? AhkasSqlite();
    return _instance!;
  }

  late Database database;
  late int databaseVersion = 0;
  final _migrationScript = [];

  Future<bool> ensureInitialize({
    required BuildContext context,
    required String databaseName,
    List<String> migrationFilesPath = const [],
  }) async {
    final files = await _readAllMigrationFile(context);

    for (var path in files) {
      _migrationScript.add(await _loadAsset(path: path));
    }

    database = await openDatabase(
      '$databaseName.db',
      version: _migrationScript.length + 1,
      onCreate: (Database db, int version) async {
        // await Future.forEach(_initialScript, (String script) async {
        //   await db.execute(script);
        // });
        log('** database created');
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

  Future<List<String>> _readAllMigrationFile(BuildContext context) async {
    final result = <String>[];
    var assetsFile = await DefaultAssetBundle.of(context).loadString('AssetManifest.json');
    final Map<String, dynamic> manifestMap = json.decode(assetsFile);
    final data = manifestMap.keys.where((String key) => key.contains('.sql')).toList();
    await Future.forEach(data, (element) async => result.add(await rootBundle.loadString(element)));
    return result;
  }

  Future<String> _loadAsset({required String path}) async {
    return await rootBundle.loadString(path);
  }
}
