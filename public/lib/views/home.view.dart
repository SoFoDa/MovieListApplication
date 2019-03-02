import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();  
}

class _HomeState extends State<Home> with SingleTickerProviderStateMixin{
  // Static example data
  List<String> movies = ['Mad Max: Fury Road', 
                         'Hot Fuzz', 
                         'Thor: Ragnarok', 
                         'The Lego Movie', 
                         'Manchester by the Sea',
                         'Birdman'];

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
            child: AppBar(
              title: Text(
                'Activity feed',
                style: TextStyle(
                  fontSize: 20
                ),
              ),                
              backgroundColor: Colors.redAccent,            
              automaticallyImplyLeading: false,              
            )
          ),
          Expanded(
            child: Center(        
              child: ListView.builder(
                itemCount: movies.length,
                itemBuilder: (context, index) {
                  return ListTile(             
                    // TODO format card design with activity info
                    subtitle: Card(
                      child: Container(
                        padding: EdgeInsets.all(35.0),
                        child: Text('${movies[index]}'),
                      ),
                    ),             
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