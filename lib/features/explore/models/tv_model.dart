class Tv {
  String adult;
  String backdrop_path;
  String overview;
  String popularity;
  String poster_path;
  String first_air_date;
  String name;
  String vote_average;
  String original_language;
  int id;
  List<int> episode_run_time;
  List<String> genres;

  Tv({
    required this.backdrop_path,
    required this.name,
    required this.overview,
    required this.poster_path,
    required this.vote_average,
    required this.adult,
    required this.popularity,
    required this.first_air_date,
    required this.original_language,
    required this.id,
    required this.episode_run_time,
    required this.genres,
  });

  factory Tv.fromMap(Map<String, dynamic> map) {
    List<String> parseNames(List? list, String key) {
      if (list == null) return [];
      return list
          .whereType<Map>()
          .map((e) => (e[key] ?? '').toString())
          .where((s) => s.isNotEmpty)
          .toList();
    }

    return Tv(
      adult: map['adult'].toString(),
      backdrop_path: map['backdrop_path'] ?? '',
      overview: map['overview'] ?? '',
      popularity: map['popularity'].toString(),
      poster_path: map['poster_path'] ?? '',
      first_air_date: map['first_air_date'] ?? '',
      name: map['name'] ?? '',
      vote_average: map['vote_average'].toString(),
      original_language: map['original_language'] ?? '',
      id: (map['id'] as num?)?.toInt() ?? 0,
      episode_run_time:
          (map['episode_run_time'] as List<dynamic>?)
              ?.map((e) => (e as num).toInt())
              .toList() ??
          [],
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
      'first_air_date': first_air_date,
      'name': name,
      'vote_average': vote_average,
      'original_language': original_language,
      'id': id,
      'episode_run_time': episode_run_time,
      'genres': genres,
    };
  }

  Tv copyWith({
    String? adult,
    String? backdrop_path,
    String? overview,
    String? popularity,
    String? poster_path,
    String? first_air_date,
    String? name,
    String? vote_average,
    String? original_language,
    int? id,
    List<int>? episode_run_time,
    List<String>? genres,
  }) {
    return Tv(
      adult: adult ?? this.adult,
      backdrop_path: backdrop_path ?? this.backdrop_path,
      overview: overview ?? this.overview,
      popularity: popularity ?? this.popularity,
      poster_path: poster_path ?? this.poster_path,
      first_air_date: first_air_date ?? this.first_air_date,
      name: name ?? this.name,
      vote_average: vote_average ?? this.vote_average,
      original_language: original_language ?? this.original_language,
      id: id ?? this.id,
      episode_run_time: episode_run_time ?? this.episode_run_time,
      genres: genres ?? this.genres,
    );
  }
}
