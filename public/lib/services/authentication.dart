import 'dart:async';

import 'package:public/util/network_utility.dart';
import 'package:device_info/device_info.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:io';

// the storage key for the token
const String _storageKeyMobileToken = "token";

// the mobile device unique identity
String _deviceIdentity = "dev_id";

class Authentication {
  /// === METHODS MODIFIED FROM https://www.didierboelens.com/2018/05/token-based-communication-with-server---part-1/ 
  final DeviceInfoPlugin _deviceInfoPlugin = new DeviceInfoPlugin();

  Future<String> _getDeviceIdentity() async {
    if (_deviceIdentity == '') {
      if (Platform.isAndroid) {
        AndroidDeviceInfo info = await _deviceInfoPlugin.androidInfo;
        _deviceIdentity = "${info.device}-${info.id}";
      } else if (Platform.isIOS) {
        IosDeviceInfo info = await _deviceInfoPlugin.iosInfo;
        _deviceIdentity = "${info.model}-${info.identifierForVendor}";
      }
    }

    return _deviceIdentity;
  }
  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  Future<String> _getMobileToken() async {
    final SharedPreferences prefs = await _prefs;
    return prefs.getString(_storageKeyMobileToken) ?? '';
  }

  Future<bool> _setMobileToken(String token) async {
    final SharedPreferences prefs = await _prefs;
    return prefs.setString(_storageKeyMobileToken, token);
  }
  // ===

  String url = 'http://127.0.0.1:8989/api';
  int userID = 0;
  String token = "";
  NetworkUtility _netUtil = new NetworkUtility();

  ///
  /// Log user in with username and password.
  /// Returns user_id of the logged in  user if successful.
  /// Returns null if invalid login.
  ///
  Future<int> login(String username, String password) async {
    Map<String, String> header = {'device_id':_deviceIdentity};
    Map<String, String> body = {'username': username, 'password': password};
    return _netUtil.post(url + '/authorize', header: header, body: body).then((response) {
      if (response['status'] == '200') {
        _setMobileToken(response['token']);
        token = response['token'];
        userID = response['user_id'];
        return userID;
      } else {
        print('invalid username pass');
        return null;
      }
    });
  }

  ///
  /// Register a user with username and password.
  /// Returns user_id of the logged in user if successful. 
  /// Returns null if username taken.
  ///
  Future<int> register(String username, String password) async {
    return _netUtil.put(url + '/register', body: {'username': username, 'password': password}).then((response) {
      if (response['status'] == '200') {
        return login(username, password);
      }
      return null;
    });
  }
}