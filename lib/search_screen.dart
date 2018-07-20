import 'package:flutter/material.dart';
import 'searcher.dart';
import 'search_bar.dart';
import 'grid_movie_screen.dart';
import 'dart:convert';
import 'movie_box.dart';
import 'movie.dart';

class SearchScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => new SearchScreenState();
}

class SearchScreenState extends State {
  SearchBar searchBar;
  Searcher searcher;
  List<Movie> movies;
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
        aux.forEach((movie) => GridMovieScreen.checkWatchlist(movie));
        movies = aux;
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
                this.setState(() {
                  searchBar.controller.clear();
                });
              })
        ],
      ),
      body: (!isEmpty)
          ? (!isSearching)
          ? new GridMovieScreen(movies, new ScrollController())
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
          : new Center(child: new Text(
            "Type any keyword to search a movie",
            style: new TextStyle(fontSize: 14.0, fontFamily: 'Muli'),
          )
      ),
      resizeToAvoidBottomPadding: false,
    );
  }
}
