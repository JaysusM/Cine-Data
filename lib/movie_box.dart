import 'package:flutter/material.dart';
import 'movie.dart';
import 'info_page.dart';

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
          title: new Text(widget.movie.title),
          subtitle: new Text("TMDB Score: ${widget.movie.vote_average}"),
          backgroundColor: Colors.black.withOpacity(0.6),
        ),
      ),
      onTap: () {
        Navigator.push(context,
            new MaterialPageRoute(builder: new InfoPage(widget.movie).build));
      },
    );
  }
}
