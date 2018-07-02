import 'package:http/http.dart' as http;
import 'dart:async';

class Searcher {

  static String _OMDB_API_KEY = "f08463cb";
  static String _BASE_URL = "http://www.omdbapi.com/?s={TITLE}&apikey=$_OMDB_API_KEY";

  Future<String> searchByTitle(String title) {
    return http.read(_BASE_URL.replaceAll("{TITLE}", title));
  }

}