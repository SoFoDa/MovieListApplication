import 'package:flutter/material.dart';
import 'package:public/models/activity.dart';
import '../widgets/base_card.dart';
import 'package:public/config.dart';
import 'package:intl/intl.dart';

class ActivityCard extends StatelessWidget {
  // Positional values
  final double _CARD_WIDTH = 270;
  final double _LEFT_MARGIN = 10;
  final double _MOVIE_TOP = 30;
  final double _FRIEND_TOP = 15;
  String _imageUrl;
  
  Activity activity;  

  ActivityCard(this.activity){
    activity = this.activity;
    if (activity.type == 'movie') {
      var posterPath = activity.activityMovie.posterPath;
      if (posterPath == null) {
        posterPath = "noposter.jpg";
      }
      _imageUrl = ("http://${serverProperties['HOST']}${serverProperties['PORT']}/posters/${posterPath}");
    }
  }

  @override
  Widget build(BuildContext context) {
    Widget child;
    if (activity.type == 'movie') {
      child = movieWidget();
    } else {
      child = friendWidget();
    }
    return Container(   
      margin: EdgeInsets.symmetric(vertical: 10),
      height: (activity.type == 'movie' ? 150 : 75),       
      child: child,      
    );
  }

  Widget movieWidget() {
    return Stack(  
      overflow: Overflow.visible,              
      children: <Widget>[ 
        // Blue card          
        Positioned(   
          right: _LEFT_MARGIN,                  
          child: BaseCard(_CARD_WIDTH, 150, EdgeInsets.all(0)),
        ), 
        // Movie poster      
        Positioned( 
          top: _MOVIE_TOP - 17,   
          left: _LEFT_MARGIN,                          
          child: Container(                
            alignment: Alignment(20, 20),
            height: 125,
            width: 83,  
            decoration: BoxDecoration(  
              border: Border.all(color: Colors.grey),                  
              image: new DecorationImage(
                image: new NetworkImage(_imageUrl),
                fit: BoxFit.cover
              ),                                       
            ),                                             
          ),
        ),
        // Username   
        Positioned(      
          top: _MOVIE_TOP,
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
                  'has seen', 
                  style: TextStyle(color: Color(0xFFd6dceb))
                ),                  
              ],    
            ),  
          ),
        ),
        // activity name
        Positioned(      
          top: _MOVIE_TOP + 20,
          left:_LEFT_MARGIN + 95,                              
          child: Text(
            '${activity.activityMovie.movieName}',              
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
          child: Row(
            children: <Widget>[    
              // release year icon
              Container(
                margin:EdgeInsets.only(left: 0),
                child: Icon(
                  Icons.calendar_today, 
                  color: Color(0xFFd6dceb), 
                  size: 12
                ), 
              ),                 
              // release year
              Text(
                ' ${activity.activityMovie.releaseYear}',
                style: TextStyle(
                  color: Color(0xFFd6dceb), 
                  fontSize: 11,
                )                    
              ),                                                 
            ],
          ),   
        ),                
      ],
    );
  }

  Widget friendWidget() {
    return Stack(  
      overflow: Overflow.visible,              
      children: <Widget>[ 
        // Blue card          
        Positioned(   
          right: _LEFT_MARGIN,                  
          child: BaseCard(_CARD_WIDTH, 75, EdgeInsets.all(0)),
        ), 
        // Friend icon
        Positioned(            
          left: _LEFT_MARGIN - 7, 
          child: Icon(              
            Icons.person_add,
            color: Color(0xFFEEEEEE),
            size: 80,
          ), 
        ),
        // Username   
        Positioned(      
          top: _FRIEND_TOP,
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
                  'is now following', 
                  style: TextStyle(color: Color(0xFFd6dceb))
                ),                  
              ],    
            ),  
          ),
        ),
        // activity name
        Positioned(      
          top: _FRIEND_TOP + 20,
          left:_LEFT_MARGIN + 95,                              
          child: Text(
            '${activity.activityFriend.friendUsername}',              
            style: TextStyle(
              color: Colors.white,                    
              fontSize: 20, 
              fontWeight: FontWeight.bold,                                                             
            ),  
          ),
        ),             
      ],
    );
  }
}


