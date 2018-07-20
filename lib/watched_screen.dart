import 'package:flutter/material.dart';
import 'movie.dart';
import 'dart:async';
import 'movie_box.dart';
import 'loaded_content.dart';

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
    return new Container(child: (movies.isNotEmpty) ? new GridView.count(
      children: movies.map<Widget>((movie) => new MovieBox(movie)).toList(),
      crossAxisCount: 2,
      crossAxisSpacing: 8.0,
      mainAxisSpacing: 8.0,
      childAspectRatio: 0.7,
    ) :
          new Center(
            child: new Text("It's lonely here,\n you should try adding something...",
            style: new TextStyle(fontFamily: 'Muli'), textAlign: TextAlign.center,
            )
          ),
    margin: new EdgeInsets.all(8.0),
    );
  }

  Future loadContent() async {
    List<Movie> movies = new List();
    int lim = (widget.isWatched) ? LoadedContent.watchedMovies.length : LoadedContent.toWatchMovies.length;
    for(int i = 0; i < lim; i++) {
      if(widget.isWatched) {
        movies.add(LoadedContent.watchedMovies[i]..setWatched(true));
      } else {
        movies.add(LoadedContent.toWatchMovies[i]..setToWatch(true));
      }
    }
    return movies;
  }

}