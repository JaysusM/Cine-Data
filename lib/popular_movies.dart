import 'package:flutter/material.dart';
import 'searcher.dart';
import 'dart:convert';
import 'movie.dart';
import 'movie_box.dart';

class PopularMoviesWidget extends StatelessWidget {
  Searcher searcher = new Searcher();

  Widget build(BuildContext context) {
    return new Container(
        child: new FutureBuilder(
            builder: (BuildContext context, AsyncSnapshot response) {
              switch(response.connectionState) {
                case ConnectionState.waiting:
                  return new Text("Awaiting results...");
                  break;
                case ConnectionState.none:
                  return new Container();
                  break;
                default:
                  if(response.hasError)
                    return new Text("Error: ${response.error}");
                  else
                    return new GridView.count(
                      children: jsonDecode(response.data)['results'].map((movie) => new Movie(movie)).map<Widget>((movie) => new MovieBox(movie)).toList(),
                      crossAxisCount: 2,
                      crossAxisSpacing: 5.0,
                      mainAxisSpacing: 5.0
                    );
              }
            },
            future: searcher.searchPopular()),
            margin: new EdgeInsets.all(5.0),
          
    );
  }
}
