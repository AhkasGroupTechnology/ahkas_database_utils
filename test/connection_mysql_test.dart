import 'package:ahkas_database_utils/ahkas_database_utils.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('test', () {
    late String databaseHost;
    late String databaseUser;
    late String databaseName;
    late List<String> migration;
    setUpAll(() {
      WidgetsFlutterBinding.ensureInitialized();
      databaseHost = 'localhost';
      databaseUser = 'root';
      databaseName = 'ahkas_mysql_test';
      migration = [
        'assets/migrations/1_create_table_users.sql',
        'assets/migrations/2_create_table_customers.sql'
      ];
    });

    test('Test connection', () async {
      bool result = await AhkasMysql.getInstance().ensureInitialize(
        settings: ConnectionSettings(
          host: databaseHost,
          user: 'test',
          db: 'test',
        ),
        migrationFilesPath: migration,
      );
      expect(result, false);
      // test with correct connection
      result = await AhkasMysql.getInstance().ensureInitialize(
        settings: ConnectionSettings(
          host: databaseHost,
          user: databaseUser,
          db: databaseName,
        ),
        migrationFilesPath: migration,
        forceMigrate: true,
      );
      expect(result, true);

      int version = AhkasMysql.getInstance().databaseVersion;
      expect(version, greaterThan(0));
    });
  });
}
