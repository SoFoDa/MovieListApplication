import 'package:flutter/material.dart';
import '../widgets/base_card.dart';
import 'package:public/config.dart';

class SeenCard extends StatelessWidget {  
  String title;
  int release_year;  
  int runtime;
  String posterPath;  

  double _card_height = 95;
  int _hours = 0;
  int _minutes = 0;
  String row1 = "";
  String row2 = "";
  

  SeenCard(this.title, this.release_year, this.runtime, this.posterPath){
    title = this.title;    
    release_year = this.release_year;    
    runtime = this.runtime;
    posterPath = this.posterPath;
    List<String> titleList = title.split(" ");

    // Format title
    for (var word in titleList) {
      if(row1.length + word.length < 40) {        
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
          Positioned(                    
            child: Container(                            
              alignment: Alignment(1, 0),                    
              child: Container(
                height: _card_height,
                width: 275,            
                decoration: BoxDecoration(
                  //border: Border.all(color: Colors.grey),                  
                  //color: Color(0xFF1b3e73),                  
                ),                          
              )            
            )
          ),          
          Positioned(                
            child: Container(  
              margin: EdgeInsets.fromLTRB(80, (row2.length != 0 ? 20 : 30), 0, 0),
              child: RichText(
                text: TextSpan(
                  style: TextStyle(
                    color: Colors.white,
                  ),
                  children: <TextSpan> [                    
                    TextSpan(
                      text: row1 + "\n" + row2,
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      )
                    ),
                    TextSpan(
                      text: (row2.length != 0 ? "\n    " : "    ") 
                      + release_year.toString()
                      + "         "
                      + _hours.toString() + "h " + _minutes.toString() + "m",
                      style: TextStyle(
                        fontSize: 12,                        
                      )
                    )
                  ],
                ),
              )              
            ),                                                             
          ),
          Positioned(                        
            child: Container(              
              height: _card_height,
              width: 60,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),                                  
                image: DecorationImage(                  
                  image: new NetworkImage('http://' + serverProperties['HOST'] + serverProperties['PORT'] + '/posters/' + posterPath),
                  fit: BoxFit.cover,                  
                ),                                                       
              ),
            ),
          ),  
          Positioned(  
            top: (row2.length != 0 ? 57 : 49),            
            left: 80,                    
            child: Icon(
              Icons.calendar_today,
              size: 11,
              color: Colors.white,
            ), 
          ),    
          Positioned(   
            top: (row2.length != 0 ? 57 : 49),            
            left: 139,                      
            child: Icon(
              Icons.timer,
              size: 11,
              color: Colors.white,
            ), 
          ),                     
        ],
      ),                 
    );
  }
}
