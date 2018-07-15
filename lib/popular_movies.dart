import 'package:flutter/material.dart';
import 'searcher.dart';
import 'dart:convert';
import 'movie.dart';
import 'movie_box.dart';

class PopularMoviesWidget extends StatelessWidget {
  Searcher searcher = new Searcher();

  Widget build(BuildContext context) {
    Orientation orientation = MediaQuery.of(context).orientation;

    return new Container(
      child: new FutureBuilder(
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
                else
                  return new GridView.count(
                    children: jsonDecode(response.data)['results']
                        .map((movie) => new Movie(movie))
                        .map<Widget>((movie) => new MovieBox(movie))
                        .toList(),
                    crossAxisCount:
                        (orientation == Orientation.portrait) ? 2 : 3,
                    crossAxisSpacing: 8.0,
                    mainAxisSpacing: 8.0,
                    childAspectRatio: 0.7,
                  );
            }
          },
          future: searcher.searchPopular()),
      margin: new EdgeInsets.all(5.0),
    );
  }
}
