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
  Future<dynamic> get(String url) {
    return http.get(url).then((response) {
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
  Future<dynamic> post(String url, Map body) {
    return http.post(url, body: body).then((response) {
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
  Future<dynamic> put(String url, Map body) {
    return http.put(url, body: body).then((response) {
      final String res = response.body;
      final int statusCode = response.statusCode;

      if (statusCode < 200 || statusCode > 400 || json == null) {
        throw new Exception("Put request failed.");
      }
      return _decoder.convert(res);
    });
  }
}