class Movies {
  String adult;
  String backdrop_path;
  String overview;
  String popularity;
  String poster_path;
  String release_date;
  String title;
  String vote_average;
  String original_language;
  int id;
  int runtime;
  List<String> genres;

  Movies({
    required this.backdrop_path,
    required this.title,
    required this.overview,
    required this.poster_path,
    required this.vote_average,
    required this.adult,
    required this.popularity,
    required this.release_date,
    required this.original_language,
    required this.id,
    required this.runtime,
    required this.genres,
  });

  factory Movies.fromMap(Map<String, dynamic> map) {
    List<String> parseNames(List? list, String key) {
      if (list == null) return [];
      return list
          .whereType<Map>()
          .map((e) => (e[key] ?? '').toString())
          .where((s) => s.isNotEmpty)
          .toList();
    }

    return Movies(
      adult: map['adult'].toString(),
      backdrop_path: map['backdrop_path'] ?? '',
      overview: map['overview'] ?? '',
      popularity: map['popularity'].toString(),
      poster_path: map['poster_path'] ?? '',
      release_date: map['release_date'] ?? '',
      title: map['title'] ?? '',
      vote_average: map['vote_average'].toString(),
      original_language: map['original_language'] ?? '',
      id: (map['id'] as num?)?.toInt() ?? 0,
      runtime: (map['runtime'] as num?)?.toInt() ?? 0,
      genres: parseNames(map['genres'] as List?, 'name'),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'adult': adult,
      'backdrop_path': backdrop_path,
      'overview': overview,
      'popularity': popularity,
      'poster_path': poster_path,
      'release_date': release_date,
      'title': title,
      'vote_average': vote_average,
      'original_language': original_language,
      'id': id,
      'runtime': runtime,
      'genres': genres,
    };
  }

  Movies copyWith({
    String? adult,
    String? backdrop_path,
    String? overview,
    String? popularity,
    String? poster_path,
    String? release_date,
    String? title,
    String? vote_average,
    String? original_language,
    int? id,
    int? runtime,
    List<String>? genres,
  }) {
    return Movies(
      adult: adult ?? this.adult,
      backdrop_path: backdrop_path ?? this.backdrop_path,
      overview: overview ?? this.overview,
      popularity: popularity ?? this.popularity,
      poster_path: poster_path ?? this.poster_path,
      release_date: release_date ?? this.release_date,
      title: title ?? this.title,
      vote_average: vote_average ?? this.vote_average,
      original_language: original_language ?? this.original_language,
      id: id ?? this.id,
      runtime: runtime ?? this.runtime,
      genres: genres ?? this.genres,
    );
  }
}
