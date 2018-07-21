import 'package:flutter/material.dart';
import 'movie.dart';
import 'info_page.dart';
import 'watchlist_manager.dart';
import 'loaded_content.dart';

class MovieBox extends StatefulWidget {
  final Movie movie;

  MovieBox(this.movie);

  @override
  State<StatefulWidget> createState() => new MovieBoxState();
}

class MovieBoxState extends State<MovieBox> {
  @override
  Widget build(BuildContext context) {
    return new GestureDetector(
      child: new GridTile(
            child: new FadeInImage(
              fit: BoxFit.cover,
              placeholder: new AssetImage("assets/loadingCircle.gif"),
              image: new NetworkImage(widget.movie.getPosterUrl()),
            ),
        footer: new GridTileBar(
          leading: (widget.movie.watched()) ? new Icon(Icons.check_circle, color: Colors.green) : (!widget.movie.toWatch()) ? new Container() : new Icon(Icons.remove_red_eye, color: Colors.white),
          title: new Text(widget.movie.title, style: new TextStyle(fontFamily: 'Muli')),
          subtitle: new Text("TMDB Score: ${(widget.movie.vote_average != 0.0) ? widget.movie.vote_average : "-"}", style: new TextStyle(fontFamily: 'Muli'),),
          backgroundColor: (widget.movie.watched()) ? Colors.green.withOpacity(0.7) : (!widget.movie.toWatch()) ? Colors.black.withOpacity(0.7) : Colors.blueAccent.withOpacity(0.7),
        ),
      ),
      onTap: () {
        Navigator.push(context,
            new MaterialPageRoute(builder: (BuildContext context) => new InfoPage(widget.movie)));
      },
      onDoubleTap: () {
        this.setState(() {
          if(widget.movie.watched()) {
            Watchlist.dropWatchedMovie(widget.movie.id);
            widget.movie.setWatched(false);
            LoadedContent.watchedMovies.removeWhere((movie) => movie.id == widget.movie.id);
          } else {
            Watchlist.addWatchedMovie(widget.movie);
            widget.movie.setWatched(true);
            widget.movie.setToWatch(false);
            Watchlist.dropToWatchMovie(widget.movie.id);
            LoadedContent.toWatchMovies.removeWhere((movie) => movie.id == widget.movie.id);
            LoadedContent.watchedMovies.add(widget.movie);
          }
        });
      },
      onLongPress: () {
        this.setState(() {
          if(widget.movie.toWatch()) {
            Watchlist.dropToWatchMovie(widget.movie.id);
            widget.movie.setToWatch(false);
            LoadedContent.toWatchMovies.removeWhere((movie) => movie.id == widget.movie.id);
          } else if (!widget.movie.watched()){
            Watchlist.addToWatchMovie(widget.movie);
            widget.movie.setToWatch(true);
            LoadedContent.toWatchMovies.add(widget.movie);
          }
        });
      },
    );
  }
}
