import 'package:http/http.dart' as http;
import 'dart:async';

class Searcher {

  static String _TMDB_API_KEY = "e28d3f899e9e67495ce678fd428c0139";

  Future<String> searchByTitle(String title) {
    return http.read("https://api.themoviedb.org/3/search/movie?api_key=$_TMDB_API_KEY&language=en-US&query=${Uri.encodeFull(title)}&page=1&include_adult=false");
  }

  Future<String> searchPopular() {
    return http.read("https://api.themoviedb.org/3/movie/popular?api_key=$_TMDB_API_KEY&language=en-US&page=1");
  }

  
  Future<String> searchById(String id) {
    return http.read("https://api.themoviedb.org/3/movie/$id?api_key=$_TMDB_API_KEY&language=en-US");
  }
}