import 'package:flutter/material.dart';
import 'popular_movies.dart';
import 'watchlist_manager.dart';
import 'search_screen.dart';
import 'watched_screen.dart';
import 'genre_screen.dart';
import 'upcoming_movies.dart';
import 'package:url_launcher/url_launcher.dart';

void main() async {
  await Watchlist.initDatabase();
  runApp(new MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Cine Data',
      theme: new ThemeData(
          brightness: Brightness.light,
          primaryColor: const Color(0xFF020122),
          accentColor: const Color(0xFFff521b)),
      routes: <String, WidgetBuilder>{
        "/search": (BuildContext context) => new SearchScreen(),
        "/watched": (BuildContext context) => new WatchlistScreen(true),
        "/toWatch": (BuildContext context) => new WatchlistScreen(false),
        "/genres": (BuildContext context) =>
            ScaffoldContainer(new GenreScreen(), "Genres"),
        "/popular": (BuildContext context) =>
            ScaffoldContainer(new PopularMoviesWidget(), "Popular Movies"),
        "/upcoming": (BuildContext context) =>
            ScaffoldContainer(new UpcomingMoviesWidget(), "Upcoming Movies")
      },
      home: new MainScreen(),
    );
  }

  Widget ScaffoldContainer(Widget body, String title) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text(title,
            style:
                new TextStyle(fontFamily: 'Muli', fontWeight: FontWeight.bold)),
      ),
      body: body,
    );
  }
}

class MainScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => new MainScreenState();
}

class MainScreenState extends State with SingleTickerProviderStateMixin {
  Widget popularMovies, upcomingMovies, genreScreen;
  TabController tabController;

  MainScreenState() {
    popularMovies = new PopularMoviesWidget();
    genreScreen = new GenreScreen();
    upcomingMovies = new UpcomingMoviesWidget();
    tabController = new TabController(length: 3, vsync: this)..index = 1;
  }

  Widget build(BuildContext context) {
    return new Scaffold(
      drawer: new Drawer(
        child: new ListView(
          children: <Widget>[
            new ListTile(
                title: new Text("MENU",
                    style: new TextStyle(
                        fontFamily: 'Muli',
                        fontWeight: FontWeight.bold,
                        fontSize: 20.0)),
                leading: new Icon(Icons.menu)),
            new Divider(),
            menuEntryTile(context, "/watched", "Watched Movies"),
            new Divider(),
            menuEntryTile(context, "/toWatch", "To Watch Movies"),
            new Divider(),
            menuEntryTile(context, "/search", "Search by title"),
            new Divider(),
            menuEntryTile(context, "/genres", "Discover by genres"),
            new Divider(),
            menuEntryTile(context, "/popular", "Popular Movies"),
            new Divider(),
            menuEntryTile(context, "/upcoming", "Upcoming Movies"),
            new Divider(),
            new GestureDetector(
                child: new ListTile(
                  title: new Text("How to use",
                      style: new TextStyle(fontFamily: 'Muli')),
                  leading: new Icon(
                    Icons.movie,
                    size: 15.0,
                  ),
                ),
                onTap: () {
                  howToUseDialog();
                }),
            new Divider(),
            aboutDialog()
          ],
        ),
        elevation: 15.0,
      ),
      appBar: new AppBar(
        title: new Text("HOME",
            style:
                new TextStyle(fontWeight: FontWeight.bold, fontFamily: 'Muli')),
        actions: <Widget>[
          new IconButton(
              icon: new Icon(Icons.search),
              onPressed: () {
                Navigator.of(context).pushNamed("/search");
              })
        ],
        bottom: new TabBar(
          tabs: <Tab>[
            new Tab(
                child: new Text("GENRES",
                    style: new TextStyle(
                        fontFamily: 'Muli', fontWeight: FontWeight.bold))),
            new Tab(
                child: new Text("POPULAR",
                    style: new TextStyle(
                        fontFamily: 'Muli', fontWeight: FontWeight.bold))),
            new Tab(
                child: new Text("UPCOMING",
                    style: new TextStyle(
                        fontFamily: 'Muli', fontWeight: FontWeight.bold))),
          ],
          controller: tabController,
        ),
      ),
      body: new TabBarView(
        children: <Widget>[genreScreen, popularMovies, upcomingMovies],
        controller: tabController,
      ),
    );
  }

  Widget aboutDialog() {
    return new GestureDetector(
        child: new ListTile(
          title: new Text("About",
              style: new TextStyle(fontFamily: 'Muli')),
          leading: new Icon(
            Icons.movie,
            size: 15.0,
          ),
        ),
        onTap: () {
          showDialog(context: context, builder: (BuildContext context) => new AboutDialog(
            applicationName: "Cine-Data",
            applicationIcon: new Icon(Icons.movie),
            applicationLegalese: "This app was made using Flutter and TMDB Api and has no commercial use, source code can be found on github, check the menu\n",
            applicationVersion: "1.0",
            children: <Widget>[
              new RaisedButton(onPressed: () async {
                if(await canLaunch("https://github.com/jaysusm/cine-data"))
                  launch("https://github.com/jaysusm/cine-data");
                   },
                  child: new Text("SOURCE CODE"),
                  shape: BeveledRectangleBorder(
                      side: new BorderSide(
                          color: Theme.of(context).accentColor)
                  ),
                color: Colors.white,
                splashColor: Theme.of(context).accentColor.withOpacity(0.15),
                textColor: Theme.of(context).accentColor,
              )
            ],
          ));
        });
  }

  void howToUseDialog() {
    showDialog(
        context: context,
        builder: (BuildContext context) => new AlertDialog(
      title: new Text("How to use",
          style:
              new TextStyle(fontFamily: 'Muli', fontWeight: FontWeight.bold)),
      content: new Text(
          "· Double tap a movie adds it to watched movies\n· Long press adds it to watchlist\nYou can set it in detail pages too",
          style: new TextStyle(fontFamily: 'Muli')),
      actions: <Widget>[
        new FlatButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: new Text(
              "Understood",
              style: new TextStyle(fontFamily: 'Muli'),
            ))
      ],
    ));
  }

  Widget menuEntryTile(BuildContext context, String routeName, String tabName) {
    return new GestureDetector(
        child: new ListTile(
          title: new Text(tabName, style: new TextStyle(fontFamily: 'Muli')),
          leading: new Icon(
            Icons.movie,
            size: 15.0,
          ),
        ),
        onTap: () {
          Navigator.of(context).pushNamed(routeName);
        });
  }
}
