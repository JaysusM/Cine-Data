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
    return new Container(
      child: new Column(
          children: <Widget>[
            new Container(
              child: new FadeInImage(
                fit: BoxFit.fitHeight,
                placeholder: new AssetImage("assets/loading.gif"),
                image: new NetworkImage(
                  widget.movie.getPosterUrl()
                )
              ),
              height: 180.0,
              width: 140.0,
              padding: new EdgeInsets.all(5.0),
            ),
            new Expanded(
              child: new Center(child: new Text(
                  "${widget.movie.title} (${widget.movie.vote_average})",
                  style: new TextStyle(fontSize: 12.5))
              ),
            )
          ]
      ),
      color: Theme
          .of(context)
          .primaryColor
          .withOpacity(0.15),
      height: 505.0,
      width: 140.0,
    );
  }

}