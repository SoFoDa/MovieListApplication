import 'package:flutter/material.dart';
import './views/login.view.dart' as login;
import './views/home.view.dart' as home;
import './views/profile.view.dart' as profile;
import './views/stats.view.dart' as stats;

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
        // When we navigate to the "/" route, build the FirstScreen Widget
        '/': (context) => login.Login(),
        // When we navigate to the "/second" route, build the SecondScreen Widget
        '/home': (context) => MovieListApp(),        
      },                     
    );
  }
}

class MovieListApp extends StatefulWidget {  
  @override
  MovieListAppState createState() => MovieListAppState();
}

class MovieListAppState extends State<MovieListApp> with SingleTickerProviderStateMixin{  
  TabController controller;

  @override
  void initState(){
    super.initState();
    controller = new TabController(vsync: this, length: 3);
  }

  @override
  void dispose(){
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(      
      appBar: new AppBar(
        // TODO make title dynamic
        title: Text('Home'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
              print("Search!");
            },
          ),
        ],
        automaticallyImplyLeading: false,
      ),        
      bottomNavigationBar: Material(
        color: Color(0xFF133658),
        child: new TabBar(
          controller: controller,          
          tabs: <Tab>[
            new Tab(icon: new Icon(Icons.home)),                               
            new Tab(icon: new Icon(Icons.account_circle)), 
            new Tab(icon: new Icon(Icons.insert_chart)),                           
          ]
        )
      ),   

      body: TabBarView(
        controller: controller,
        children: <Widget>[          
          home.Home(),    
          profile.Profile(),                  
          stats.Stats(),                     
        ]
      ),
    );
  }  
}