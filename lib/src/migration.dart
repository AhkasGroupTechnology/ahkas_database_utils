part of ahkas_database_utils;

abstract class Migration {
  List<String> migrationFile();
}

abstract class Seeder {
  List<String> seederFile();
}
