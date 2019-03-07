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
  List<dynamic> _movies = []; 

  @override
  void initState() {
    super.initState();
    var params = {
      'title': widget.search,
    };
    var uri = Uri.http('localhost:8989', '/api/searchMovie', params).toString();
    _netUtil.get(uri).then((movies) => {
      this.setState(() {
          _movies = movies['data'];
      }) :_movies
    });
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: new Container(
        child:
          ListView.builder(
          // Let the ListView know how many items it needs to build
          itemCount: _movies.length,
          // Provide a builder function. This is where the magic happens! We'll
          // convert each item into a Widget based on the type of item it is.
          itemBuilder: (context, index) {
            final movie = _movies[index];
            if (movie != null) {
              return ListTile(
                title: Text(
                  movie['title'],
                  style: Theme.of(context).textTheme.headline,
                ),
              );
            } else {
              return ListTile(
                title: Text(
                  "No movies found, please try another search!",
                  style: Theme.of(context).textTheme.headline,
                ),
              );
            }
          },
        )
      ),
    );
  }
}