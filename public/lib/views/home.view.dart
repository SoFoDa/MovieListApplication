import 'package:flutter/material.dart';
import '../widgets/activity_card.dart' as activity_card;
import 'package:public/models/activity.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();  
}

class _HomeState extends State<Home> with SingleTickerProviderStateMixin{
  // static example data  
  List<Activity> activities = [
    new Activity('SoFoDa', 'friend', '2/3-2019', null, ActivityFriend('johanKJIP')),
    new Activity('SoFoDa', 'movie', '3/3-2019', new ActivityMovie('Seen', 'The Big Sick', 'Comedy/Drama'), null),
    new Activity('johanKJIP', 'movie', '7/3-2019', new ActivityMovie('Seen', 'Thor: Ragnarok', 'Action'), null),    
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
    return Scaffold(      
      body: Column(
        children: <Widget>[
          Container(
            color:Colors.redAccent,
            width: MediaQuery.of(context).size.width,
            height: 35,
            child: Center(
              child: Text(
                'Activity feed',                
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 17, 
                  fontWeight: FontWeight.w500,                                   
                ),
              ),   
            ),     
          ),
          Expanded(
            child: Center(        
              child: ListView.builder(
                itemCount: activities.length,
                itemBuilder: (context, index) {
                  return ListTile(                                 
                    // TODO add style
                    title: Text('${activities[index].date}'),
                    subtitle: activity_card.ActivityCard(activities[index]),                                      
                  );
                },
              ),          
            ),
          ),          
        ],
      )      
    );
  }
}