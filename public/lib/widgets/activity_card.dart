import 'package:flutter/material.dart';
import 'package:public/models/activity.dart';

class ActivityCard extends StatelessWidget {
  Activity activity;
  ActivityCard(this.activity){
    activity = this.activity;
  }
  
  String formatText() {    
    // TODO add design
    if(activity.type == 'movie') {
      return '${activity.username} saw the movie ${activity.activityMovie.movieName}';        
    }    
    return '${activity.username} is now friends with ${activity.activityFriend.friendUsername}';
  }

  @override
  Widget build(BuildContext context) {
    return Card(       
      elevation: 5,
      child: Column(        
        children: <Widget>[
          Text(
            formatText(),
            textAlign: TextAlign.left,
          ),
        ],
      ),      
    );
  }

}

