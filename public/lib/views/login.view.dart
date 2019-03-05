import 'package:flutter/material.dart';

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
                labelText: 'username',               
              )
            )
          ),
          Container(
            padding: EdgeInsets.only(top: 20.0, left: 25.0, right: 25.0),
            child: TextField(
              decoration:InputDecoration(
                labelText: 'password'                
              )
            )
          ),
          Container(
            padding: EdgeInsets.only(top: 55.0),
            child: Center(
              child: RaisedButton(                
                child: Text('Log in'),
                onPressed: () {
                  Navigator.pushNamed(context, '/home');
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