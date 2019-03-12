import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../widgets/activity_card.dart' as activity_card;
import 'package:public/models/activity.dart';
import 'package:public/util/network_utility.dart';
import 'package:public/config.dart';
import 'package:public/services/authentication.dart';
import 'package:public/views/profile.view.dart';
import 'package:public/views/movie.view.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();  
}

class _HomeState extends State<Home> with SingleTickerProviderStateMixin{  
  NetworkUtility _netUtil = new NetworkUtility();
  Authentication _auth = new Authentication();
  var _formatter = new DateFormat('yyyy-MM-dd');
  Map<String, dynamic> _activities;
  int _activityLen = 0;
  String previousDate;

  Column checkPrevDate(String date, int index) {  
    DateTime ldate = DateTime.parse(date);
    date = _formatter.format(ldate);
    if(index == 0) {
      previousDate = date;
      return Column(children: <Widget>[Container(margin: EdgeInsets.only(top: 13), child: Text(date, style: TextStyle(fontSize: 10, color: Colors.white),))]);
    }  
    if(date != previousDate) {
      previousDate = date;
      return Column(children: <Widget>[Divider(color: Colors.grey), Text(date, style: TextStyle(fontSize: 10, color: Colors.white),)]);
    }
    return null;
  }

  void getActivities() {
    var url = Uri.http(serverProperties['HOST'] + serverProperties['PORT'], serverProperties['API_ENDPOINT'] + '/friendsActivity');
    Map<String, String> headers = {'authorization': 'Bearer ' + _auth.token, 'user_id': _auth.userID.toString(), 'device_id': _auth.deviceIdLocal};      
    print(url);  
    _netUtil.get(url, header: headers).then((res) {
      if (this.mounted) {  
        res = res['data'];
        print(res);
        setState(() {  
          _activities = res;  
        });
      }
    });   
  }

  @override
  void initState(){      
    super.initState();  
    getActivities();
  }

  @override
  void dispose(){               
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_activities != null) {
      _activityLen = _activities.length;
    }
    return Container(  
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,            
          stops: [0.1, 0.7, 0.9],
          colors: [              
            Color(0xFF245ADC),
            Color(0xFF594CD2),
            Color(0xFF594CD2),              
          ],
        ),
      ),             
      child: ListView.builder(
        itemCount: _activityLen,
        itemBuilder: (context, index) {
          var activity =_activities[index.toString()];
          Activity listItem;
          if (activity['friend_username'] != null) {
            listItem = new Activity(activity['username'], 'friend', activity['date'],
              null, ActivityFriend(activity['friend_username']));
          } else {
            listItem = new Activity(activity['username'], 'movie', activity['date'], 
              new ActivityMovie(activity['type'], activity['title'], activity['release_year'].toString(), activity['poster_path']), null);
          }
          return ListTile(    
            title: checkPrevDate(listItem.date, index),
            subtitle: activity_card.ActivityCard(listItem),   
            onTap: () {
              if (activity['friend_username'] == null) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => MoviePage(movieId: activity['movie_id'].toString()),
                  ),
                );
              } else {
                if (_auth.userID != activity['friend_id']) {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => Profile(userId: activity['friend_id'], myProfile: false,),
                    ),
                  ).then((val) {
                    if(val != null) val ? getActivities() : null;
                  });
                }
              }
            },                                   
          );
        },
      ),     
    );                
  }
}