import 'package:path_provider/path_provider.dart';
import 'dart:async';
import 'package:sqflite/sqflite.dart';
import 'movie.dart';

class Watchlist {

  static Database db;
  static bool firstUseDB = true;

  static const String sqlMovie = """
    id INTEGER PRIMARY KEY,
    vote_count INTEGER,
    popularity REAL,
    vote_average REAL,
    title TEXT,
    poster_path TEXT,
    original_language TEXT,
    original_title TEXT,
    backdrop_path TEXT,
    overview TEXT,
    release_date TEXT  
  """;

  static initDatabase() async {
    String path = "${(await getApplicationDocumentsDirectory()).path}/watchlist.db";

    await openDatabase(path, version: 1, onCreate: (Database db, int version) async {
      await db.execute("CREATE TABLE watched ($sqlMovie)");
      await db.execute("CREATE TABLE toWatch ($sqlMovie)");
      firstUseDB = true;
    });

    db = await openDatabase(path);
    List<Movie> watched = await watchedList();

    watched.forEach((movie) => dropToWatchMovie(movie.id));
  }

  static addWatchedMovie(Movie movie) async {
    db.rawInsert("INSERT INTO watched(id, title, vote_average, poster_path) VALUES(${movie.id}, \"${movie.title}\", ${movie.vote_average}, \"${movie.poster_path}\")");
  }

  static addToWatchMovie(Movie movie) async {
    db.rawInsert("INSERT INTO toWatch(id, title, vote_average, poster_path) VALUES(${movie.id}, \"${movie.title}\", ${movie.vote_average}, \"${movie.poster_path}\")");
  }

  static Future<List<Movie>> watchedList() async {
    List<Map> watched = await db.rawQuery("SELECT * FROM watched");
    return watched.map<Movie>((entry) => new Movie.elemental(entry['id'], entry['title'], entry['vote_average'], entry['poster_path'])).toList();
  }
  
  static dropWatchedMovie(int id) async {
    db.rawDelete("DELETE FROM watched WHERE id = $id");
  }

  static dropToWatchMovie(int id) async {
    db.rawDelete("DELETE FROM toWatch WHERE id = $id");
  }

  static Future<List<Movie>> watchList() async {
    List<Map> watchList = await db.rawQuery("SELECT * FROM toWatch");
    return watchList.map<Movie>((entry) => new Movie.elemental(entry['id'], entry['title'], entry['vote_average'], entry['poster_path'])).toList();
  }

  static closeDatabase() async {
    await db.close();
  }

}