import 'dart:async';

import 'package:public/util/network_utility.dart';
import 'package:public/models/user.dart';

class Authentication {
  String url = 'localhost';
  NetworkUtility _netUtil = new NetworkUtility();

  Future<User> login(String username, String password) {
    return _netUtil.post(url, {username: username, password: password}).then((response) {
      if (response['status'] == 'error') {
        throw new Exception("User login failed.");
      } 
      return new User(response['auth'], response['user_id'], response['username'], response['name']); 
    });
  }
}