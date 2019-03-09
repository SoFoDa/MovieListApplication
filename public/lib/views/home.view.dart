import 'package:flutter/material.dart';
import '../widgets/activity_card.dart' as activity_card;
import 'package:public/models/activity.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();  
}

class _HomeState extends State<Home> with SingleTickerProviderStateMixin{  
  String previousDate;

  // static example data        
  List<Activity> activities = [
    new Activity('SoFoDa', 'movie', '2/3 2019', new ActivityMovie('Seen', 'Blade Runner 2049', 'Sci-Fi', '2017'), null),            
    new Activity('SoFoDa', 'friend', '3/3 2019', null, ActivityFriend('johanKJIP')),
    new Activity('johanKJIP', 'movie', '3/3 2019', new ActivityMovie('Seen', 'Mad Max: Fury Road', 'Action', '2015'), null), 
    new Activity('SoFoDa', 'movie', '5/3 2019', new ActivityMovie('Seen', 'Spotlight', 'Drama', '2015'), null),  
  ];  
  
  // debug example
  List<String> movies = ['Mad Max: Fury Road', 
                         'Hot Fuzz', 
                         'Thor: Ragnarok', 
                         'The Lego Movie', 
                         'Manchester by the Sea',
                         'Birdman'];

  // TODO implement websocket get method for Activity objects  
  // List<Activity> getActivities();

  Column checkPrevDate(String date, int index) {  
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

  @override
  void initState(){      
    super.initState();    
  }

  @override
  void dispose(){               
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return new WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: Container(  
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
          itemCount: activities.length,
          itemBuilder: (context, index) {
            return ListTile(    
              title: checkPrevDate(activities[index].date, index),
              subtitle: activity_card.ActivityCard(activities[index]),                                      
            );
          },
        ),     
      ),               
    );                
  }
}