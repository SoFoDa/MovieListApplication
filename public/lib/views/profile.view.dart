import 'package:flutter/material.dart';

class Profile extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: RaisedButton(
        child: Text('Log out'),
        onPressed: () {
          Navigator.pop(context);
        }
      ),
    );
  }
}