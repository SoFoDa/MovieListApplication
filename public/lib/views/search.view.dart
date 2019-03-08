import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:public/util/network_utility.dart';
import 'package:public/services/authentication.dart';
import '../widgets/search_card.dart';

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
          print(movies['data']);
      }) :_movies
    });
  }

  @override
  Widget build(BuildContext context) {    
    return new Scaffold(           
      appBar: AppBar(
        title: RichText(
          text: TextSpan(
            style: TextStyle(
              color: Colors.white,                    
              fontSize: 16,   
            ),
            children: <TextSpan>[
              TextSpan(
                text: "results for "                
              ),
              TextSpan(
                text: widget.search,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                )
              )
            ],
          ), 
        ),  
        elevation: 0,        
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
          ),
        ),             
        child: Column(          
          children: <Widget>[
            Container(
              margin: EdgeInsets.symmetric(vertical: 10),
              child: Text(     
                // Format search result amount text
                (_movies.contains(null) ? '0 search results' : _movies.length.toString() + 
                (_movies.length > 1 ? ' search results' : ' search result')), 
                style: TextStyle(fontSize: 10, color: Colors.white),             
              ),
            ),          
            Expanded(
              child: ListView.builder(          
                itemCount: _movies.length,          
                itemBuilder: (context, index) {
                  final movie = _movies[index];                  
                  if (movie != null) {
                    return ListTile(                                      
                      subtitle: SearchCard(movie['title'], movie['release_year'], movie['genres'], movie['directors'], movie['runtime'])     
                    );
                  }
                },
              ),
            ),
          ],
        ),          
      ),
    );
  }
}