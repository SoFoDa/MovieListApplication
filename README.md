# Movie List Application

A project created by [**@johvh**](https://github.com/JohanKJIP) & [**@davidjo2**](https://github.com/SoFoDa) for DD1389 Internet programming.

Home view             |  Profile view          |  Movie view
:-------------------------:|:-------------------------:|:-------------------------: 
<img src="https://github.com/SoFoDa/MovieListApplication/blob/master/image1.png" width="200">  |  <img src="https://github.com/SoFoDa/MovieListApplication/blob/master/image2.png" width="200"> | <img src="https://github.com/SoFoDa/MovieListApplication/blob/master/image3.png" width="200">


# Project Specification

### Functionality
The website will allow the user to create lists of movies they have seen and share their favourites with friends. You will start at a login screen where the user will either create a new account or give their account name and password to get access to the website. The homepage will consist of a feed that informs the user of the activity of the users they follow such as marking a movie as seen or adding a movie to their favourites. This feed will get updated through WebSockets. The user will be able to search for movies and add them to their “seen” list. They will also be able to search for users and follow them. Furthermore, there will be a view that gives statistics of the users movie habits such as favourite genres and the time spent watching movies (accumulative of the movies’ runtimes).

# How to use

1. Install flutter and node.
2. Run `npm install` in the root of the project.
3. Add a .env file in the root of the project with the following properties:
```js
PORT= server port to use
JWT_SECRET= json web tokens secret
OMDB_KEY= api key to omdb api
DB_USER= db username
DB_PASSWORD= db password
DB_DB= database in the db
DB_HOST= host, i.e ip or localhost
```
4. Create the file config.dart in public/lib. Change host to localhost or ip of server.
```dart
const Map serverProperties = const {
  'HOST': localhost, 
  'PORT': ':8989',
  'API_ENDPOINT': 'api'
};
```
5. Create mysql database with the schema found in app/models/db_schema.sql
6. Go to the root of the project and run the server with npm start
7. Launch the app w/ flutter run


