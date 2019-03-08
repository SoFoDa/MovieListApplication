import 'package:flutter/material.dart';

class BaseCard extends StatelessWidget {
  double width;
  double height;
  EdgeInsets margin;

  BaseCard(this.width, this.height, this.margin){
    width = this.width;
    height = this.height;
    margin = this.margin;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: width,
      margin: margin,
      decoration: BoxDecoration(                            
        border: Border.all(color: Colors.blueGrey),             
        color: Color(0xFF1b3e73),
        boxShadow: [BoxShadow(
          color: Color(0xAA092042),
          offset: Offset(0, 15),
          blurRadius: 0,
          spreadRadius: -9,
        )]
      ),       
    );
  }
}


