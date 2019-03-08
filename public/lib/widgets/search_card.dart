import 'package:flutter/material.dart';
import '../widgets/base_card.dart';

class SearchCard extends StatelessWidget {
  String title;
  int release_year;  
  List<dynamic> genreList;
  List<dynamic> directorList;
  String _genres = "";
  String _directors = "";
  int runtime;
  int _hours = 0;
  int _minutes = 0;  
  

  SearchCard(this.title, this.release_year, this.genreList, this.directorList, this.runtime){
    title = this.title;
    release_year = this.release_year;    
    genreList = this.genreList; 
    directorList = this.directorList;       
    for (var i = 0; i < genreList.length; i++) {
      _genres += genreList[i];
      if(i != genreList.length - 1){
        _genres += " / ";
      }
    }    
    for (var i = 0; i < directorList.length; i++) {
      _directors += directorList[i];
      if(i != directorList.length - 1){
        _directors += ", ";
      }
    }    
    while(runtime > 60){
      runtime -= 60;
      _hours++;
    }
    _minutes = runtime;      
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Stack(
        children: <Widget>[                          
          // background card 
          BaseCard(MediaQuery.of(context).size.width, 100, EdgeInsets.all(0)),
          // title
          Positioned(
            top: 10,
            left: 10,
            child: RichText(                              
              text: TextSpan(
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,                                  
                ),
                children: <TextSpan>[
                  // TODO format correctly for long titles
                  TextSpan(                    
                    text: title,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,             
                    )                                                                      
                  ),
                  TextSpan(
                    text: " (" + release_year.toString() + ")",                                    
                  ),                  
                ],
              ),
            ), 
          ),                          
          // movie information
          Positioned(
            top: 40,
            left: 10,
            child: Row(
              children: <Widget>[
                Icon(
                  Icons.theaters,
                  color: Color(0xFFd6dceb), 
                  size: 12,
                ),
                Text(
                  " " + _genres,
                  style: TextStyle(
                    color: Color(0xFFd6dceb), 
                    fontSize: 11,
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            top: 60,
            left: 10,
            child: Row(
              children: <Widget>[
                Icon(
                  Icons.movie_creation,
                  color: Color(0xFFd6dceb), 
                  size: 12,
                ),
                Text(
                  " " + _directors,
                  style: TextStyle(
                    color: Color(0xFFd6dceb), 
                    fontSize: 11,
                  ),
                ),
              ],
            ),
          ), 
          Positioned(
            top: 80,
            left: 10,
            child: Row(
              children: <Widget>[
                Icon(
                  Icons.timer,
                  color: Color(0xFFd6dceb), 
                  size: 12,
                ),
                Text(
                  " " + _hours.toString() + "h " + _minutes.toString() + "m",
                  style: TextStyle(
                    color: Color(0xFFd6dceb), 
                    fontSize: 11,
                  ),
                ),
              ],
            ),
          ),   
        ],
      ),                 
    );
  }
}
