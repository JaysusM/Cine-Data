import 'package:flutter/material.dart';
import 'movie.dart';
import 'searcher.dart';
import 'dart:convert';
import 'package:flutter/services.dart';
import 'loaded_content.dart';
import 'watchlist_manager.dart';

class InfoPage extends StatefulWidget {
  Movie movie;

  InfoPage(this.movie);

  @override
  State<StatefulWidget> createState() => new InfoPageState();
}

class InfoPageState extends State<InfoPage> {
  Searcher searcher = new Searcher();
  MovieFull fullMovie;
  bool openPoster;
  Color color;
  IconData icon;

  InfoPageState() {
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    openPoster = false;
  }

  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
          title: new Text(widget.movie.title,
              style: new TextStyle(
                  fontFamily: 'Muli', fontWeight: FontWeight.bold))),
      body: (!openPoster)
          ? new SingleChildScrollView(
              child: new Stack(children: <Widget>[
              (fullMovie == null)
                  ? new FutureBuilder(
                      builder: (BuildContext context, AsyncSnapshot response) {
                        switch (response.connectionState) {
                          case ConnectionState.waiting:
                            return new Center(
                                child: new Image(
                                    image:
                                        new AssetImage("assets/loading.gif")));
                          case ConnectionState.none:
                            return new Container();
                          default:
                            if (response.hasError)
                              return new Text("Error");
                            else {
                              fullMovie =
                                  new MovieFull(jsonDecode(response.data));
                              return _buildPage();
                            }
                        }
                      },
                      future: searcher.searchById(widget.movie.id.toString()))
                  : _buildPage(),
              new GestureDetector(
                child: new Container(
                  child: new Hero(
                      tag: widget.movie.id,
                      child: new Material(
                        child: new FadeInImage(
                          fit: BoxFit.fitHeight,
                          placeholder:
                              new AssetImage("assets/loadingCircle.gif"),
                          image: new NetworkImage(widget.movie.getPosterUrl()),
                        ),
                        borderRadius: new BorderRadius.circular(13.0),
                        elevation: 7.0,
                      )),
                  height: MediaQuery.of(context).size.height * 0.3,
                  margin: new EdgeInsets.only(left: 15.0, top: 60.0),
                ),
                onTap: () {
                  this.setState(() {
                    openPoster = true;
                  });
                },
              ),
            ]))
          : new GestureDetector(
              child: new Container(
                child: new Material(
                  child: new Hero(
                    tag: widget.movie.id,
                    child: new Image(
                        image: new NetworkImage(
                            MovieFull.getImage(widget.movie.poster_path)),
                        fit: BoxFit.fitWidth),
                  ),
                  elevation: 5.0,
                  borderRadius: new BorderRadius.all(new Radius.circular(15.0)),
                ),
                margin: new EdgeInsets.all(15.0),
              ),
              onTap: () {
                this.setState(() {
                  openPoster = false;
                });
              },
            ),
    );
  }

  IconData _setRating(double rating) {
    double difference = fullMovie.vote_average - rating;

    if (difference < -1)
      return Icons.star_border;
    else if (difference >= 0)
      return Icons.star;
    else
      return Icons.star_half;
  }

  Color _setRatingColor() {
    double rating = fullMovie.vote_average;

    if (rating < 2)
      return Colors.red;
    else if (rating < 4)
      return Colors.deepOrange;
    else if (rating < 6)
      return Colors.yellow;
    else if (rating < 8)
      return Colors.lightGreenAccent;
    else
      return Colors.green;
  }

  Widget _getContentOverview() {
    return new Column(
      children: <Widget>[
        new Divider(),
        new Container(
            child: new Text("▶ GENRES",
                style: new TextStyle(
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Muli',
                    fontSize: 20.0)),
            alignment: Alignment.centerLeft,
            margin: new EdgeInsets.only(top: 5.0, left: 15.0, bottom: 7.5)),
        new Row(
            children: fullMovie.genres
                .map((genre) => new Container(
                      child: new Chip(
                        label: new Text(
                          genre,
                          style: new TextStyle(
                            fontFamily: 'Muli',
                          ),
                        ),
                        backgroundColor: Theme.of(context).accentColor,
                        avatar: new Container(
                          child: new Image(
                              image: new AssetImage("assets/$genre.png")),
                          margin: new EdgeInsets.all(3.0),
                        ),
                      ),
                      margin: new EdgeInsets.symmetric(horizontal: 5.0),
                    ))
                .toList()
                .sublist(min(0, fullMovie.genres.length),
                    min(fullMovie.genres.length, 3)),
            mainAxisAlignment: MainAxisAlignment.center),
        new Container(
          height: 15.0,
        ),
        (fullMovie.genres.length > 4)
            ? new Row(
                children: fullMovie.genres
                    .map((genre) => new Container(
                          child: new Chip(
                            label: new Text(genre,
                                style: new TextStyle(
                                  fontFamily: 'Muli',
                                )),
                            backgroundColor: Theme.of(context).accentColor,
                            avatar: new Container(
                              child: new Image(
                                  image: new AssetImage("assets/$genre.png")),
                              margin: new EdgeInsets.all(3.0),
                            ),
                          ),
                          margin: new EdgeInsets.symmetric(horizontal: 5.0),
                        ))
                    .toList()
                    .sublist(3, min(fullMovie.genres.length, 6)),
                mainAxisAlignment: MainAxisAlignment.center)
            : new Container(),
        new Divider(),
        new Container(
            child: new Text("▶ OVERVIEW",
                style: new TextStyle(
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Muli',
                    fontSize: 20.0)),
            alignment: Alignment.centerLeft,
            margin: new EdgeInsets.only(top: 5.0, left: 15.0, bottom: 7.5)),
        new Container(
          child: new Text(fullMovie.overview,
              style: new TextStyle(fontSize: 16.0, fontFamily: 'Muli')),
          alignment: Alignment.centerLeft,
          margin: new EdgeInsets.symmetric(horizontal: 15.0),
          padding: new EdgeInsets.only(bottom: 25.0),
        )
      ],
    );
  }

  int min(int x, int y) {
    if (x < y)
      return x;
    else
      return y;
  }

  Widget _buildPage() {

    if(LoadedContent.watchedMovies.any((movie) => movie.id == fullMovie.id)) {
      fullMovie.setWatched(true);
      color = Colors.green;
      icon = Icons.check_circle;
    } else if (LoadedContent.toWatchMovies.any((movie) => movie.id == fullMovie.id)) {
      fullMovie.setToWatch(true);
      color = Colors.blue;
      icon = Icons.remove_red_eye;
    } else {
      color = Colors.blueGrey;
      icon = Icons.clear;
    }

    return new Column(
      children: <Widget>[
        new Stack(
          children: <Widget>[
            new Container(
              child: new Material(
                child: new FadeInImage(
                    image: new NetworkImage(
                        MovieFull.getImage(fullMovie.backdrop_path)),
                    placeholder: new NetworkImage(
                      MovieFull.getImage(fullMovie.poster_path),
                    ),
                    fit: BoxFit.cover),
                borderRadius: new BorderRadius.vertical(
                    bottom: new Radius.elliptical(1000.0, 150.0)),
                elevation: 5.0,
              ),
              height: MediaQuery.of(context).size.height * 0.32,
              width: MediaQuery.of(context).size.width,
            ),
            new Positioned(
              child: (fullMovie.production_companies.length > 0)
                  ? new Container(
                      child: new Image(
                          fit: BoxFit.fitHeight,
                          image: new NetworkImage(MovieFull.getImage(
                              fullMovie.production_companies[0].logo_path))),
                      height: 25.0,
                      margin: new EdgeInsets.only(top: 15.0, right: 15.0),
                    )
                  : new Container(),
              right: 0.0,
              top: 0.0,
            )
          ],
        ),
        new Stack(
          children: <Widget>[
            new Positioned(
              child: new Container(
                child: new Text(
                    " ${(fullMovie.runtime != null)
                        ? fullMovie.runtime
                        : "~~"} MIN\b",
                    style: new TextStyle(
                        fontSize: 13.0, fontWeight: FontWeight.bold)),
                decoration: new BoxDecoration(
                    border: new Border.all(
                        color: Theme.of(context).primaryColor, width: 3.0),
                    borderRadius: new BorderRadius.circular(7.0)),
                margin: new EdgeInsets.only(top: 15.0, left: 5.0),
              ),
            ),
            new Positioned(
              child: new Container(
                child: new Text("\b${fullMovie
                    .release_date}    (${fullMovie
                    .original_language
                    .toUpperCase()})\b"),
              ),
              left: 75.0,
              top: 17.7,
            ),
          ],
          overflow: Overflow.visible,
        ),
        new Container(
          child: new Row(
            children: <Widget>[
              new Container(child: new Material(child: new MaterialButton(onPressed: () {
                this.setState(() {
                  _checkButton();
                });
              }, child: new Icon(icon, color: Colors.white),
                splashColor: Colors.black,
              ),
                shape: BeveledRectangleBorder(
                  side: BorderSide(color: Theme.of(context).primaryColor,
                  width: 1.0
                  ),
                  borderRadius: new BorderRadius.only(bottomRight: Radius.circular(15.0),
                  topLeft: Radius.circular(15.0)),
                ),
                color: color,
                shadowColor: Colors.black,
                elevation: 8.0,
              ),
              height: 40.0,
                width: 60.0,
              ),
              new Container(width: 15.0),
              new Row(
                children: <Widget>[
                  new Icon(_setRating(2.0),
                      size: 35.0, color: Theme.of(context).accentColor),
                  new Icon(_setRating(4.0),
                      size: 35.0, color: Theme.of(context).accentColor),
                  new Icon(_setRating(6.0),
                      size: 35.0, color: Theme.of(context).accentColor),
                  new Icon(_setRating(8.0),
                      size: 35.0, color: Theme.of(context).accentColor),
                  new Icon(_setRating(10.0),
                      size: 35.0, color: Theme.of(context).accentColor),
                ],
              ),
              new Container(
                width: 20.0,
              ),
              new CircleAvatar(
                child: new Text(
                  "${fullMovie.vote_average}",
                  style: new TextStyle(fontSize: 18.0),
                ),
                foregroundColor: Theme.of(context).primaryColor,
                backgroundColor: _setRatingColor(),
              )
            ],
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
          ),
          margin: new EdgeInsets.only(top: 25.0, left: 15.0),
        ),
        _getContentOverview()
      ],
    );
  }
  
  void _checkButton() {
    if(fullMovie.watched()) {
      fullMovie.setWatched(false);
      color = Colors.blueGrey;
      icon = Icons.remove_red_eye;

      Watchlist.dropWatchedMovie(fullMovie.id);
      fullMovie.setToWatch(false);
      LoadedContent.watchedMovies.removeWhere((movie) => movie.id == fullMovie.id);

    } else if(fullMovie.toWatch()) {
      fullMovie.setToWatch(false);
      fullMovie.setWatched(true);
      color = Colors.green;
      icon = Icons.check_circle;

      Watchlist.dropToWatchMovie(fullMovie.id);
      LoadedContent.toWatchMovies.removeWhere((movie) => movie.id == fullMovie.id);

      Watchlist.addWatchedMovie(new Movie.elemental(fullMovie.id, fullMovie.title, fullMovie.vote_average, fullMovie.poster_path));
      LoadedContent.watchedMovies.add(new Movie.elemental(fullMovie.id, fullMovie.title, fullMovie.vote_average, fullMovie.poster_path));

    } else {
      fullMovie.setToWatch(true);
      color = Colors.blue;
      icon = Icons.clear;

      Watchlist.addToWatchMovie(new Movie.elemental(fullMovie.id, fullMovie.title, fullMovie.vote_average, fullMovie.poster_path));
      LoadedContent.toWatchMovies.add(new Movie.elemental(fullMovie.id, fullMovie.title, fullMovie.vote_average, fullMovie.poster_path));
    }
  }
  
}
