// Widgets
import 'package:flutter/material.dart';

// Application views
import './views/login.view.dart' as login;
import './views/register.view.dart' as register;
import './views/home.view.dart' as home;
import './views/profile.view.dart' as profile;
import './views/stats.view.dart' as stats;
import './views/search.view.dart' as search;
import 'package:public/services/authentication.dart';

import 'package:public/services/websockets.dart';
import 'dart:convert';
import 'package:public/services/websockets.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {  

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Elisto',      
      theme: ThemeData(
        primaryColor: Color(0xFF133658),
        accentColor: Colors.redAccent,
      ),     
      initialRoute: '/',       
      routes: {        
        '/': (context) => login.LoginPage(),        
        '/home': (context) => MovieListApp(), 
        '/register': (context) => register.RegisterPage(),        
      },                           
    );
  }
}

class MovieListApp extends StatefulWidget {    
  @override
  MovieListAppState createState() => MovieListAppState();
}

class MovieListAppState extends State<MovieListApp> with SingleTickerProviderStateMixin {
  Websocket _ws = new Websocket();    
  final List<Text> appBarTitles = [Text('Home'), Text('Profile'), Text('Stats')];
  TabController tabController;  
  Text currentTitle;
  bool activeSearch;
  Authentication _auth = new Authentication();
  bool _newFeedItems = false;

  @override
  void initState(){    
    super.initState();  
    _ws.initCommunication(); 
    _ws.send({'action': 'handshake', 'user': _auth.userID}); 
    _ws.addListener(_webSocketFunction);     
    tabController = new TabController(vsync: this, length: 3);
    currentTitle = appBarTitles[0];
    tabController.addListener(_handleTitle);
    activeSearch = false;
  }

  void _handleTitle() {
    setState(() {
      currentTitle = appBarTitles[tabController.index];
    });
  }

  void _webSocketFunction(String message) {
    Map<String, dynamic> response = jsonDecode(message);
    switch (response['action']) {
      case 'update':
        print('Updating icon...');
        setState(() {
          _newFeedItems = true;
        });
        break;
      default:
    }
  }

  @override
  void dispose(){    
    tabController.dispose();
    super.dispose();
  }

  Widget homeIcon() {
    if (!_newFeedItems) {
      return new Container(
                child: new Icon(Icons.home)
              );
    } else {
      return new Container(
                color: Colors.red,
                child: new Icon(Icons.home)
              );
    }
  }

  @override
  Widget build(BuildContext context) {
    return new WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: new Scaffold(      
        appBar: _appBar(),   
        bottomNavigationBar: Material(
          color: Color(0xFF133658),
          child: new TabBar(
            controller: tabController,          
            tabs: <Tab>[
              new Tab(icon: homeIcon()),                               
              new Tab(icon: new Icon(Icons.person)), 
              new Tab(icon: new Icon(Icons.insert_chart)),                           
            ]
          )
        ),   
        body: TabBarView(
          controller: tabController,
          children: <Widget>[          
            home.Home(),    
            profile.Profile(userId: _auth.userID, myProfile: true),                  
            stats.Stats(),                     
          ]
        ),
      ),
    );  
  }  

  PreferredSizeWidget _appBar() {
    if (activeSearch) {
      return AppBar(
        leading: Icon(Icons.search),
        title: TextField(
          style: TextStyle(
            color: Colors.white,
            fontSize: 16,
          ),
          onSubmitted: _search,
          decoration: InputDecoration.collapsed(                           
            hintText: "search for movie...",
            hintStyle: TextStyle(
              color: Colors.white70,
            )
          ),
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.close),
            onPressed: () => setState(() => activeSearch = false),
          )
        ],
      );
    } else {
      return new AppBar(        
        title: currentTitle,
        automaticallyImplyLeading: false,
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () => setState(() => activeSearch = true),
          ),
        ],        
      );
    }
  }

  void _search(String queryString) {
    Navigator.of(context).push(
      new MaterialPageRoute(
        builder: (_) => search.SearchPage(search: queryString),
      ),
    );
  }
}