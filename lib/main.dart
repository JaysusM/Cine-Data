import 'package:flutter/material.dart';
import 'search_bar.dart';
import 'movie_box.dart';
import 'searcher.dart';
import 'popular_movies.dart';
import 'movie.dart';
import 'dart:convert';
import 'watchlist.dart';

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
        "/search": (BuildContext context) => new SearchScreen()
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
        drawer: new Drawer(),
        appBar: new AppBar(
          title: new Text("Popular Movies", style: new TextStyle(fontWeight: FontWeight.bold, fontFamily: 'Muli')),
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
  bool isEmpty = true;

  SearchScreenState() {
    searchBar = new SearchBar();
    searcher = new Searcher();
    movies = new List();
    searchBar.controller.addListener(() async {
      isEmpty = (searchBar.controller.text == "");

      if (isEmpty) return;

      if (titleFilter != searchBar.controller.text) {
        this.setState(() {
          titleFilter = searchBar.controller.text;
          isSearching = true;
        });
        List<Movie> aux = jsonDecode(
                await searcher.searchByTitle(titleFilter).whenComplete(() {
          this.setState(() {
            isSearching = false;
          });
        }))['results']
            .map<Movie>((movie) => new Movie(movie))
            .toList();
        aux.forEach((movie) => PopularMoviesWidgetState.checkWatched(movie));
        movies = aux.map<Widget>((movie) => new MovieBox(movie)).toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    Orientation orientation = MediaQuery.of(context).orientation;


    return new Scaffold(
      appBar: new AppBar(
        title: searchBar,
        actions: <Widget>[
          new IconButton(
              icon: new Icon(Icons.clear),
              onPressed: () {
                this.setState(() {
                  searchBar.controller.clear();
                });
              })
        ],
      ),
      body: (!isEmpty)
          ? (!isSearching)
              ? new GridView.count(
                  crossAxisCount: (orientation == Orientation.portrait) ? 2 : 3,
                  crossAxisSpacing: 5.0,
                  mainAxisSpacing: 5.0,
                  childAspectRatio: 0.7,
                  children: movies,
                )
              : new Center(
                  child: new Column(
                  children: <Widget>[
                    new Text("Searching movies...",
                        style: new TextStyle(fontSize: 17.0)),
                    new Image(image: new AssetImage("assets/loading.gif")),
                  ],
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                ))
          : new Column(
              children: <Widget>[
                new Image(image: new AssetImage("assets/search.png")),
                new Text(
                  "Type any keyword to search a movie",
                  style: new TextStyle(fontSize: 20.0, fontFamily: 'Muli', fontWeight: FontWeight.bold),
                )
              ],
              crossAxisAlignment: CrossAxisAlignment.center,
            ),
      resizeToAvoidBottomPadding: false,
    );
  }
}
