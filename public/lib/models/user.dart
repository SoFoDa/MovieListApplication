
class User {
  final String _auth;
  final int _userId;
  final String _username;
  final String _name;

  User(this._auth, this._userId, this._username, this._name);

  int get userId => _userId; 
  String get username => _username; 
  String get name => _name; 
  String get token => _auth; 
}