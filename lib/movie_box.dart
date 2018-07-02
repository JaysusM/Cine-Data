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
                fit: BoxFit.fill,
                placeholder: new AssetImage("assets/loading.gif"),
                image: new NetworkImage(
                  widget.movie.poster
                )
              ),
              height: 180.0,
              width: 140.0,
            ),
            new Container(
            child: new Text("${widget.movie.title} (${widget.movie.year})",
            style: new TextStyle(fontSize: 17.5)),
            padding: new EdgeInsets.fromLTRB(10.0, 5.0, 10.0, 5.0),
            )
          ]),
      color: Theme
          .of(context)
          .primaryColor
          .withOpacity(0.15),
      height: 215.0,
      width: 140.0,
    );
  }

}