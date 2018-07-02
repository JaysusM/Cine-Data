
class Movie {
  String _title;
  String _year;
  String _imdbID;
  String _type;
  String _poster;

  Movie(this._title, this._year, this._imdbID, this._type, this._poster);

  String get poster => _poster;
  String get type => _type;
  String get imdbID => _imdbID;
  String get year => _year;
  String get title => _title;
}