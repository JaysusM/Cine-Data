import 'package:flutter/material.dart';
import 'movie.dart';
import 'searcher.dart';
import 'dart:convert';
import 'package:flutter/services.dart';

class InfoPage extends StatelessWidget {
  Movie movie;
  Searcher searcher = new Searcher();
  MovieFull fullMovie;

  InfoPage(this.movie) {
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  }

  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: new AppBar(title: new Text(movie.title)),
        body: new SingleChildScrollView(
            child: new Stack(children: <Widget>[
          new FutureBuilder(
              builder: (BuildContext context, AsyncSnapshot response) {
                switch (response.connectionState) {
                  case ConnectionState.waiting:
                    return new Center(
                        child: new Image(
                            image: new AssetImage("assets/loading.gif")));
                  case ConnectionState.none:
                    return new Container();
                  default:
                    if (response.hasError)
                      return new Text("Error");
                    else {
                      fullMovie = new MovieFull(jsonDecode(response.data));
                      return new Column(
                        children: <Widget>[
                          new Stack(
                            children: <Widget>[
                              new Container(
                                child: new Material(
                                  child: new Image(
                                      image: new NetworkImage(fullMovie
                                          .getImage(fullMovie.backdrop_path))),
                                  borderRadius: new BorderRadius.vertical(
                                      bottom:
                                          new Radius.elliptical(1000.0, 150.0)),
                                  elevation: 5.0,
                                ),
                                width: MediaQuery.of(context).size.width,
                              ),
                              new Positioned(
                                child:
                                    (fullMovie.production_companies.length > 0)
                                        ? new Container(
                                            child: new Image(
                                                fit: BoxFit.fitHeight,
                                                image: new NetworkImage(
                                                    fullMovie.getImage(fullMovie
                                                        .production_companies[0]
                                                        .logo_path))),
                                            height: 25.0,
                                            margin: new EdgeInsets.only(
                                                top: 15.0, right: 15.0),
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
                                  child: new Text(" ${fullMovie.runtime} MIN\b",
                                      style: new TextStyle(
                                          fontSize: 13.0,
                                          fontWeight: FontWeight.bold)),
                                  decoration: new BoxDecoration(
                                      border: new Border.all(
                                          color: Theme.of(context).primaryColor,
                                          width: 3.0),
                                      borderRadius:
                                          new BorderRadius.circular(7.0)),
                                  margin: new EdgeInsets.only(top: 15.0, left: 15.0),
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
                              )
                            ],
                            overflow: Overflow.visible,
                          ),
                          new Container(
                            child: new Row(
                              children: <Widget>[
                                new Row(
                                  children: <Widget>[
                                    new Icon(_setRating(2.0),
                                        size: 35.0,
                                        color: Theme.of(context).accentColor),
                                    new Icon(_setRating(4.0),
                                        size: 35.0,
                                        color: Theme.of(context).accentColor),
                                    new Icon(_setRating(6.0),
                                        size: 35.0,
                                        color: Theme.of(context).accentColor),
                                    new Icon(_setRating(8.0),
                                        size: 35.0,
                                        color: Theme.of(context).accentColor),
                                    new Icon(_setRating(10.0),
                                        size: 35.0,
                                        color: Theme.of(context).accentColor),
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
                                  foregroundColor:
                                      Theme.of(context).primaryColor,
                                  backgroundColor: _setRatingColor(),
                                )
                              ],
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                            ),
                            margin: new EdgeInsets.only(top: 15.0, left: 15.0),
                          ),
                          _getContentOverview()
                        ],
                      );
                    }
                }
              },
              future: searcher.searchById(movie.id.toString())),
          new Container(
            child: new Hero(
                tag: movie.id,
                child: new Material(
                  child: new FadeInImage(
                    fit: BoxFit.fitHeight,
                    placeholder: new AssetImage("assets/loadingCircle.gif"),
                    image: new NetworkImage(movie.getPosterUrl()),
                  ),
                  borderRadius: new BorderRadius.circular(13.0),
                  elevation: 7.0,
                )),
            height: MediaQuery.of(context).size.height * 0.3,
            margin: new EdgeInsets.only(left: 15.0, top: 60.0),
          ),
        ])));
  }

  IconData _setRating(double rating) {
    double difference = fullMovie.vote_average - rating;

    if (difference < -1)
      return Icons.star_border;
    else if (difference > 0)
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
      return Colors.lightGreen;
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
                style:
                    new TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0)),
            alignment: Alignment.centerLeft,
            margin: new EdgeInsets.only(top: 5.0, left: 15.0, bottom: 7.5)),
        new Row(
            children: fullMovie.genres
                .map((genre) => new Container(
                      child: new Chip(label: new Text(genre)),
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
                          child: new Chip(label: new Text(genre)),
                          margin: new EdgeInsets.symmetric(horizontal: 5.0),
                        ))
                    .toList()
                    .sublist(3, min(fullMovie.genres.length, 6)),
                mainAxisAlignment: MainAxisAlignment.center)
            : new Container(),
        new Divider(),
        new Container(
            child: new Text("▶ OVERVIEW",
                style:
                    new TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0)),
            alignment: Alignment.centerLeft,
            margin: new EdgeInsets.only(top: 5.0, left: 15.0, bottom: 7.5)),
        new Container(
          child: new Text(fullMovie.overview,
              style: new TextStyle(fontSize: 16.0)),
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
}
