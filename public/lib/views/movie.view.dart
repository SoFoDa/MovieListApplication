import 'package:flutter/material.dart';
import 'package:public/util/network_utility.dart';
import 'package:public/config.dart';
import 'dart:ui';

class MoviePage extends StatefulWidget {
  final String movieId;

  MoviePage({Key key, @required this.movieId}) : super(key: key);

  @override
  State<StatefulWidget> createState() => new Movie();
}

class Movie extends State<MoviePage> {
  NetworkUtility _netUtil = new NetworkUtility();
  dynamic _movie;
  int runtime = 0;
  int _hours = 0;
  int _minutes = 0;

  @override
  void initState() {
    super.initState();
    var params = { 'movie_id': widget.movieId,};
    var url = Uri.http(serverProperties['HOST'] + serverProperties['PORT'], serverProperties['API_ENDPOINT'] + '/getMovieFromId', params);
    _netUtil.get(url).then((movie) => {
      this.setState(() {
          _movie = movie['data'];          
          print(_movie);
          
          // Get runtime values
          int runtime = _movie["runtime"];
          while(runtime != null && runtime > 60){
            runtime -= 60;
            _hours++;
          }
          _minutes = runtime;           
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
          bottomOpacity: 0,          
          title: Text(            
            _movie['title'],
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              wordSpacing: 3,
            ),
          ),                    
        ),
        body: new Container( 
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,            
              stops: [0.1, 0.7, 0.9],
              colors: [              
                Color(0xFF245ADC),
                Color(0xFF594CD2),
                Color(0xFF913AC5),              
              ],
              tileMode: TileMode.clamp,
            ),
          ),                             
          child:Stack(
            children: <Widget>[  
              Positioned(   
                top: -50,                             
                child: Container(
                  height: 300,
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(  
                    boxShadow: [BoxShadow(
                      color: Color(0xAA000000),
                      offset: Offset(0, 0),
                      blurRadius: 10,
                      spreadRadius: 0,
                    )],                                       
                    image: DecorationImage(
                      image: NetworkImage('http://' + serverProperties['HOST'] + serverProperties['PORT'] + '/posters/' + _movie['poster_path']),
                      fit: BoxFit.fitWidth,                    
                    )
                  ),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 3.0, sigmaY: 3.0),
                    child: Container(
                      color: Colors.white.withAlpha(50),
                    ),
                  ),                                    
                ),        
              ),  
              Positioned(
                top: 150,
                left: 30,
                child: Container(                     
                  height: 180,
                  width: 120,
                  decoration: BoxDecoration(  
                    border: Border.all(color: Colors.white),
                    boxShadow: [BoxShadow(
                      color: Color(0xAA000000),
                      offset: Offset(0, 0),
                      blurRadius: 10,
                      spreadRadius: 0,
                    )],                                       
                    image: DecorationImage(
                      image: NetworkImage('http://' + serverProperties['HOST'] + serverProperties['PORT'] + '/posters/' + _movie['poster_path']),
                      fit: BoxFit.fitWidth,                    
                    )
                  ),                  
                )                
              ),
              Positioned(
                top: 166,
                left: 160,
                child: Container(
                  alignment: Alignment(-1, 1),                                    
                  height: 80,
                  width: 200,
                  //color: Colors.redAccent,
                  child: Text(
                    _movie['title'],
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      shadows: <Shadow> [
                        Shadow( // bottomLeft
                          offset: Offset(1.5, 1.5),
                          color: Colors.black,
                          blurRadius: 10,
                        ),       
                      ],
                    ),
                  ),   
                )                                                               
              ),
              Positioned(
                top: 258,
                left: 161,
                child: Row(
                  children: <Widget>[
                    Icon(
                      Icons.calendar_today, 
                      color: Colors.white,
                      size: 13,
                    ),
                    Text(
                      " " + _movie["release_year"].toString(), 
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 13,
                      )
                    ),                 
                  ],
                ),               
              ), 
              Positioned(
                top: 280,
                left: 161,
                child: Row(
                  children: <Widget>[
                    Icon(
                      Icons.timer, 
                      color: Colors.white,
                      size: 13,
                    ),
                    Text(
                      " " + _hours.toString() + "h " + _minutes.toString() + "m", 
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 13,
                      )
                    ),
                  ],
                ),
              ),              
            ],            
          )
        ),
      );
    } else {
      return new Scaffold();
    }
  }
}