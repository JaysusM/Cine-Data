import 'package:flutter/material.dart';
import 'searcher.dart';
import 'movie.dart';
import 'dart:async';
import 'dart:convert';

class SearchBar extends StatefulWidget {
  TextEditingController controller;
  Searcher searcher;
  List<Movie> movies;

  SearchBar() {
    controller = new TextEditingController();
    searcher = new Searcher();
    movies = new List();
  }

  @override
  State<StatefulWidget> createState() => new SearchBarState();
}

class SearchBarState extends State<SearchBar> {

  void getMovies(String content) async {
    List<Movie> results = new List();
    List decoder = jsonDecode(await widget.searcher.searchByTitle(content))["Search"];

    decoder.forEach((movie) {
      results.add(new Movie(movie["Title"], movie["Year"], movie["imdbID"], movie["Type"], movie["Poster"]));
    });

    widget.movies = results;
  }

  Widget build(BuildContext context) {
    return new Container(
      child: new TextField(
        controller: widget.controller,
        decoration: new InputDecoration(
          hintText: "Filter by title",
          contentPadding: new EdgeInsets.all(10.0)
        ),
        onSubmitted: getMovies,
      ),
      decoration: new BoxDecoration(
        borderRadius: new BorderRadius.circular(14.5),
        color: Colors.white
      ),
    );
  }
}
