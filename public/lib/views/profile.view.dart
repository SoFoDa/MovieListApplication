import 'package:flutter/material.dart';

class Profile extends StatelessWidget {
  @override
  Widget build(BuildContext context) {    
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          // Add one stop for each color. Stops should increase from 0 to 1
          stops: [0.1, 0.7, 0.9],
          colors: [
            // Colors are easy thanks to Flutter's Colors class.
            Color(0xFF245ADC),
            Color(0xFF594CD2),
            Color(0xFF913AC5),              
          ],
        ),
      ),
      child: Stack(        
        children: <Widget>[
          Positioned(
            child: Center(
              child:Container(
                height: MediaQuery.of(context).size.height - 300,
                width: MediaQuery.of(context).size.width - 100,
                decoration: BoxDecoration(
                  color: Colors.white,
                ),
              ),
            )
          ),
          Positioned(
            child: Center(
              child: RaisedButton(
                child: Text('Log out'),
                onPressed: () {
                  Navigator.pop(context);
                }
              ),
            ),        
          )          
        ],
      )    
    );       
  }
}