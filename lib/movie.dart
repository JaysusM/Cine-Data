
class Movie {
  var vote_count, id, popularity, vote_average;
  String title, poster_path, original_language, original_title, backdrop_path, overview, release_date;
  List genre_ids;
  bool video, adult;

  String getPosterUrl() {
    return "https://image.tmdb.org/t/p/w500$poster_path";
  }

  Movie(Map content) :
      vote_count = content["vote_count"],
      id = content["id"],
      video = content["video"],
      vote_average = content["vote_average"],
      title = content["title"],
      popularity = content["popularity"],
      poster_path = content["poster_path"],
      original_language = content["original_language"],
      original_title = content["original_title"],
      genre_ids = content["genre_ids"],
      backdrop_path = content["backdrop_path"],
      adult = content["path"],
      overview = content["overview"],
      release_date = content["release_date"];
}