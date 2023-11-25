part of ahkas_database_utils;

abstract class BaseService<T> {
  Future<void> save(T data);
  Future<void> saveAndSync(T data, Function onSynced);
  Future<bool> update(int id, T data);
  Future<bool> updateAndSync(int id, T data, Function onSynced);
  Future<bool> delete(int id);
  Future<bool> deleteAndSync(int id, Function onSynced);
  Future<List<T>> retriveData();
  Future<void> syncData();
}
