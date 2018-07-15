import 'package:flutter/material.dart';
import 'movie.dart';

class MovieBox extends StatefulWidget {
  Movie movie;

  MovieBox(this.movie);

  @override
  State<StatefulWidget> createState() => new MovieBoxState();
}

class MovieBoxState extends State<MovieBox> {
  @override
  Widget build(BuildContext context) {
    return new GridTile(
      child: new FadeInImage(
        fit: BoxFit.cover,
        placeholder: new AssetImage("assets/loadingCircle.gif"),
        image: new NetworkImage(widget.movie.getPosterUrl()),
      ),
      footer: new GridTileBar(
        title: new Text(widget.movie.title),
        subtitle: new Text("IMDB: ${widget.movie.vote_average}"),
        backgroundColor: Colors.black.withOpacity(0.6),
      ),
    );
  }
}
