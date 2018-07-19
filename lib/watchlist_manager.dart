import 'package:path_provider/path_provider.dart';
import 'dart:async';
import 'package:sqflite/sqflite.dart';

class Watchlist {

  static Database db;

  static initDatabase() async {
    String path = "${(await getApplicationDocumentsDirectory()).path}/watchlist.db";
    await openDatabase(path, version: 1, onCreate: (Database db, int version) async {
      await db.execute("CREATE TABLE watched (id INTEGER PRIMARY KEY)");
      await db.execute("CREATE TABLE toWatch (id INTEGER PRIMARY KEY)");
    });

    db = await openDatabase(path);
    (await watchedList()).forEach((id) => dropToWatchMovie(id));
  }

  static addWatchedMovie(int id) async {
    db.execute("INSERT INTO watched(id) VALUES($id)");
  }

  static addToWatchMovie(int id) async {
    db.rawInsert("INSERT INTO toWatch(id) VALUES($id)");
  }

  static Future<List<int>> watchedList() async {
    List<Map> watched = await db.rawQuery("SELECT * FROM watched");
    return watched.map<int>((entry) => entry['id']).toList();
  }
  
  static dropWatchedMovie(int id) async {
    db.rawDelete("DELETE FROM watched WHERE id = $id");
  }

  static dropToWatchMovie(int id) async {
    db.rawDelete("DELETE FROM toWatch WHERE id = $id");
  }

  static Future<List<int>> watchList() async {
    List<Map> watchList = await db.rawQuery("SELECT * FROM toWatch");
    return watchList.map<int>((entry) => entry['id']).toList();
  }

  static closeDatabase() async {
    await db.close();
  }

}