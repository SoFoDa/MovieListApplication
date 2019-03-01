import 'package:flutter/material.dart';
import './views/home.view.dart' as home;
import './views/stats.view.dart' as stats;

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Login(),      
    );
  }
}

// TODO move into own file
class Login extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: <Widget>[
          Container(
            padding: EdgeInsets.only(top: 80.0, left: 25.0, right: 25.0),
            child: TextField(
              decoration:InputDecoration(
                labelText: 'username'
                //TODO labelStyle
              )
            )
          ),
          Container(
            padding: EdgeInsets.only(top: 20.0, left: 25.0, right: 25.0),
            child: TextField(
              decoration:InputDecoration(
                labelText: 'email'
                //TODO labelStyle
              )
            )
          ),
          Container(
            padding: EdgeInsets.only(top: 55.0),
            child: Center(
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
          ),
          Container(
            padding: EdgeInsets.only(top: 20.0),
            child: Center(
              child: RaisedButton(
                child: Text('Register'),
                // TODO implement register
                onPressed: () {},
              ),
            ),
          ),
        ],        
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
          home.Home(),                     
          stats.Stats(),          
        ]
      )
    );
  }  
}