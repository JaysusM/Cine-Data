import 'package:flutter/material.dart';
import 'search_bar.dart';
import 'movie_box.dart';
import 'searcher.dart';
import 'popular_movies.dart';
import 'movie.dart';
import 'dart:convert';

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Cine Data',
      theme: new ThemeData(
          brightness: Brightness.light,
          primaryColor: const Color(0xFF020122),
          accentColor: const Color(0xFFff521b)
      ),
      routes: <String, WidgetBuilder>{
        "/search": (BuildContext context) => new SearchScreen()
      },
      home: new MainScreen(),
    );
  }
}

class MainScreen extends StatelessWidget {
  Widget build(BuildContext context) {
    return new Scaffold(
      drawer: new Drawer(),
      appBar: new AppBar(
        title: new Text("Popular Movies"),
        actions: <Widget>[
          new IconButton(icon: new Icon(Icons.search), onPressed: () {
            Navigator.of(context).pushNamed("/search");
          })
        ],
      ),
      body: new PopularMoviesWidget(),
    );
  }
}

class SearchScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => new SearchScreenState();
}

class SearchScreenState extends State {
  SearchBar searchBar;
  Searcher searcher;
  List<Widget> movies;
  String titleFilter = "";
  bool isSearching = false;

  SearchScreenState() {
    searchBar = new SearchBar();
    searcher = new Searcher();
    movies = new List();
    searchBar.controller.addListener(() async {
      if(titleFilter != searchBar.controller.text) {
        this.setState(() {
          titleFilter = searchBar.controller.text;
          isSearching = true;
        });
        movies =
            jsonDecode(
                await searcher.searchByTitle(titleFilter).whenComplete(() {
                  this.setState(
                          () {
                        isSearching = false;
                      }
                  );
                }
                ))['results'].map<Widget>((movie) =>
            new MovieBox(new Movie(movie))).toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: searchBar,
        actions: <Widget>[
          new IconButton(
              icon: new Icon(Icons.clear),
              onPressed: () {
                searchBar.controller.clear();
              })
        ],
      ),
      body:
        (!isSearching) ? new GridView.count(
          crossAxisCount: 2,
          crossAxisSpacing: 5.0,
          mainAxisSpacing: 5.0,
          children: movies
      ) :
        new Text("Searching movies, wait..."),
    );
  }
}
