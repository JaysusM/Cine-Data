import 'package:flutter/material.dart';
import 'searcher.dart';
import 'movie.dart';
import 'dart:async';
import 'dart:convert';
import 'dictionary.dart';
import 'grid_movie_screen.dart';

class GenreScreen extends StatefulWidget {
  @override
  createState() => new GenreScreenState();
}

class GenreScreenState extends State {
  Searcher searcher = new Searcher();
  List<Movie> movies;
  ScrollController controller = new ScrollController();
  int pageCounter = 1;
  bool isLoadingContent = false;
  Dictionary genres = new Dictionary();

  Widget build(BuildContext context) {
    return new Container(
      child: (genres.keys.length == 0)
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
                  return new ListView(
                    children: genres.nodes.map((node) => getListTile(node.key)).toList()
                  );
                }
            }
          },
          future: initializeContent())
          : new ListView(children: genres.nodes.map((node) => getListTile(node.key)).toList()),
      margin: new EdgeInsets.all(5.0),
    );
  }

  Widget getListTile(String value) {

    return new GestureDetector(child: new Container(child: new ListTile(
      title: new Text(value, style: new TextStyle(fontFamily: 'Muli')),
      leading: new Image(image: new AssetImage((value == 'Science Fiction') ? "assets/Sci-Fi.png" : "assets/$value.png"),
        height: 20.0,
        width: 20.0,
    )),
    decoration: new BoxDecoration(border: new Border(bottom: new BorderSide(color: Theme.of(context).accentColor, width: 0.2))),
    ),
      onTap: () {

          Navigator.of(context).push(new MaterialPageRoute(builder: (BuildContext context) {
            return new Scaffold(
              appBar: new AppBar(
                title: new Text(value, style: new TextStyle(fontFamily: 'Muli', fontWeight: FontWeight.bold)),
              ),
              body: new FutureBuilder(builder: (BuildContext context, AsyncSnapshot response) {
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
                      movies = jsonDecode(response.data)['results'].map<Movie>((movie) => new Movie(movie)).toList();
                      return new GridMovieScreen(movies, controller);
                    }
                }
              }, future: searcher.searchByGenre(genres.getValue(value))),
            );
          }));
      },
    );

  }
  
  Future initializeContent() async {
    List genres = jsonDecode(await searcher.getGenres())['genres'];
    genres.forEach((genre) => this.genres.add(genre['name'], genre['id']));
    return new Future<Null>.value();
  }
}