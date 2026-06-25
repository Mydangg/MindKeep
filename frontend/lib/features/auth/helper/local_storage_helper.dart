import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:frontend/data/model/user.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocalStorageHelper {
  static const _tokenKey = 'token';
  static const _keyUser = 'currentUser';

  static Future<void> saveUser(PsychUser user) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_keyUser, jsonEncode(user.toJson()));
      if(user.token != null){
        await prefs.setString(_tokenKey, user.token?? '');
      }else{
        throw Exception('Token không tồn tại');
      }
    } on MissingPluginException {
      throw Exception('Lưu user thất bại: Plugin không được đăng ký');
    } on PlatformException catch (e) {
      throw Exception('Lưu user thất bại: ${e.message}');
    }
  }

  static Future<PsychUser?> getUser() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final data = prefs.getString(_keyUser);
      if (data != null) {
        return PsychUser.fromJson(jsonDecode(data));
      }
      return null;
    } on MissingPluginException {
      throw Exception('Lấy user thất bại: Plugin không được đăng ký');
    } on PlatformException catch (e) {
      throw Exception('Lấy user thất bại: ${e.message}');
    }
  }

  static Future<void> clearUser() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_keyUser);
      await prefs.remove(_tokenKey);
    } on MissingPluginException {
      throw Exception('Xoá user thất bại: Plugin không được đăng ký');
    } on PlatformException catch (e) {
      throw Exception('Xoá user thất bại: ${e.message}');
    }
  }
}
