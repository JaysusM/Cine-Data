import 'package:flutter/material.dart';
import 'popular_movies.dart';
import 'watchlist_manager.dart';
import 'search_screen.dart';
import 'watched_screen.dart';

void main() async {
  await Watchlist.initDatabase();
  runApp(new MyApp());
}

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Cine Data',
      theme: new ThemeData(
          brightness: Brightness.light,
          primaryColor: const Color(0xFF020122),
          accentColor: const Color(0xFFff521b)),
      routes: <String, WidgetBuilder>{
        "/search": (BuildContext context) => new SearchScreen(),
        "/watched": (BuildContext context) => new WatchlistScreen(true),
        "/toWatch": (BuildContext context) => new WatchlistScreen(false)
      },
      home: new MainScreen(),
    );
  }
}

class MainScreen extends StatelessWidget {
  Widget popularMovies;

  MainScreen() {
    popularMovies = new PopularMoviesWidget();
  }

  Widget build(BuildContext context) {
    return new Scaffold(
        drawer: new Drawer(
            child: new ListView(
              children: <Widget>[
                new ListTile(title: new Text("MENU", style: new TextStyle(fontFamily: 'Muli', fontWeight: FontWeight.bold, fontSize: 20.0)),
                leading: new Icon(Icons.menu)),
                menuEntryTile(context, "/watched", "Watched Movies"),
                menuEntryTile(context, "/toWatch", "To Watch Movies"),
                menuEntryTile(context, "/search", "Search by title")
              ],
            ),
          elevation: 15.0,
        ),
        appBar: new AppBar(
          title: new Text("Popular Movies", style: new TextStyle(
              fontWeight: FontWeight.bold, fontFamily: 'Muli')),
          actions: <Widget>[
            new IconButton(
                icon: new Icon(Icons.search),
                onPressed: () {
                  Navigator.of(context).pushNamed("/search");
                })
          ],
        ),
        body: popularMovies
    );
  }
  
  Widget menuEntryTile(BuildContext context, String routeName, String tabName) {
    return new GestureDetector(
        child: new ListTile(title: new Text(tabName, style: new TextStyle(fontFamily: 'Muli')),
        leading: new Icon(Icons.movie, size: 15.0,),
        ), onTap: () {
      Navigator.of(context).pushNamed(routeName);
    });
  }
  
}