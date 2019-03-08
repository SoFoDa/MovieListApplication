import 'package:flutter/material.dart';

class BaseCard extends StatelessWidget {
  double width;
  double height;

  BaseCard(this.width, this.height){
    width = this.width;
    height = this.height;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: width,
      decoration: BoxDecoration(                            
        //border: Border.all(color: Colors.white),             
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


