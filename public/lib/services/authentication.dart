import 'dart:async';

import 'package:public/util/network_utility.dart';
import 'package:device_info/device_info.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:io';

// the storage key for the token
const String _storageKeyMobileToken = "token";
const String _storageKeyMobileUID = "uid";

// the mobile device unique identity
String _deviceIdentity = '';

class Authentication {
  // make the class singleton, i.e. only create one object and reuse.
  static final Authentication _auth = new Authentication._internal();
  factory Authentication() {
    return _auth;
  }
  Authentication._internal();

  /// storage
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

  Future<String> _getMobileValue(String key) async {
    final SharedPreferences prefs = await _prefs;
    return prefs.getString(key) ?? '';
  }

  Future<bool> _setMobileValue(String key, String token) async {
    final SharedPreferences prefs = await _prefs;
    return prefs.setString(key, token);
  }
  // ===

  String url = 'http://localhost:8989/api';
  int userID = -1;
  String token = "";
  NetworkUtility _netUtil = new NetworkUtility();

  ///
  /// Log user in with username and password.
  /// Returns user_id of the logged in  user if successful.
  /// Returns null if invalid login.
  ///
  Future<int> login(String username, String password) async {
    print('Logging in...');
    return _getDeviceIdentity().then((deviceId) {
      Map<String, String> header = {'device_id': deviceId};
      Map<String, String> body = {'username': username, 'password': password};
      return _netUtil.post(url + '/authorize', header: header, body: body).then((response) {
        if (response['status'] == '200') {
          _setMobileValue(_storageKeyMobileToken, response['token']);
          _setMobileValue(_storageKeyMobileUID, response['user_id'].toString());
          token = response['token'];
          userID = response['user_id'];
          return userID;
        } else {
          print('invalid username pass');
          return null;
        }
      });
    });
  }

  bool logout() {
    print('Logging out...');
    // reset local and stored user data
    token = "";
    userID = -1;
    _setMobileValue(_storageKeyMobileToken, '');
    _setMobileValue(_storageKeyMobileUID, '');
    return true;
  }

  ///
  /// Register a user with username and password.
  /// Returns user_id of the logged in user if successful. 
  /// Returns null if username taken.
  ///
  Future<int> register(String username, String password) async {
    print('Register: ' + username);
    return _netUtil.put(url + '/register', body: {'username': username, 'password': password}).then((response) {
      if (response['status'] == '200') {
        print('Registration success');
        return login(username, password);
      } else {
        print('Registration error');
        return null;
      }
    });
  }

  ///
  /// Register a user with username and password.
  /// Returns user_id of the logged in user if successful. 
  /// Returns null if username taken.
  ///
  Future<bool> handShake() async {
    print('in handshake');
    String deviceId = await _getDeviceIdentity();
    String storedToken = await _getMobileValue(_storageKeyMobileToken);
    String userId = await _getMobileValue(_storageKeyMobileUID);
    Map<String, String> header = {'device_id': deviceId, 'authorization': 'Bearer ' + storedToken};
    Map<String, String> body = {'user_id': userId};
    return _netUtil.post(url + '/handshake', header: header, body: body).then((response) {
      return response['status'] == '200';
    });
  }
}