import 'package:flutter/material.dart';
import 'searcher.dart';
import 'dart:convert';
import 'movie.dart';
import 'movie_box.dart';

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
                    else
                      movies = jsonDecode(response.data)['results']
                          .map<Movie>((movie) => new Movie(movie))
                          .toList();
                    return getGridView(movies, orientation);
                }
              },
              future: searcher.searchPopular())
          : getGridView(movies, orientation),
      margin: new EdgeInsets.all(5.0),
    );
  }

  Widget getGridView(List<Movie> movies, Orientation orientation) {
    return new GridView.count(
      children: movies.map((movie) => new MovieBox(movie)).toList(),
      crossAxisCount: (orientation == Orientation.portrait) ? 2 : 3,
      crossAxisSpacing: 8.0,
      mainAxisSpacing: 8.0,
      childAspectRatio: 0.7,
      controller: controller,
    );
  }
}
