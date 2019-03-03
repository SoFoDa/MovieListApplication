import 'package:flutter/material.dart';
import 'package:public/models/activity.dart';

class ActivityCard extends StatelessWidget {
  Activity activity;

  ActivityCard(this.activity){
    activity = this.activity;
  }
  
  String formatActivity() {        
    if(activity.type == 'movie') {
      return 'has seen';        
    }    
    return 'is now friends with';
  }

  String formatName() {        
    if(activity.type == 'movie') {
      return '${activity.activityMovie.movieName}';        
    }    
    return '${activity.activityFriend.friendUsername}'; 
  }  

  String formatDescription() {
    if(activity.type == 'movie') {
      return '${activity.activityMovie.genre}';        
    }
    return '';
  }

  double isMovie() {
    if(activity.type == 'movie') { return 1.0; }
    return 0.0;
  }



  @override
  Widget build(BuildContext context) {
    return Container(   
      margin: EdgeInsets.symmetric(vertical: 13),
      height: 150,       
      child: Stack(  
        overflow: Overflow.visible,              
        children: <Widget>[ 
          // Blue card          
          Positioned(   
            right: 10,                  
            child: Container(
              alignment: Alignment(20, 20),
              height: 150,
              width: 270,       
              decoration: BoxDecoration(        
                borderRadius: BorderRadius.circular(7.0),
                color: Color(0xFF1b3e73),
                boxShadow: [BoxShadow(
                  color: Color(0xFF092042),
                  offset: Offset(3, 3),
                  blurRadius: 0,
                )]
              ),                                                                                    
            ),
          ), 
          // Movie poster      
          Positioned( 
            top: 13,   
            left: 10,                          
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
                  TextSpan(text: '${activity.username} ', style: TextStyle(fontWeight: FontWeight.bold)),
                  TextSpan(text: formatActivity(), style: TextStyle(color: Color(0xFFd6dceb))),                  
                ],    
              ),  
            ),
          ),
          // activity name
          Positioned(      
            top: 50,
            left:105,                              
            child: Text(
              formatName(),              
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
              opacity: isMovie(),
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
              opacity: isMovie(),
              child: Text(
                formatDescription(), 
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

