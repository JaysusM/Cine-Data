import 'package:flutter/material.dart';

class SearchBar extends StatefulWidget {
  TextEditingController controller;

  SearchBar() {
    controller = new TextEditingController();
  }

  @override
  State<StatefulWidget> createState() => new SearchBarState();
}

class SearchBarState extends State<SearchBar> {

  Widget build(BuildContext context) {
    return new Container(
      child: new TextField(
        controller: widget.controller,
        decoration: new InputDecoration(
          hintText: "Filter by title",
          hintStyle: new TextStyle(fontFamily: 'Muli'),
          contentPadding: new EdgeInsets.all(10.0)
        ),
      ),
      decoration: new BoxDecoration(
        borderRadius: new BorderRadius.circular(14.5),
        color: Colors.white
      ),
    );
  }
}
