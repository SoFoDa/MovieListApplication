import 'package:flutter/material.dart';
import './home_page.dart' as home_page;
import './stats_page.dart' as stats_page;

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: _Login(),
    );
  }
}

class _Login extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:Center(
        child: RaisedButton(
          child: Text('Log in'),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => _MovieListApp()),
            );
          },
        ),
      ),
    );
  }
}

class _MovieListApp extends StatefulWidget {
  @override
  _MovieListAppState createState() => _MovieListAppState();
}

class _MovieListAppState extends State<_MovieListApp> with SingleTickerProviderStateMixin{
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
        title: new Text("MovieList"), 
        backgroundColor: Colors.redAccent,
      ),  

      bottomNavigationBar: new Material(
        color: Colors.redAccent,
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
          home_page.HomePage(),                     
          stats_page.StatsPage(),          
        ]
      )
    );
  }  
}