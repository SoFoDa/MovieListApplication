import 'package:flutter/material.dart';
import 'package:public/models/activity.dart';
import '../widgets/base_card.dart';

class ActivityCard extends StatelessWidget {
  // Positional values
  final double _CARD_WIDTH = 270;
  final double _LEFT_MARGIN = 10;
  final double _MOVIE_TOP = 30;
  final double _FRIEND_TOP = 15;
  
  Activity activity;  

  ActivityCard(this.activity){
    activity = this.activity;
  }

  @override
  Widget build(BuildContext context) {
    return Container(   
      margin: EdgeInsets.symmetric(vertical: 10),
      height: (activity.type == 'movie' ? 150 : 75),       
      child: Stack(  
        overflow: Overflow.visible,              
        children: <Widget>[ 
          // Blue card          
          Positioned(   
            right: _LEFT_MARGIN,                  
            child: BaseCard(_CARD_WIDTH, (activity.type == 'movie' ? 150 : 75), EdgeInsets.all(0)),
          ), 
          // Movie poster      
          Positioned( 
            top: _MOVIE_TOP - 17,   
            left: _LEFT_MARGIN,                          
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
            left: _LEFT_MARGIN - 7, 
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
            top: (activity.type == 'movie' ? _MOVIE_TOP : _FRIEND_TOP),
            left: _LEFT_MARGIN + 95,                              
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
            top: (activity.type == 'movie' ? _MOVIE_TOP + 20 : _FRIEND_TOP + 20),
            left:_LEFT_MARGIN + 95,                              
            child: Text(
              (activity.type == 'movie' ? '${activity.activityMovie.movieName}' : '${activity.activityFriend.friendUsername}'),              
              style: TextStyle(
                color: Colors.white,                    
                fontSize: 20, 
                fontWeight: FontWeight.bold,                                                             
              ),  
            ),
          ),
          // movie information
          Positioned(
            top: _MOVIE_TOP + 50,
            left: _LEFT_MARGIN + 95, 
            child: Opacity(
              opacity: (activity.type == 'movie' ? 1.0 : 0.0),
              child: Row(
                children: <Widget>[   
                  // genre icon            
                  Icon(
                    Icons.theaters, 
                    color: Color(0xFFd6dceb), 
                    size: 12
                  ),  
                  // genre
                  Text(
                    (activity.type == 'movie' ? ' ${activity.activityMovie.genre}' : ' '),
                    style: TextStyle(
                      color: Color(0xFFd6dceb), 
                      fontSize: 11,
                    )                    
                  ), 
                  // release year icon
                  Container(
                    margin:EdgeInsets.only(left: 15),
                    child: Icon(
                      Icons.calendar_today, 
                      color: Color(0xFFd6dceb), 
                      size: 12
                    ), 
                  ),                 
                  // release year
                  Text(
                    (activity.type == 'movie' ? ' ${activity.activityMovie.releaseYear}' : ' '),
                    style: TextStyle(
                      color: Color(0xFFd6dceb), 
                      fontSize: 11,
                    )                    
                  ),                                                 
                ],
              ),   
            ), 
          ),
          // genre text                 
        ],
      ),      
    );
  }

}


