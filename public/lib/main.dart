// Widgets
import 'package:flutter/material.dart';

// Application views
import './views/login.view.dart' as login;
import './views/register.view.dart' as register;
import './views/home.view.dart' as home;
import './views/profile.view.dart' as profile;
import './views/stats.view.dart' as stats;
import './views/search.view.dart' as search;

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
        '/search': (context) => search.SearchPage(),        
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
  bool activeSearch;

  @override
  void initState(){    
    super.initState();        
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

  @override
  void dispose(){    
    tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(      
      appBar: _appBar(), 
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

  PreferredSizeWidget _appBar() {
    if (activeSearch) {
      return AppBar(
        leading: Icon(Icons.search),
        title: TextField(
          onSubmitted: _search,
          decoration: InputDecoration(
            hintText: "search movie...",
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
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => search.SearchPage(search: queryString),
      ),
    );
  }
}