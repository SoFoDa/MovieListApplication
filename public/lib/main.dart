import 'package:flutter/material.dart';
import './views/home.view.dart' as home;
import './views/stats.view.dart' as stats;
import './views/login.view.dart' as login;

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MovieListApplication',      
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
    controller = new TabController(vsync: this, length: 2);
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
        title: new Text(
          "MovieList!",
          style: TextStyle(
            fontSize: 25
          ),
        ),         
        // set to false for removal of back button
        automaticallyImplyLeading: true,
      ),  

      bottomNavigationBar: new Material(
        color: Color(0xFF133658),
        child: new TabBar(
          controller: controller,          
          tabs: <Tab>[
            new Tab(icon: new Icon(Icons.home)),                               
            new Tab(icon: new Icon(Icons.account_circle)),               
          ]
        )
      ),   

      body: new TabBarView(
        controller: controller,
        children: <Widget>[          
          home.Home(),                     
          stats.Stats(),          
        ]
      )
    );
  }  
}