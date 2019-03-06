import 'package:flutter/material.dart';

class Profile extends StatefulWidget {
  @override
  _ProfileState createState() => _ProfileState();  
}

class _ProfileState extends State<Profile> with SingleTickerProviderStateMixin {
  String username;
  String name;   
  int followers; 

  @override
  void initState(){  
    username = "SoFoDa";    
    name = "David Johansson";
    followers = 5;
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
                  child:Container(                    
                    height: 170,
                    width: MediaQuery.of(context).size.width - 40,
                    margin: EdgeInsets.only(top: 100),
                    decoration: BoxDecoration(
                      color: Colors.white,
                    ),
                  ),
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
                            fontSize: 30,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          name,
                          style: TextStyle(
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
                      Icon(Icons.people),
                      Text(" " + followers.toString() , textAlign: TextAlign.center),
                    ],      
                  ),        
                ),                      
              ),           
            ],
          ),          
          Container(
            child: RaisedButton(
              child: Text('Log out'),
              onPressed: () {
                Navigator.pop(context);
              }
            ),            
          ), 
        ],
      ),  
    );       
  }
}