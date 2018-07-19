import 'package:flutter/material.dart';
import 'movie.dart';
import 'info_page.dart';
import 'watchlist_manager.dart';
import 'popular_movies.dart';

class MovieBox extends StatefulWidget {
  Movie movie;

  MovieBox(this.movie);

  @override
  State<StatefulWidget> createState() => new MovieBoxState();
}

class MovieBoxState extends State<MovieBox> {
  @override
  Widget build(BuildContext context) {
    return new GestureDetector(
      child: new GridTile(
        child: new Hero(
            tag: widget.movie.id,
            child: new FadeInImage(
              fit: BoxFit.cover,
              placeholder: new AssetImage("assets/loadingCircle.gif"),
              image: new NetworkImage(widget.movie.getPosterUrl()),
            )),
        footer: new GridTileBar(
          leading: (widget.movie.watched()) ? new Icon(Icons.check_circle, color: Colors.green) : (!widget.movie.toWatch()) ? new Container() : new Icon(Icons.remove_red_eye, color: Colors.white),
          title: new Text(widget.movie.title, style: new TextStyle(fontFamily: 'Muli')),
          subtitle: new Text("TMDB Score: ${widget.movie.vote_average}", style: new TextStyle(fontFamily: 'Muli'),),
          backgroundColor: (widget.movie.watched()) ? Colors.green.withOpacity(0.6) : (!widget.movie.toWatch()) ? Colors.black.withOpacity(0.6) : Colors.blueAccent.withOpacity(0.7),
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
            PopularMoviesWidgetState.watched.remove(widget.movie.id);
          } else {
            Watchlist.addWatchedMovie(widget.movie.id);
            widget.movie.setWatched(true);
            Watchlist.dropToWatchMovie(widget.movie.id);
            PopularMoviesWidgetState.toWatch.remove(widget.movie.id);
            PopularMoviesWidgetState.watched.add(widget.movie.id);
          }
        });
      },
      onLongPress: () {
        this.setState(() {
          if(widget.movie.toWatch()) {
            Watchlist.dropToWatchMovie(widget.movie.id);
            widget.movie.setToWatch(false);
            PopularMoviesWidgetState.toWatch.remove(widget.movie.id);
          } else if (!widget.movie.watched()){
            Watchlist.addToWatchMovie(widget.movie.id);
            widget.movie.setToWatch(true);
            PopularMoviesWidgetState.toWatch.add(widget.movie.id);
          }
        });
      },
    );
  }
}
