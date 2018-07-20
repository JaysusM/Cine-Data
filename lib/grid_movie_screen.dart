import 'package:flutter/material.dart';
import 'movie_box.dart';
import 'movie.dart';
import 'loaded_content.dart';

class GridMovieScreen extends StatelessWidget {

  List<Movie> movies;
  ScrollController controller;

  GridMovieScreen(this.movies, this.controller);

  Widget build(BuildContext context) {
    return new Container(child: new GridView.count(
      children: movies.map((movie) => new MovieBox(checkWatchlist(movie)))
          .toList(),
      crossAxisCount: 2,
      crossAxisSpacing: 8.0,
      mainAxisSpacing: 8.0,
      childAspectRatio: 0.7,
      controller: controller,
    ),
      margin: new EdgeInsets.all(8.0),
    );
  }

  static Movie checkWatchlist(Movie movie) {
    if (LoadedContent.toWatchMovies.any((x) => x.id == movie.id)) {
      movie.setWatched(true);
      movie.setToWatch(false);
    } else if (LoadedContent.toWatchMovies.any((x) => x.id == movie.id)) {
      movie.setToWatch(true);
      movie.setWatched(false);
    } else {
      movie.setToWatch(false);
      movie.setWatched(false);
    }
    return movie;
  }


}