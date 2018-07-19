import 'package:flutter/material.dart';
import 'movie.dart';
import 'info_page.dart';
import 'watchlist.dart';

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
          leading: (widget.movie.watched) ? new Icon(Icons.check_circle, color: Colors.green) : new Container(),
          title: new Text(widget.movie.title, style: new TextStyle(fontFamily: 'Muli')),
          subtitle: new Text("TMDB Score: ${widget.movie.vote_average}", style: new TextStyle(fontFamily: 'Muli'),),
          backgroundColor: (widget.movie.watched) ? Colors.green.withOpacity(0.6) : Colors.black.withOpacity(0.6),
        ),
      ),
      onTap: () {
        Navigator.push(context,
            new MaterialPageRoute(builder: (BuildContext context) => new InfoPage(widget.movie)));
      },
      onDoubleTap: () {
        this.setState(() {
          if(widget.movie.watched) {
            Watchlist.dropWatchedMovie(widget.movie.id);
            widget.movie.setWatched(false);
          } else {
            Watchlist.addWatchedMovie(widget.movie.id);
            widget.movie.setWatched(true);
          }
        });
      },
    );
  }
}
