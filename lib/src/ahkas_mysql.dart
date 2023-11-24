part of ahkas_database_utils;

class AhkasMysql {
  static AhkasMysql? _instance;
  static AhkasMysql getInstance() {
    _instance = _instance ?? AhkasMysql();
    return _instance!;
  }

  late ConnectionSettings _setting;
  late MySqlConnection _database;
  late int databaseVersion = 0;
  final _migrationScript = [];
  final _migrationFilesPath = [];

  Future<bool> ensureInitialize({
    required ConnectionSettings settings,
    List<String> migrationFilesPath = const [],
    bool forceMigrate = false,
  }) async {
    _setting = settings;
    final connectionResult = await testConnection(settings: _setting);
    if (connectionResult == false) {
      return false;
    }
    _database = await MySqlConnection.connect(_setting);
    _migrationFilesPath.addAll(migrationFilesPath);
    if (forceMigrate) {
      await _dropAllTable();
      // reconnect
      _database = await MySqlConnection.connect(_setting);
    }
    await _getDatabaseVersion();
    await _readAllMigrationScript();
    await _runMigrationScript();
    return true;
  }

  Future<bool> testConnection({required ConnectionSettings settings}) async {
    try {
      log('test connection');
      final result = await MySqlConnection.connect(settings);
      final data = await result.query('SELECT version()');
      return data.isNotEmpty;
    } catch (e) {
      return false;
    }
  }

  Future<void> _readAllMigrationScript() async {
    log('read migration script');
    await Future.forEach(_migrationFilesPath, (path) async {
      _migrationScript.add(await _loadAsset(path: path));
    });
  }

  Future<void> _runMigrationScript() async {
    log('run migration script');
    for (int i = databaseVersion; i <= _migrationScript.length - 1; i++) {
      await _database.query(_migrationScript.elementAt(i));
    }
    databaseVersion = _migrationScript.length;
  }

  Future<void> _getDatabaseVersion() async {
    final result = await _database.query(
      'SELECT count(*) AS total FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA = \'${_setting.db}\'',
    );
    if (result.isNotEmpty) {
      databaseVersion = result.first.first;
      return;
    }
    databaseVersion = 0;
  }

  Future<String> _loadAsset({required String path}) async {
    return await rootBundle.loadString(path);
  }

  Future<void> _dropAllTable() async {
    log('drop all table');
    await _database.query('DROP DATABASE ${_setting.db}');
    await _database.query('CREATE DATABASE ${_setting.db}');
  }

  Future<void> closeConnection() async {
    await _database.close();
  }
}
