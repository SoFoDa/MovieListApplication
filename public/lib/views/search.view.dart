import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:public/util/network_utility.dart';
import 'package:public/services/authentication.dart';
import '../widgets/search_card.dart';
import '../widgets/base_card.dart';
import 'package:public/config.dart';
import 'package:public/views/movie.view.dart';
import 'package:public/views/profile.view.dart';

class SearchPage extends StatefulWidget {
  final String search;
  SearchPage({Key key, @required this.search}) : super(key: key);

  @override
  State<StatefulWidget> createState() => new Search();
}

class Search extends State<SearchPage> {
  NetworkUtility _netUtil = new NetworkUtility();  
  Authentication _auth = new Authentication();
  List<dynamic> _listItems = [];
  List<dynamic> _movies = []; 
  List<dynamic> _users = [];
  int movieLen = 0;
  int userLen = 0;

  @override
  void initState() {
    super.initState();
    // Get movie search results
    var params = {      
      'title': widget.search,
    };
    var url = Uri.http(serverProperties['HOST'] + serverProperties['PORT'], serverProperties['API_ENDPOINT'] + '/searchMovie', params);
    _netUtil.get(url).then((movies) {
      this.setState(() {
        _movies = movies['data'];
        print("result1");           
        print(movies['data']);           
        if(movies['data'] != null) {
          movieLen += _movies.length; 
          _listItems.add(_movies);    
          print("list1");    
          print(_listItems);          
          _listItems = _listItems.expand((x) => x).toList();    
          print("list2");    
          print(_listItems);
        }  

        // Get user search results
        params = {           
          'username': widget.search,
          'own_user_id': _auth.userID.toString(),
        };
        url = Uri.http(serverProperties['HOST'] + serverProperties['PORT'], serverProperties['API_ENDPOINT'] + '/searchUser', params);
        _netUtil.get(url).then((users) {      
          this.setState(() {
            _users = users['data'];
            print("result2");           
            print(users['data']);
            if(users['data'] != null) {              
              userLen += _users.length;  
              _listItems.add(_users[0]);  
              print("list3");    
              print(_listItems);            
              //_listItems = _listItems.expand((x) => x).toList();              
              print("list4");    
              print(_listItems); 
            }                      
          });
        });            
      });
    });    
  }

  @override
  Widget build(BuildContext context) {    
    return new Scaffold(           
      appBar: new AppBar(
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
        leading: IconButton(icon:Icon(Icons.chevron_left),onPressed:() => Navigator.pop(context, true),)       
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
        child: Column(          
          children: <Widget>[
            Container(
              margin: EdgeInsets.symmetric(vertical: 10),
              child: Text(     
                // Format search result amount text
                (_listItems.length == 0 ? '0 search results' : _listItems.length.toString() + 
                (_listItems.length > 1 ? ' search results' : ' search result')), 
                style: TextStyle(fontSize: 10, color: Colors.white),             
              ),
            ),          
            Expanded(              
              child: ListView.builder(                         
                itemCount: movieLen + userLen,          
                itemBuilder: (context, index) {                  
                  final _listItem = _listItems[index];                                                   
                  return ListTile(                                                        
                    subtitle: (index < movieLen ? 
                    SearchCard(_listItem['title'], _listItem['release_year'], _listItem['genres'], _listItem['directors'], _listItem['runtime'], _listItem['poster_path']) :
                    Stack(
                      children: <Widget>[
                        BaseCard(MediaQuery.of(context).size.width, 70, EdgeInsets.zero),
                        Positioned(
                          top: 12,
                          left: 10,
                          child: Text(_listItem["0"]["username"], style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),)
                        ), 
                        Positioned(
                          top: 37,
                          left: 10,
                          child: Text(_listItem["0"]["name"], style: TextStyle(fontSize: 15, color: Colors.white70),)
                        ),                        
                      ],
                    )
                    ),                                            
                    onTap: () => {                      
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => (index < movieLen ? MoviePage(movieId: _listItem['movie_id'].toString()) :
                          Profile(userId: int.parse(_listItem["0"]["user_id"]), myProfile: false)),
                        ),
                      ) : context
                    },
                  );
                
                },
              ),
            ),
          ],
        ),          
      ),
    );
  }
}