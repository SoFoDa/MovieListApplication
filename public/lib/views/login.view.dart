import 'package:flutter/material.dart';
import 'package:public/services/authentication.dart';

class _LoginData {
  String username = '';
  String password = '';
}

class LoginPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => new Login();
}

class Login extends State<LoginPage> {
  _LoginData _data = new _LoginData();
  Authentication _auth = new Authentication();
  final GlobalKey<FormState> _formKey = new GlobalKey<FormState>();
  String _errorText = "";

  void submit() {
    if (this._formKey.currentState.validate()) {
      _formKey.currentState.save();
    }
  }

  @override
  void initState(){  
    _auth.handShake().then((validToken) {
      print(validToken);
      if (!validToken) {
        //super.initState();    
      } else {
        Navigator.pushNamed(context, '/home');
      }
    });
  }

  @override
  void dispose(){               
    super.dispose();
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
                  "Login",
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
                  }
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
                  }
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
                    child: Text('Log in'),
                    onPressed: () {
                      submit();
                      _auth.login(this._data.username, this._data.password).then((userId) {
                        if (userId != null) {
                          setState(() {
                            _errorText = "";
                          });
                          Navigator.pushNamed(context, '/home');
                        } else {
                          setState(() {
                            _errorText = "Invalid username or password!";
                          });
                        }
                      });
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
                    onPressed: () {
                      Navigator.pushNamed(context, '/register');
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