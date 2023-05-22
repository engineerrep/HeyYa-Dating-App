import 'dart:convert';

import 'package:flutter_keychain/flutter_keychain.dart';
import 'package:get_storage/get_storage.dart';
import 'package:heyya/app/data/model/account_entity.dart';
import 'package:heyya/app/data/model/relation_num_entity.dart';

import '../../model/user_entity.dart';
import 'package:uuid/uuid.dart';
// import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class HeyStorage {
  static GetStorage _instance = GetStorage();

  String _getString(String key, {String defaultValue = ""}) {
    return _instance.read(key) ?? defaultValue;
  }

  Future<void> _setString(String key, String value) async {
    await _instance.write(key, value);
    return;
  }

  Future<void> setString(String key, String value) async {
    await _instance.write(key, value);
    return;
  }

  String getString(String key, {String defaultValue = ""}) {
    return _instance.read(key) ?? defaultValue;
  }

  /// keys
  static const keyToken = "token";
  static const keyUser = "user";
  static const keyAccount = "account";
  static const keySig = "sig";
  static const keyRelation = "relationNum";

  static const keyUuid = 'Uuid';

  ///common
  void remove(String key) {
    _instance.remove(key);
  }

  void clear() {
    _instance.erase();
  }

  ///UUID
  Future<String> getUuid() async {
    var id = _getString(keyUuid);
    if (id.isEmpty) {
      id = await FlutterKeychain.get(key: keyUuid) ?? '';
      if (id.isNotEmpty) {
        await _setString(keyUuid, id);
      }
    }
    if (id.isEmpty) {
      id = Uuid().v4();
      await _setString(keyUuid, id);
      await FlutterKeychain.put(key: keyUuid, value: id);
    }
    return id;
  }

  ///token
  String getToken() {
    return _getString(keyToken);
  }

  Future<void> saveToken(String token) async {
    return _setString(keyToken, token);
  }

  ///sig
  String getSig() {
    return _getString(keySig);
  }

  Future<void> saveSig(String sig) async {
    return _setString(keySig, sig);
  }

  ///user
  Future<void> saveAccount(AccountEntity account) async {
    return _setString(keyAccount, account.toString());
  }

  AccountEntity? getAccount() {
    String jsonString = _getString(keyAccount);
    if (jsonString.isEmpty) {
      return null;
    }
    Map<String, dynamic> json = jsonDecode(jsonString);
    return AccountEntity.fromJson(json);
  }

  ///user
  Future<void> saveUser(UserEntity user) async {
    return _setString(keyUser, user.toString());
  }

  UserEntity? getUser() {
    String jsonString = _getString(keyUser);
    if (jsonString.isEmpty) {
      return null;
    }
    Map<String, dynamic> json = jsonDecode(jsonString);
    return UserEntity.fromJson(json);
  }

  ///relation
  Future<void> saveRelation(RelationNumEntity relation) async {
    return _setString(keyRelation, relation.toString());
  }

  RelationNumEntity? getRelation() {
    String jsonString = _getString(keyRelation);
    if (jsonString.isEmpty) {
      return null;
    }
    Map<String, dynamic> json = jsonDecode(jsonString);
    return RelationNumEntity.fromJson(json);
  }
}
