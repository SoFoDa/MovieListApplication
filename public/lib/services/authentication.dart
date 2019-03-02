import 'dart:async';

import 'package:public/util/network_utility.dart';
import 'package:public/models/user.dart';

class Authentication {
  String url = 'http://127.0.0.1:8989/api';
  NetworkUtility _netUtil = new NetworkUtility();

  Future<User> login(String username, String password) {
    return _netUtil.post(url + '/authorize', body: {'username': username, 'password': password}).then((response) {
      if (response['status'] == 'error') {
        throw new Exception("User login failed.");
      } 
      return new User(response['token'], response['user_id'], response['username']); 
    });
  }

  Future<User> register(String username, String password) {
    return _netUtil.put(url + '/register', body: {'username': username, 'password': password}).then((response) {
      if (response['status'] == '200') {
        return new User(response['token'], response['user_id'], response['username']); 
      } else if(response['error'] == 'taken') {
        return null;
      }
    });
  }
}