class Movie {
  var vote_count, id, popularity, vote_average;
  String title,
      poster_path,
      original_language,
      original_title,
      backdrop_path,
      overview,
      release_date;
  List genre_ids;
  bool video, adult, _watched = false, _toWatch = false;

  String getPosterUrl() {
    return "https://image.tmdb.org/t/p/w500$poster_path";
  }

  void setWatched(bool watched) {
    this._watched = watched;
  }

  void setToWatch(bool toWatch) {
    this._toWatch = toWatch;
  }

  bool watched() => _watched;
  bool toWatch() => _toWatch;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is MovieFull &&
              runtimeType == other.runtimeType &&
              id == other.id;

  @override
  int get hashCode => id.hashCode;

  Movie.elemental(this.id, this.title, this.vote_average, this.poster_path);

  Movie(Map content)
      : vote_count = content["vote_count"],
        id = content["id"],
        video = content["video"],
        vote_average = content["vote_average"],
        title = content["title"],
        popularity = content["popularity"],
        poster_path = content["poster_path"],
        original_language = content["original_language"],
        original_title = content["original_title"],
        genre_ids = content["genre_ids"],
        backdrop_path = content["backdrop_path"],
        adult = content["path"],
        overview = content["overview"],
        release_date = content["release_date"];
}

class MovieFull {
  bool adult;
  String backdrop_path,
      belong_to_collection__name,
      belong_to_collection__poster_path,
      belong_to_collection_backdrop_path,
      homepage,
      imdb_id,
      original_language,
      original_title,
      overview,
      poster_path,
      release_date,
      status,
      tagline,
      title;
  int budget, id, revenue, runtime, vote_count, belongs_to_collection__id;
  List<dynamic> genres, spoken_languages, production_companies;
  double vote_average, popularity;
  bool _watched = false, _toWatch = false;

  void setWatched(bool watched) {
    this._watched = watched;
  }

  void setToWatch(bool toWatch) {
    this._toWatch = toWatch;
  }

  bool watched() => _watched;
  bool toWatch() => _toWatch;

  MovieFull(Map content)
      : adult = content['adult'],
        backdrop_path = content['backdrop_path'],
        budget = content['budget'],
        genres = content['genres'].map((content) => (content['name'] == 'Science Fiction') ? 'Sci-Fi' : content['name']).toList(),
        homepage = content['homepage'],
        id = content['id'],
        imdb_id = content['imdb_id'],
        original_language = content['original_language'],
        original_title = content['original_title'],
        overview = content['overview'],
        popularity = content['popularity'],
        poster_path = content['poster_path'],
        production_companies = content['production_companies']
            .map((company) => new Company(company['id'], company['logo_path'],
                company['name'], company['origin_country']))
            .toList(),
        release_date = content['release_date'],
        revenue = content['revenue'],
        runtime = content['runtime'],
        spoken_languages = content['spoken_languages']
            .map((language) => language['name'])
            .toList(),
        status = content['status'],
        tagline = content['tagline'],
        title = content['title'],
        vote_average = content['vote_average'],
        vote_count = content['vote_count'] {
    if (content['belongs_to_collection'] != null) {
      belongs_to_collection__id = content['belongs_to_collection']['id'];
      belong_to_collection__name = content['belongs_to_collection']['name'];
      belong_to_collection__poster_path =
          content['belongs_to_collection']['poster_path'];
      belong_to_collection_backdrop_path =
          content['belongs_to_collection']['backdrop_path'];
    }
  }

  static String getImage(String path) {
    return "https://image.tmdb.org/t/p/w500$path";
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is MovieFull &&
              runtimeType == other.runtimeType &&
              id == other.id;

  @override
  int get hashCode => id.hashCode;



}

class Company {
  int id;
  String logo_path, name, origin_country;

  Company(this.id, this.logo_path, this.name, this.origin_country);
}
