import 'package:flutter/material.dart';
import 'package:public/util/network_utility.dart';
import 'package:public/services/authentication.dart';
import 'package:public/config.dart';
import '../widgets/base_card.dart';
import '../widgets/seen_card.dart';
import 'package:public/views/movie.view.dart';

class Profile extends StatefulWidget {  
  @override
  _ProfileState createState() => _ProfileState();  
}

class _ProfileState extends State<Profile> with SingleTickerProviderStateMixin {
  String username = "";
  String name = ""; 
  String joinDate = "";     
  int followers = 0;  
  List<dynamic> _userInfo = []; 
  Map<String, dynamic> _seenMovies = {};
  int seenLen = 0;

  NetworkUtility _netUtil = new NetworkUtility();
  Authentication _auth = new Authentication();    
  
  @override
  void initState(){      
    super.initState();    

    // Request parameters    
    var params = { 'user_id': _auth.userID.toString()};

    // Get user information
    var url = Uri.http(serverProperties['HOST'] + serverProperties['PORT'], serverProperties['API_ENDPOINT'] + '/getUserInfo', params);      
    print(url);    
      _netUtil.get(url).then((res) {
        if (this.mounted) {  
          setState(() {  
            username = res['data']['username'];
            name = res['data']['name'];
            joinDate = res['data']['join_date'].toString();          
          });
        }
      });    

    // Get follower amount 
    var url2 = Uri.http(serverProperties['HOST'] + serverProperties['PORT'], serverProperties['API_ENDPOINT'] + '/getFollowerAmount', params);      
    print(url2);    
    _netUtil.get(url2).then((res) {
      if (this.mounted) {  
        this.setState(() {                           
          followers = res['data']['follower_amount'];                    
        });
      }
    });
  

    // Get seen movies
    var url3 = Uri.http(serverProperties['HOST'] + serverProperties['PORT'], serverProperties['API_ENDPOINT'] + '/seenMovies', params);                
    print(url3);      
    _netUtil.get(url3).then((res) {      
      if (this.mounted) {
        this.setState(() {               
          _seenMovies = res['data'];            
          seenLen = _seenMovies.length;
        });
      } 
    });  
  }  

  @override
  void dispose(){               
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {    
    return Container(
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
          Stack(        
            children: <Widget>[
              Positioned(   
                child: Center(
                  child: BaseCard(MediaQuery.of(context).size.width - 40, 170, EdgeInsets.only(top: 100)),                                                     
                )                                                                        
              ),
              //
              Positioned(            
                child: Center(
                  child: Container(
                    margin: EdgeInsets.only(top: 35),                  
                    height: 130,
                    width: 130,
                    decoration: BoxDecoration(
                      color: Colors.redAccent,
                      borderRadius: BorderRadius.circular(100),
                      border: Border.all(color: Colors.white),
                      image: DecorationImage(                        
                        image: AssetImage('assets/sicarioPoster.jpg'),
                        fit: BoxFit.cover,
                      ),        
                    ),
                  ),
                ),
              ), 
              // Username
              Positioned(                
                child: Container(
                  margin:EdgeInsets.only(top: 170),
                  child: Center(
                    child: Column(
                      children: <Widget>[
                        Text(
                          username,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 30,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          name,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 15,
                            fontWeight: FontWeight.normal,
                          ),
                        ),                                                                                                                       
                      ],
                    ),                    
                  ),
                ),

              ),  
              Positioned(                
                left: 170,             
                child: Container(
                  margin: EdgeInsets.only(top: 225),
                  child: Row(
                    children: <Widget>[
                      Icon(Icons.people, color: Colors.white),
                      Text(
                        " " + followers.toString(), 
                        textAlign: TextAlign.center, 
                        style: TextStyle(
                          color: Colors.white
                        ),
                      ),
                    ],      
                  ),        
                ),                      
              ),           
            ],
          ),          
          Container(
            margin: EdgeInsets.only(top: 20),            
            child: RaisedButton(                           
              child: Text('Log out'),
              onPressed: () {
                Authentication _auth = new Authentication();
                _auth.logout();
                Navigator.pushNamedAndRemoveUntil(context, '/', (_) => false);
              }
            ),            
          ),          
          Container(            
            margin: EdgeInsets.only(top: 20),
            child: Text(
              "Seen " + seenLen.toString() + " movies",
              style: TextStyle(
                color: Colors.white,
              )
            ),
          ),
          Expanded(
            child: ListView.separated(    
              separatorBuilder: (context, index) => Divider(
                color: Colors.white,                
              ),
              itemCount: seenLen,          
              itemBuilder: (context, index) {
                final seenMovie = _seenMovies[index.toString()];   
                if(_seenMovies != null){                                    
                  return ListTile(                                      
                    dense: true,                     
                    title: SeenCard(
                      seenMovie['title'], 
                      seenMovie['release_year'],                      
                      seenMovie['runtime'], 
                      seenMovie['poster_path']
                    ),   
                    onTap: () => {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => MoviePage(movieId: seenMovie['movie_id'].toString()),
                        ),
                      ) : context
                    },                                                                
                  );
                }                
              },
            ),
          ),           
        ],
      ),  
    );       
  }
}