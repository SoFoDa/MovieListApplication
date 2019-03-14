import 'package:flutter/material.dart';
import 'package:public/util/network_utility.dart';
import 'package:public/services/authentication.dart';
import 'package:public/config.dart';
import '../widgets/base_card.dart';
import '../widgets/seen_card.dart';
import 'package:public/views/movie.view.dart';
import 'package:public/services/websockets.dart';
import 'dart:convert';

class Profile extends StatefulWidget {  
  final int userId;
  final bool myProfile;
  Profile({Key key, @required this.userId, @required this.myProfile}) : super(key: key);

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
  bool _isFollower = false;

  NetworkUtility _netUtil = new NetworkUtility();
  Authentication _auth = new Authentication();  
  Websocket _ws = new Websocket();

  void updateInformation() {
    // Request parameters    
    var params = { 'user_id': widget.userId.toString()};
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

    // not on our own profile
    if(widget.userId != _auth.userID) {
      print('Not the users profile!');
      var header = <String, String>{
        'authorization' : _auth.token,
        'user_id' : _auth.userID.toString(),
        'device_id' : _auth.deviceIdLocal,      
      };
      // get following status
      var body = {'follow_user_id': widget.userId.toString()};
      var url4 = Uri.http(serverProperties['HOST'] + serverProperties['PORT'], serverProperties['API_ENDPOINT'] + '/isFollowing');
      _netUtil.post(url4,  header: header, body: body).then((seen) {
        this.setState(() {            
          _isFollower = seen['data']["is_follower"];                                       
        });
      }); 
    }
  }  

  void getSeenMovies(){
    // Get seen movies
    var url3 = Uri.http(serverProperties['HOST'] + serverProperties['PORT'], serverProperties['API_ENDPOINT'] + '/seenMovies', { 'user_id': widget.userId.toString()});                
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

  void getFollowerAmount() {
    // Get follower amount 
    var url2 = Uri.http(serverProperties['HOST'] + serverProperties['PORT'], serverProperties['API_ENDPOINT'] + '/getFollowerAmount', { 'user_id': widget.userId.toString()});           
    _netUtil.get(url2).then((res) {
      if (this.mounted) {  
        this.setState(() {                           
          followers = res['data']['follower_amount'];                    
        });
      }
    });
  }

  void _webSocketFunction(String message) {
    Map<String, dynamic> response = jsonDecode(message);    
    switch (response['action']) {
      case 'update': 
        getSeenMovies();
        break;
      case 'updateFollow':        
        getFollowerAmount();
        break;
      default:
    }
  }
  
  @override
  void initState(){      
    super.initState();  
    _ws.addListener(_webSocketFunction);   
    updateInformation();
    getFollowerAmount();  
    getSeenMovies();
  }  

  @override
  void dispose(){     
    _ws.removeListener(_webSocketFunction);           
    super.dispose();
  }

  // Set movie as seen
  void followUser(bool status) {  
    var header = <String, String>{
      'authorization' : _auth.token,
      'user_id' : _auth.userID.toString(),
      'device_id' : _auth.deviceIdLocal,      
    };

    var body = <String, String>{
      'follow_user_id' : widget.userId.toString(),
      'status': status.toString(),
    };

    var url = Uri.http(serverProperties['HOST'] + serverProperties['PORT'], serverProperties['API_ENDPOINT'] + '/followUser');
    _netUtil.post(
      url, 
      header: header,
      body: body,
    ).then((res) {
      _ws.send({'action': 'updateFollow', 'user_id': _auth.userID, 'follow_id': widget.userId});
    });
  }

  @override
  Widget build(BuildContext context) {   
    if (widget.myProfile) {
      return profileWidget();
    } else {
      return Scaffold(
        appBar: AppBar(
          title: Text(username),
          leading: IconButton(icon:Icon(Icons.chevron_left),onPressed:() => Navigator.pop(context, true),)
        ),
        body: profileWidget(),
    );  
    }     
  }

  Widget profileWidget() {
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
              color: Colors.blue,                     
              child: (widget.myProfile ? 
                      Text('Log out', style: TextStyle(color: Colors.white)) : 
                      (_isFollower ? Text('Following', style: TextStyle(color: Colors.white)) : Text('Follow', style: TextStyle(color: Colors.white)))),
              onPressed: () {
                if (widget.myProfile) {
                  _auth.logout();
                  Navigator.pushNamedAndRemoveUntil(context, '/', (_) => false);
                } else {
                  print(_isFollower);
                  followUser(!_isFollower);
                  setState(() => _isFollower = !_isFollower);   
                }
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
                      Navigator.of(context).push(
                        new MaterialPageRoute(
                          builder: (_) => MoviePage(movieId: seenMovie['movie_id'].toString()),
                        ),
                      ).then((val) {
                        if(val != null) val ? updateInformation() : null;
                      }) : context
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

