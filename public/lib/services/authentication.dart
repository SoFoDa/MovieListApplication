import 'dart:async';

import 'package:public/util/network_utility.dart';
import 'package:device_info/device_info.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'dart:io';
import 'package:public/config.dart';

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

  final _storage = new FlutterSecureStorage();

  Future<String> _getStorageValue(String key) async {
    return await _storage.read(key: key);
  }

  Future<bool> _setStorageValue(String key, String value) async {
    await _storage.write(key: key, value: value);
    return true;
  }
  // ===

  int userID = -1;
  String token = "";
  String deviceIdLocal = "";
  NetworkUtility _netUtil = new NetworkUtility();

  ///
  /// Log user in with username and password.
  /// Returns user_id of the logged in  user if successful.
  /// Returns null if invalid login.
  ///
  Future<int> login(String username, String password) async {
    print('Logging in...');
    return _getDeviceIdentity().then((deviceId) {
      var url = Uri.http(serverProperties['HOST'] + serverProperties['PORT'], serverProperties['API_ENDPOINT'] + '/authorize');
      deviceIdLocal = deviceId;
      Map<String, String> header = {'device_id': deviceId};
      Map<String, String> body = {'username': username, 'password': password};
      return _netUtil.post(url, header: header, body: body).then((response) {
        if (response['status'] == '200') {
          _setStorageValue(_storageKeyMobileToken, response['token']);
          _setStorageValue(_storageKeyMobileUID, response['user_id'].toString());
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
    _setStorageValue(_storageKeyMobileToken, '');
    _setStorageValue(_storageKeyMobileUID, '');
    return true;
  }

  ///
  /// Register a user with username and password.
  /// Returns user_id of the logged in user if successful. 
  /// Returns null if username taken.
  ///
  Future<int> register(String username, String password, String fullName) async {
    print('Register: ' + username);
    var url = Uri.http(serverProperties['HOST'] + serverProperties['PORT'], serverProperties['API_ENDPOINT'] + '/register');
    return _netUtil.put(url, body: {'username': username, 'password': password, 'full_name': fullName}).then((response) {
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
    String deviceId = await _getDeviceIdentity();
    String storedToken = await _getStorageValue(_storageKeyMobileToken);
    String userId = await _getStorageValue(_storageKeyMobileUID);
    Map<String, String> header = {'device_id': deviceId, 'authorization': 'Bearer ' + storedToken.toString(), 'user_id': userId};
    
    var url = Uri.http(serverProperties['HOST'] + serverProperties['PORT'], serverProperties['API_ENDPOINT'] + '/handshake');
    return _netUtil.post(url, header: header).then((response) {
      if (response['status'] == '200') {
        userID = int.parse(userId);
        token = storedToken;
        deviceIdLocal = deviceId;
        return true;
      }
      return false;
    });
  }
}