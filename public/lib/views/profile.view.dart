import 'package:flutter/material.dart';
import 'package:public/util/network_utility.dart';
import 'package:public/services/authentication.dart';
import 'package:public/config.dart';
import '../widgets/base_card.dart';

class Profile extends StatefulWidget {  
  @override
  _ProfileState createState() => _ProfileState();  
}

class _ProfileState extends State<Profile> with SingleTickerProviderStateMixin {
  String username = "";
  String name = ""; 
  String joinDate = "";     
  int followers = 0;  
  dynamic _userInfo = []; 

  NetworkUtility _netUtil = new NetworkUtility();
  Authentication _auth = new Authentication();    
  
  @override
  void initState(){             
    // Request parameters    
    var params = { 'user_id': _auth.userID.toString()};

    // Get user information
    var url = Uri.http(serverProperties['HOST'] + serverProperties['PORT'], serverProperties['API_ENDPOINT'] + '/getUserInfo', params);      
    print(url);      
    _netUtil.get(url).then((res) => {
      this.setState(() {                    
          username = res['data'][0]['0']['username'];
          name = res['data'][0]['0']['name'];
          joinDate = res['data'][0]['0']['join_date'].toString();
          print(joinDate);
      }) :_userInfo
    });    

    // Get follower amount 
    var url2 = Uri.http(serverProperties['HOST'] + serverProperties['PORT'], serverProperties['API_ENDPOINT'] + '/getFollowerAmount', params);      
    print(url2);      
    _netUtil.get(url2).then((res) => {
      this.setState(() {                            
          followers = res['data'][0]['0']['follower_amount'];                    
      }) :followers
    });            
        
           
    name = "todo";
    //followers = 5;
    super.initState();    
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
        ],
      ),  
    );       
  }
}