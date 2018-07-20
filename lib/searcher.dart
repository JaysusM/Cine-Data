import 'package:http/http.dart' as http;
import 'dart:async';

class Searcher {

  static String _TMDB_API_KEY = "e28d3f899e9e67495ce678fd428c0139";

  Future<String> searchByTitle(String title) {
    return http.read("https://api.themoviedb.org/3/search/movie?api_key=$_TMDB_API_KEY&language=en-US&query=${Uri.encodeFull(title)}&page=1&include_adult=false");
  }

  Future<String> searchPopular({int page = 1}) {
    return http.read("https://api.themoviedb.org/3/movie/popular?api_key=$_TMDB_API_KEY&language=en-US&page=$page");
  }
  
  Future<String> searchById(String id) {
    return http.read("https://api.themoviedb.org/3/movie/$id?api_key=$_TMDB_API_KEY&language=en-US");
  }

  Future<String> searchByGenre(int genre, {int page = 1}) {
    return http.read("http://api.themoviedb.org/3/discover/movie?api_key=$_TMDB_API_KEY&sort_by=popularity.desc&with_genres=$genre&page=$page");
  }

  Future<String> getGenres() {
    return http.read("https://api.themoviedb.org/3/genre/movie/list?api_key=$_TMDB_API_KEY&language=en-US");
  }

  Future<String> searchUpcoming({int page = 1, String region = "US"}) {
    return http.read("https://api.themoviedb.org/3/movie/upcoming?api_key=$_TMDB_API_KEY&language=en-US&page=$page&region=$region");
  }
}