
class User {
  final String _auth;
  final int _userId;
  final String _username;

  User(this._auth, this._userId, this._username);

  int get userId => _userId; 
  String get username => _username; 
  String get token => _auth; 
}