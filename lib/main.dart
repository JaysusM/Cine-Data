import 'package:flutter/material.dart';
import 'search_bar.dart';
import 'movie_box.dart';
import 'movie.dart';
import 'searcher.dart';
import 'dart:async';
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
      routes: <String, WidgetBuilder> {
        "/search" : (BuildContext context) => new SearchScreen()
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
        title: new Text("Home"),
        actions: <Widget>[
          new IconButton(icon: new Icon(Icons.search), onPressed: () {
            Navigator.of(context).pushNamed("/search");
          })
        ],
      ),
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

  SearchScreenState() {
    searchBar = new SearchBar();
    searcher = new Searcher();
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
      body: new ListView(
        children: searchBar.movies.map((movie) => new MovieBox(movie)).toList(),
      ),
    );
  }
}
