import 'package:flutter/material.dart';
import 'package:public/util/network_utility.dart';
import 'package:public/config.dart';
import 'package:public/services/authentication.dart';
import 'package:public/services/websockets.dart';

class Stats extends StatefulWidget {  
  @override
  StatsPage createState() => StatsPage();  
}

class StatsPage extends State<Stats> {
  NetworkUtility _netUtil = new NetworkUtility();
  Authentication _auth = new Authentication();
  Websocket ws = new Websocket();
  Map<String, dynamic> _stats = {};

  void initState() { 
    super.initState();
    // Get user stats
    var url = Uri.http(serverProperties['HOST'] + serverProperties['PORT'], serverProperties['API_ENDPOINT'] + '/userStats');
    Map<String, String> headers = {'authorization': 'Bearer ' + _auth.token, 'user_id': _auth.userID.toString(), 'device_id': _auth.deviceIdLocal};      
    print(url);  
    _netUtil.get(url, header: headers).then((res) {
      if (this.mounted) {  
        res = res['data'];        
        setState(() {            
          _stats = res;
          print(_stats);
        });
      }
    });   
  }

  @override
  Widget build(BuildContext context) {  
    ws.send("hello");  
    if (_stats["runtime"] != null) {      
      return Container(      
        child: Center(        
          child: Text('Total runtime: ' + _stats['runtime'] + 
          'min \nFavourite genre: ' + _stats['genre']['genre_type'] + " " +
          "(" + _stats['genre']['count'].toString() + ")" + 
          "\nFavourite director: " + _stats['director']['name'] + " (" + _stats['director']['count'].toString() + ")"),           
        ),
      );
    } else {
      return Container(
        child: Center(
          child: Text("No stats available")
        ),        
      );
    }
    
  }
}