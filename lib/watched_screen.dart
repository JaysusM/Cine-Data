import 'package:flutter/material.dart';
import 'movie.dart';
import 'searcher.dart';
import 'dart:convert';
import 'dart:async';
import 'movie_box.dart';
import 'popular_movies.dart';

class WatchlistScreen extends StatefulWidget {

  bool isWatched;

  WatchlistScreen(this.isWatched);

  @override
  State<StatefulWidget> createState() => new WatchlistScreenState();
}

class WatchlistScreenState extends State<WatchlistScreen> {

  List<Movie> movies;

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text((widget.isWatched) ? "Watched Movies" : "To Watch Movies", style: new TextStyle(fontFamily: 'Muli', fontWeight: FontWeight.bold)),
      ),
      body: (movies == null) ? new FutureBuilder(builder: (BuildContext context, AsyncSnapshot response) {
        switch(response.connectionState) {
          case ConnectionState.waiting:
            return new Center(child: new Image(image: new AssetImage("assets/loading.gif")));
            break;
          case ConnectionState.none:
            return new Container();
            break;
          default:
            if(response.hasError)
              return new Text("Error");
            else {
              movies = response.data;
              return showGrid();
            }
        }
      },
      future: loadContent(),
      ) : showGrid(),
    );
  }

  Widget showGrid() {
    return new Container(child: new GridView.count(
      children: movies.map<Widget>((movie) => new MovieBox(movie)).toList(),
      crossAxisCount: 2,
      crossAxisSpacing: 8.0,
      mainAxisSpacing: 8.0,
      childAspectRatio: 0.7,
    ),
    margin: new EdgeInsets.all(8.0),
    );
  }

  Future loadContent() async {
    Searcher searcher = new Searcher();
    List<Movie> movies = new List();
    int lim = (widget.isWatched) ? PopularMoviesWidgetState.watched.length : PopularMoviesWidgetState.toWatch.length;
    for(int i = 0; i < lim; i++) {
      if(widget.isWatched) {
        String movieContent = await searcher.searchById(
            PopularMoviesWidgetState.watched[i].toString());
        movies.add(new Movie(jsonDecode(movieContent))..setWatched(true));
      } else {
        String movieContent = await searcher.searchById(
            PopularMoviesWidgetState.toWatch[i].toString());
        movies.add(new Movie(jsonDecode(movieContent))..setToWatch(true));
      }
    }
    return movies;
  }

}