import 'package:flutter/material.dart';
import 'package:public/util/network_utility.dart';
import 'package:public/services/authentication.dart';
import 'package:public/config.dart';
import 'dart:ui';
import 'dart:convert';

class MoviePage extends StatefulWidget {
  final String movieId;

  MoviePage({Key key, @required this.movieId}) : super(key: key);

  @override
  State<StatefulWidget> createState() => new Movie();
}

class Movie extends State<MoviePage> {
  NetworkUtility _netUtil = new NetworkUtility();
  Authentication _auth = new Authentication();    
  dynamic _movie;
  String _genres = "";
  String _directors = "";
  int runtime = 0;
  int _hours = 0;
  int _minutes = 0;  
  bool _isSeen = false;
  dynamic _seenFollowers;

  final double _TOP_MARGIN = 150;

  @override
  void initState() {
    super.initState();
    var params = { 'movie_id': widget.movieId,};

    var url = Uri.http(serverProperties['HOST'] + serverProperties['PORT'], serverProperties['API_ENDPOINT'] + '/getMovieFromId', params);
    _netUtil.get(url).then((movie) => {
      this.setState(() {
          _movie = movie['data'];                    
          
          // Get runtime values
          int runtime = _movie["runtime"];
          while(runtime != null && runtime > 60){
            runtime -= 60;
            _hours++;
          }
          _minutes = runtime;           
      }) :_movie
    });      

    // Get first three genres
    var url2 = Uri.http(serverProperties['HOST'] + serverProperties['PORT'], serverProperties['API_ENDPOINT'] + '/getMovieGenres', params);
    _netUtil.get(url2).then((genres) => {
      this.setState(() {          
          dynamic genreList = genres['data'][0];                                  
          _genres += genreList["0"]["genre_type"]; 
          int len = 3; 
          if(genreList.length < len) {len = genreList.length;}        
          for(int i = 1; i < len; i++) { 
            _genres += " / " + genreList[i.toString()]["genre_type"];
          }                           
      }) :_genres
    });  
    
    // Get directors
    var url3 = Uri.http(serverProperties['HOST'] + serverProperties['PORT'], serverProperties['API_ENDPOINT'] + '/getMovieDirectors', params);
    _netUtil.get(url3).then((dirs) => {
      this.setState(() {          
          dynamic dirList = dirs['data'][0];              
          _directors += dirList["0"]["name"];          
          for(int i = 1; i < dirList.length; i++) { 
            _directors += " / " + dirList[i.toString()]["name"];
          }                    
      }) :_directors
    });  

    // Check if seen    
    var params2 = {'user_id': _auth.userID.toString(), 'movie_id': widget.movieId,};
    var url4 = Uri.http(serverProperties['HOST'] + serverProperties['PORT'], serverProperties['API_ENDPOINT'] + '/isSeen', params2);
    _netUtil.get(url4).then((seen) => {
      this.setState(() {               
          if(seen['data']["is_seen"] == 1) {_isSeen = true;}                                           
      }) :_isSeen
    });  

    // Get friends who have seen the movie        
    var url5 = Uri.http(serverProperties['HOST'] + serverProperties['PORT'], serverProperties['API_ENDPOINT'] + '/getSeenFollowed', params2);
    _netUtil.get(url5).then((seen) => {
      this.setState(() {                         
          _seenFollowers = seen["data"];          
      }) :_seenFollowers
    });  
  }
  

  // Set movie as seen
  void makeSeen() {  
    var header = <String, String>{
      'authorization' : _auth.token,
      'device_id' : _auth.deviceIdLocal,      
    };

    var body = <String, String>{
      'user_id' : _auth.userID.toString(),
      'movie_id' : widget.movieId,
      'seen_status' : true.toString()
    };

    var url = Uri.http(serverProperties['HOST'] + serverProperties['PORT'], serverProperties['API_ENDPOINT'] + '/setSeen');
    _netUtil.post(
      url, 
      header: header,
      body: body,
    ).then((res) => {});
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
            maxLines: 3,
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
          child: Stack(
            children: <Widget>[  
              Positioned(   
                top: -50,                             
                child: Container(
                  height: _TOP_MARGIN + 138,
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
                      color: Colors.white.withAlpha(0),
                    ),
                  ),                                    
                ),        
              ),  
              Positioned(
                top: _TOP_MARGIN,
                left: 25,
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
                top: _TOP_MARGIN + 1,
                left: 155,
                child: Container(
                  alignment: Alignment(-1, 1),                                    
                  height: 80,
                  width: 205,
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
                top: _TOP_MARGIN + 139,
                left: 155,
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
                top: _TOP_MARGIN + 161,
                left: 155,
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
              Positioned(
                top: _TOP_MARGIN + 95,
                left: 155,
                child: Row(
                  children: <Widget>[
                    Icon(
                      Icons.theaters, 
                      color: Colors.white,
                      size: 13,
                    ),
                    Text(                      
                      " " + _genres,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 13,
                      )
                    ),
                  ],
                ),
              ),    
              Positioned(
                top: _TOP_MARGIN + 117,
                left: 155,
                child: Row(
                  children: <Widget>[
                    Icon(
                      Icons.movie_creation, 
                      color: Colors.white,
                      size: 13,
                    ),
                    Text(                      
                      " " + _directors,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 13,
                      )
                    ),
                  ],
                ),
              ),              
              Positioned(   
                top: _TOP_MARGIN + 135,
                right: 20,
                child: Container(                  
                  child: SizedBox(
                    width: 70,
                    child: RaisedButton(  
                      color: (_isSeen ? Colors.redAccent : Colors.blue),                                                        
                      child: Text("Seen", style: TextStyle(color: Colors.white),),
                      onPressed: () {                                                      
                        makeSeen();
                        setState(() => _isSeen = true);  
                      },
                    ),
                  ),
                ),                             
              ),
              Positioned(
                top: _TOP_MARGIN + 190,
                left: 25,
                child: Container(
                  width: MediaQuery.of(context).size.width - 35, 
                  child: RichText(
                    text: TextSpan(
                      children: <TextSpan> [
                        TextSpan(
                          text: "Plot\n",
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.white,                          
                          ),
                        ),
                        TextSpan(
                          text: "This is placeholder text for future...",
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.white70,  
                            fontStyle: FontStyle.italic,                        
                          ),
                        )
                      ],                    
                    ),
                  ),                
                ),                
              ),
              Positioned(
                top: _TOP_MARGIN + 285,
                child: Container(                  
                  height: 40,
                  width: MediaQuery.of(context).size.width,  
                  decoration: BoxDecoration( 
                    border: Border(top: BorderSide(color: Colors.grey), bottom: BorderSide(color: Colors.grey)),                   
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,            
                      stops: [0.0, 0.2, 0.5, 0.8, 1.0],
                      colors: [                        
                        Color(0x22FFFFFF),
                        Color(0x00FFFFFF),
                        Color(0x00FFFFFF),
                        Color(0x00FFFFFF),
                        Color(0x22FFFFFF),
                      ]
                    )
                  ),
                  child: Center(
                    child: Text(
                      _seenFollowers.length.toString() + " "
                      + (_seenFollowers.length == 1 ? "friend" : "friends")
                      + " have seen this movie",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                      ),
                    ),
                  ),
                ),
              ),
              Positioned(
                top: _TOP_MARGIN + 325,
                child: Container(
                  width: MediaQuery.of(context).size.width,  
                  height: 500,            
                  child: ListView.separated(
                    separatorBuilder: (context, index) => Divider(
                      color: Colors.white,                
                    ),
                    itemCount: _seenFollowers.length,          
                    itemBuilder: (context, index) {                                                                       
                      return ListTile(                                                          
                        dense: true,                     
                        title: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              _seenFollowers[index.toString()]["username"],
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold
                              ),
                            ),  
                            Text(                              
                              _seenFollowers[index.toString()]["date"],
                              textAlign: TextAlign.right,
                              style: TextStyle(
                                color: Colors.white70,
                              ),
                            ),      
                          ]
                        )                          
                      );                    
                    }
                  )
                ),             
              ),                                     
            ],            
          ),
        ),
      );
    } else {
      return new Scaffold(
        body: Center(
          child: Text('No movie found'),
        ),
      );
    }
  }
}