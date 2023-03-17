import 'package:flutter_secure_storage/flutter_secure_storage.dart';

late final _SecureStorageHelper secureStorageHelper = _createSecureStorageHelper();

_SecureStorageHelper _createSecureStorageHelper(){
  return _SecureStorageHelper();
}

class _SecureStorageHelper extends FlutterSecureStorage {

  void save(String key, var data) async{
    await write(key: key, value: data.toString());
  }

  Future<dynamic> readByKey(String key) async{
    final data = await read(key: key);
    return data;
  }

  Future<void> deleteByKey(String key) async{
    await delete(key: key);
  }
}