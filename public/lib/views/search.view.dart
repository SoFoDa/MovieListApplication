import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:public/util/network_utility.dart';
import 'package:public/services/authentication.dart';

class SearchPage extends StatefulWidget {
  final String search;
  SearchPage({Key key, @required this.search}) : super(key: key);

  @override
  State<StatefulWidget> createState() => new Search();
}

class Search extends State<SearchPage> {
  NetworkUtility _netUtil = new NetworkUtility();
  Authentication _auth = new Authentication();

  @override
  void initState() {
    super.initState();
    var params = {
      'title': widget.search,
    };
    var uri = Uri.http('localhost:8989', '/api/searchMovie', params).toString();
    _netUtil.get(uri).then((result) {
      //for (var movie in result['data']) {
        //print(movie);
      //}
    });
    // TODO: implement build
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold();
  }
}