import 'package:flutter/material.dart';
import 'searcher.dart';
import 'dart:convert';
import 'movie.dart';
import 'loaded_content.dart';
import 'grid_movie_screen.dart';

class UpcomingMoviesWidget extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => new UpcomingMoviesState();
}

class UpcomingMoviesState extends State {
  Searcher searcher = new Searcher();
  ScrollController controller = new ScrollController();
  int pageCounter = 1;
  bool isLoadingContent = false;

  Widget build(BuildContext context) {
    List<Movie> loadingContent;
    double offset;

    controller.addListener(() async {
      if (controller.position.maxScrollExtent == controller.offset &&
          !isLoadingContent) {
        offset = controller.offset;
        pageCounter++;
        isLoadingContent = true;
        await searcher.searchUpcoming(page: pageCounter).then((content) {
          loadingContent = jsonDecode(content)['results']
              .map<Movie>((movie) => new Movie(movie))
              .toList();
          isLoadingContent = false;
          loadingContent.forEach((movie) => GridMovieScreen.checkWatchlist(movie));
        }).whenComplete(() {
          this.setState(() {
            LoadedContent.upcomingMovies.addAll(loadingContent);
            controller.jumpTo(offset);
          });
        });
      }
    });

    return new Container(
      child: (LoadedContent.upcomingMovies == null)
          ? new FutureBuilder(
          builder: (BuildContext context, AsyncSnapshot response) {
            switch (response.connectionState) {
              case ConnectionState.waiting:
                return new Center(
                    child: new Column(
                      children: <Widget>[
                        new Text("Awaiting results...",
                            style: new TextStyle(fontSize: 17.0, fontFamily: 'Muli')),
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
                  LoadedContent.upcomingMovies = jsonDecode(response.data)['results']
                      .map<Movie>((movie) => new Movie(movie))
                      .toList();
                  LoadedContent.upcomingMovies.forEach((movie) => GridMovieScreen.checkWatchlist(movie));
                  return new GridMovieScreen(LoadedContent.upcomingMovies, controller);
                }
            }
          },
          future: searcher.searchUpcoming())
          : new GridMovieScreen(LoadedContent.upcomingMovies, controller),
    );
  }

}
