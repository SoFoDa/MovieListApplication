// Widgets
import 'package:flutter/material.dart';

// Application views
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
        '/': (context) => login.Login(),        
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
  final List<Text> appBarTitles = [Text('Home'), Text('Profile'), Text('Stats')];
  TabController tabController;  
  Text currentTitle;

  @override
  void initState(){    
    super.initState();        
    tabController = new TabController(vsync: this, length: 3);
    currentTitle = appBarTitles[0];
    tabController.addListener(_handleTitle);
  }

  void _handleTitle() {
    setState(() {
      currentTitle = appBarTitles[tabController.index];
    });

  }

  @override
  void dispose(){    
    tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(      
      appBar: new AppBar(        
        title: currentTitle,
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
              print("Search!");
            },
          ),
        ],        
      ),   
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              child: Text('TODO'),
            ),
            ListTile(
              title: Text('item1'),
            ),
            ListTile(
              title: Text('item2'),
            ),
            ListTile(
              title: Text('item3'),
            )
          ],

        ),
      ),     
      bottomNavigationBar: Material(
        color: Color(0xFF133658),
        child: new TabBar(
          controller: tabController,          
          tabs: <Tab>[
            new Tab(icon: new Icon(Icons.home)),                               
            new Tab(icon: new Icon(Icons.person)), 
            new Tab(icon: new Icon(Icons.insert_chart)),                           
          ]
        )
      ),   

      body: TabBarView(
        controller: tabController,
        children: <Widget>[          
          home.Home(),    
          profile.Profile(),                  
          stats.Stats(),                     
        ]
      ),
    );
  }  
}