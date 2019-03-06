import 'package:flutter/material.dart';
import 'package:public/services/authentication.dart';

class _RegisterData {
  String username = '';
  String password = '';
}

class RegisterPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => new Register();
}

class Register extends State<RegisterPage> {
  _RegisterData _data = new _RegisterData();
  Authentication _auth = new Authentication();
  final GlobalKey<FormState> _formKey = new GlobalKey<FormState>();
  String _errorText = "";

  void submit() {
    if (this._formKey.currentState.validate()) {
      _formKey.currentState.save();
      _auth.register(this._data.username, this._data.password).then((userId) {
        if (userId != null) {
          setState(() {
            _errorText = "";
          });
          Navigator.pushNamed(context, '/home');
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: new Container(
        child: new Form(
          key: this._formKey,
          child: Column(
            children: <Widget>[
              Container(
                padding: EdgeInsets.only(top: 60.0),
                child: Text(
                  "Account registration",
                  style: TextStyle(
                    fontStyle: FontStyle.normal, 
                    color: Colors.black,
                    fontSize: 20),
                )
              ),
              Container(
                padding: EdgeInsets.only(top: 10.0, left: 25.0, right: 25.0),
                child: TextFormField(                 
                  decoration:InputDecoration(                        
                    labelText: 'username',               
                  ), onSaved: (String value) {
                      this._data.username = value;
                  }, validator: (value) {
                    if (value.length < 6) {
                      return ('Username has to be at least 6 characters.');
                    }
                  }, 
                )
              ),
              Container(
                padding: EdgeInsets.only(top: 20.0, left: 25.0, right: 25.0),
                child: TextFormField(
                  obscureText: true,
                  decoration:InputDecoration(
                    labelText: 'password'                
                  ), onSaved: (String value) {
                      this._data.password = value;
                  }, validator: (value) {
                    if (value.length < 8) {
                      return ('Username has to be at least 8 characters.');
                    }
                  }, 
                )
              ),
              Container(
                padding: EdgeInsets.only(top: 5.0),
                child: Text(
                  _errorText,
                  style: TextStyle(fontStyle: FontStyle.italic, color: Colors.red),
                )
              ),
              Container(
                padding: EdgeInsets.only(top: 55.0),
                child: Center(
                  child: RaisedButton(                
                    child: Text('Register'),
                    onPressed: () {
                      submit();
                    },
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.only(top: 10.0),
                child: Center(
                  child: RaisedButton(                
                    child: Text('Cancel'),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                ),
              ),
            ],   
          ),     
        ),
      )
    );
  }
}