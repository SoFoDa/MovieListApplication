import 'package:flutter/material.dart';
import '../widgets/base_card.dart';
import 'package:public/config.dart';

class SearchCard extends StatelessWidget {  
  String title;
  int release_year;  
  List<dynamic> genreList;
  List<dynamic> directorList;  
  int runtime;
  String posterPath;
    
  int _hours = 0;
  int _minutes = 0; 
  String row1 = "";
  String row2 = "";
  String _genres = "";
  String _directors = "";

  int _max_genre_amount = 5;  
  double _card_height = 100;   
  

  SearchCard(this.title, this.release_year, this.genreList, this.directorList, this.runtime, this.posterPath){
    title = this.title;
    release_year = this.release_year;    
    genreList = this.genreList; 
    directorList = this.directorList;  
    List<String> titleList = title.split(" ");
         
    // Format title
    for (var word in titleList) {
      if(row1.length + word.length < 30) {        
        row1 +=  word;              
        if(row1.length != 0) {
          row1 += " ";
        }             
      } else if(row2.length + word.length < 25) {  
        row2 += word;              
        if(row2.length != 0) {
          row2 += " ";
        }              
      } else if(row2.length + word.length >= 25) {
        row2 += " ...";              
      }      
    } 

    // Make card higher if two title rows necessary
    if(row2.length > 0) {       
      _card_height = 125; 
    }

    // Limit maximum amount of genres
    if(genreList.length < _max_genre_amount) {
      _max_genre_amount = genreList.length;
    }

    // Format genres     
    for (var i = 0; i < _max_genre_amount; i++) {
      _genres += genreList[i];
      if(i != _max_genre_amount - 1){
        _genres += " / ";
      }
    }    

    // Format directors
    for (var i = 0; i < directorList.length; i++) {
      _directors += directorList[i];
      if(i != directorList.length - 1){
        _directors += ", ";
      }
    }    

    // Get runtime values
    while(runtime != null && runtime > 60){
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
          BaseCard(MediaQuery.of(context).size.width, _card_height, EdgeInsets.only(bottom: 10)),
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
                  TextSpan(                    
                    text: (row2.length == 0 ? row1 : row1 + "\n" + row2),
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
            top: _card_height - 60,
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
            top: _card_height - 40,
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
            top: _card_height - 20,
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
