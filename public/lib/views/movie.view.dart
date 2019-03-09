import 'package:flutter/material.dart';
import 'package:public/util/network_utility.dart';
import 'package:public/config.dart';

class MoviePage extends StatefulWidget {
  final String movieId;

  MoviePage({Key key, @required this.movieId}) : super(key: key);

  @override
  State<StatefulWidget> createState() => new Movie();
}

class Movie extends State<MoviePage> {
  NetworkUtility _netUtil = new NetworkUtility();
  dynamic _movie;

  @override
  void initState() {
    super.initState();
    var params = { 'movie_id': widget.movieId,};
    var url = Uri.http(serverProperties['HOST'] + serverProperties['PORT'], serverProperties['API_ENDPOINT'] + '/getMovieFromId', params);
    _netUtil.get(url).then((movie) => {
      this.setState(() {
          _movie = movie['data'];
      }) :_movie
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_movie != null) {
      if (_movie['poster_path'] == '') {
      _movie['poster_path'] = 'noposter.jpg';
      }
      return new Scaffold(
        appBar: AppBar(
          
        ),
        body: new Container(
          child:Stack(
            children: <Widget>[
              Center(
                child: Container(
                  alignment: Alignment.center,
                  decoration: BoxDecoration(  
                  border: Border.all(color: Colors.white),                  
                  image: new DecorationImage(
                    image: new NetworkImage('http://' + serverProperties['HOST'] + serverProperties['PORT'] + '/posters/' + _movie['poster_path']),
                    fit: BoxFit.cover
                  ),                                    
                ),     
                )
              )
            ],
          )
        ),
      );
    } else {
      return new Scaffold();
    }
  }
}