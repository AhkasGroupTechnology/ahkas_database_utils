part of ahkas_database_utils;

abstract class NetworkRepoInterface<T> {
  Future<int> addData(T data) => Future.value(0);
  Future<bool> saveDataBatch(List<T> data) => Future.value(false);
  Future<bool> updateData(T data) => Future.value(false);
  Future<List<T>> getAllData() => Future.value([]);
}

abstract class LocalRepoInterface<T> extends NetworkRepoInterface<T> {
  Future<List<T>> getAllUnSyncData();
}
