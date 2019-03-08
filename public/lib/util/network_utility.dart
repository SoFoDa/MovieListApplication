import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

class NetworkUtility {
  // make the class singleton, i.e. only create one object and reuse.
  static final NetworkUtility _netUtil = new NetworkUtility._internal();
  factory NetworkUtility() {
    return _netUtil;
  }
  NetworkUtility._internal();

  final JsonDecoder _decoder = new JsonDecoder();

  /// Makes a get request to url.
  /// 
  /// Returns json decoded result.
  Future<dynamic> get(dynamic url, {Map header}) async {
    return http.get(url, headers: header).then((response) {
      final String res = response.body;
      final int statusCode = response.statusCode;

      if (statusCode < 200 || statusCode > 400 || json == null) {
        throw new Exception("Get request failed.");
      }
      return _decoder.convert(res);
    });
  }

  /// Makes a post request to url.
  /// 
  /// Returns json decoded result.
  Future<dynamic> post(dynamic url, {Map header, body}) async {
    return http.post(url, body: body, headers: header).then((response) {
      final String res = response.body;
      final int statusCode = response.statusCode;

      if (statusCode < 200 || statusCode > 400 || json == null) {
        throw new Exception("Post request failed.");
      }
      return _decoder.convert(res);
    });
  }

  /// Makes a put request to url.
  /// 
  /// Returns json decoded result.
  Future<dynamic> put(dynamic url, {Map header, body}) async {
    return http.put(url, body: body, headers: header).then((response) {
      final String res = response.body;
      final int statusCode = response.statusCode;

      if (statusCode < 200 || statusCode > 400 || json == null) {
        throw new Exception("Put request failed.");
      }
      return _decoder.convert(res);
    });
  }
}