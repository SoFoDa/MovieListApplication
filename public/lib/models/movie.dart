class Movie {
  final String title;
  final int runtime;
  final List<String> genreList;
  final int releaseYear;
  final List<String> directorList;
  final String posterPath;

  Movie({
    this.title,
    this.runtime,
    this.genreList,
    this.releaseYear,
    this.directorList,
    this.posterPath,
 });

 factory Movie.fromJson(Map<String, dynamic> parsedJson) {
    var directorsJson = parsedJson['streets'];
    List<String> dList = new List<String>.from(directorsJson);
    var genreJson = parsedJson['streets'];
    List<String> gList = new List<String>.from(genreJson);
    return Movie(
      title: parsedJson['title'],
      runtime : parsedJson['runtime'],
      genreList : gList,
      releaseYear : parsedJson['release_year'],
      directorList: dList,
      posterPath : parsedJson['poster_path']
    );
  }

}