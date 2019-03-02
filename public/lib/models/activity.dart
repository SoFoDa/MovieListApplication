// Preliminary variable choises, will change
class Activity {  
  final String _username;
  final String _type; 
  final String _date;
  final ActivityMovie _activityMovie;
  final ActivityFriend _activityFriend;   

  Activity(this._username, this._type, this._date, this._activityMovie, this._activityFriend);
    
  String get username => _username; 
  String get type => _type;      
  String get date => _date;
  ActivityMovie get activityMovie => _activityMovie;
  ActivityFriend get activityFriend => _activityFriend;
}

class ActivityMovie {
  final String _type;
  final String _movieName;  
  final String _genre;

  ActivityMovie(this._type, this._movieName, this._genre);

  String get type => _type;
  String get movieName => _movieName;
  String get genre => _genre;
}

class ActivityFriend {
  final String _friendUsername;

  ActivityFriend(this._friendUsername);

  String get friendUsername => _friendUsername;
}