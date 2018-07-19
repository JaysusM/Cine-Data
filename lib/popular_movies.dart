import 'package:flutter/material.dart';
import 'searcher.dart';
import 'dart:convert';
import 'movie.dart';
import 'movie_box.dart';
import 'watchlist_manager.dart';
import 'dart:async';

class PopularMoviesWidget extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => new PopularMoviesWidgetState();
}

class PopularMoviesWidgetState extends State<PopularMoviesWidget> {
  Searcher searcher = new Searcher();
  List<Movie> movies;
  ScrollController controller = new ScrollController();
  int pageCounter = 1;
  bool isLoadingContent = false;
  static List<int> watched;
  static List<int> toWatch;

  Widget build(BuildContext context) {
    Orientation orientation = MediaQuery.of(context).orientation;
    List<Movie> loadingContent;
    double offset;
    
    controller.addListener(() async {
      if (controller.position.maxScrollExtent == controller.offset &&
          !isLoadingContent) {
        offset = controller.offset;
        pageCounter++;
        isLoadingContent = true;
        await searcher.searchPopular(page: pageCounter).then((content) {
            loadingContent = jsonDecode(content)['results']
                .map<Movie>((movie) => new Movie(movie))
                .toList();
            isLoadingContent = false;
            loadingContent.forEach((movie) => checkWatchlist(movie));
        }).whenComplete(() {
          this.setState((){
            movies.addAll(loadingContent);
            controller.jumpTo(offset);
          });});
      }
    });

    return new Container(
      child: (movies == null)
          ? new FutureBuilder(
              builder: (BuildContext context, AsyncSnapshot response) {
                switch (response.connectionState) {
                  case ConnectionState.waiting:
                    return new Center(
                        child: new Column(
                      children: <Widget>[
                        new Text("Awaiting results...",
                            style: new TextStyle(fontSize: 17.0)),
                        new Image(image: new AssetImage("assets/loading.gif")),
                      ],
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                    ));
                    break;
                  case ConnectionState.none:
                    return new Container();
                    break;
                  default:
                    if (response.hasError)
                      return new Text("Error: ${response.error}");
                    else {
                      movies = jsonDecode(response.data[1])['results']
                          .map<Movie>((movie) => new Movie(movie))
                          .toList();
                      watched = response.data[0];
                      toWatch = response.data[2];
                      movies.forEach((movie) => checkWatchlist(movie));
                      return getGridView(movies, orientation);
                    }
                }
              },
              future: initializeContent())
          : getGridView(movies, orientation),
      margin: new EdgeInsets.all(5.0),
    );
  }

  Widget getGridView(List<Movie> movies, Orientation orientation) {
    return new GridView.count(
      children: movies.map((movie) => new MovieBox(checkWatchlist(movie))).toList(),
      crossAxisCount: (orientation == Orientation.portrait) ? 2 : 3,
      crossAxisSpacing: 8.0,
      mainAxisSpacing: 8.0,
      childAspectRatio: 0.7,
      controller: controller,
    );
  }
  
  static Movie checkWatchlist(Movie movie) {
    if(watched.contains(movie.id))
      movie.setWatched(true);
    else if(toWatch.contains((movie.id)))
      movie.setToWatch(true);
    else {
      movie.setToWatch(false);
      movie.setWatched(false);
    }
    return movie;
  }

  Future<List> initializeContent() async {
    List content = new List();
    content.add(await Watchlist.watchedList());
    content.add(await searcher.searchPopular());
    content.add(await Watchlist.watchList());
    return content;
  }
}
