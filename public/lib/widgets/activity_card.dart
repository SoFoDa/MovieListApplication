import 'package:flutter/material.dart';
import 'package:public/models/activity.dart';

class ActivityCard extends StatelessWidget {
  Activity activity;

  ActivityCard(this.activity){
    activity = this.activity;
  }

  @override
  Widget build(BuildContext context) {
    return Container(   
      margin: EdgeInsets.symmetric(vertical: 10),
      height: (activity.type == 'movie' ? 150 : 80),       
      child: Stack(  
        overflow: Overflow.visible,              
        children: <Widget>[ 
          // Blue card          
          Positioned(   
            right: 10,                  
            child: Container(
              alignment: Alignment(20, 20),
              height: (activity.type == 'movie' ? 150 : 80),
              width: 270,       
              decoration: BoxDecoration(        
                borderRadius: BorderRadius.circular(0),
                color: Color(0xFF1b3e73),
                boxShadow: [BoxShadow(
                  color: Color(0xAA092042),
                  offset: Offset(0, 15),
                  blurRadius: 0,
                  spreadRadius: -9,
                )]
              ),                                                                                    
            ),
          ), 
          // Movie poster      
          Positioned( 
            top: 13,   
            left: 10,                          
            child: Opacity(
              opacity: (activity.type == 'movie' ? 1.0 : 0.0),
              child: Container(
                alignment: Alignment(20, 20),
                height: 125,
                width: 83,  
                decoration: BoxDecoration(  
                  border: Border.all(color: Colors.white),                  
                  image: DecorationImage(
                    // TODO make non-static
                    image: AssetImage('assets/bladerunnerPoster.jpg'),
                    fit: BoxFit.cover,
                  ),                                   
                ),                                             
              ),
            ),
          ),   
          // Friend icon
          Positioned(
            top: 0,   
            left: 3, 
            child: Opacity(
              opacity: (activity.type == 'friend' ? 1.0 : 0.0),
              child: Icon(              
                Icons.person_add,
                color: Color(0xFFEEEEEE),
                size: 80,
              ),              
            ),
          ),
          // Username   
          Positioned(      
            top: 30,
            left:105,                              
            child: RichText(
              text: TextSpan(
                style: TextStyle(
                  color: Colors.white,                    
                  fontSize: 15,                                              
                ), 
                children: <TextSpan>[
                  TextSpan(text: 
                    '${activity.username} ', 
                    style: TextStyle(fontWeight: 
                    FontWeight.bold)
                  ),
                  TextSpan(text: 
                    (activity.type == 'movie' ? 'has seen' : 'is now friends with'), 
                    style: TextStyle(color: Color(0xFFd6dceb))
                  ),                  
                ],    
              ),  
            ),
          ),
          // activity name
          Positioned(      
            top: 50,
            left:105,                              
            child: Text(
              (activity.type == 'movie' ? '${activity.activityMovie.genre}' : ''),              
              style: TextStyle(
                color: Colors.white,                    
                fontSize: 20, 
                fontWeight: FontWeight.bold,                                                             
              ),  
            ),
          ),
          Positioned(
            top: 80,
            left:105, 
            child: Opacity(
              opacity: (activity.type == 'movie' ? 1.0 : 0.0),
              child: Icon(
                Icons.theaters, 
                color: Color(0xFFd6dceb), 
                size: 12),
              ),            
          ),         
          Positioned(
            top: 80,
            left:120, 
            child: Opacity(
              opacity: (activity.type == 'movie' ? 1.0 : 0.0),
              child: Text(
                (activity.type == 'movie' ? '${activity.activityMovie.movieName}' : '${activity.activityFriend.friendUsername}'),              
                style: TextStyle(
                  color: Color(0xFFd6dceb), 
                  fontSize: 11,
                )
              ),  
            ),
          ),                    
        ],
      ),      
    );
  }

}


