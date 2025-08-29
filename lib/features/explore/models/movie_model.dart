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

  String get voteAverageFormatted {
    final v = double.tryParse(vote_average);
    if (v == null) return vote_average;
    return v.toStringAsFixed(1);
  }

  String get releaseYear {
    if (release_date.isEmpty) return '';
    try {
      return DateTime.parse(release_date).year.toString();
    } catch (_) {
      return release_date.length >= 4
          ? release_date.substring(0, 4)
          : release_date;
    }
  }

  String get runtimeFormatted {
    final r = runtime;
    if (r <= 0) return '—';
    final hours = r ~/ 60;
    final minutes = r % 60;
    if (hours > 0) {
      return minutes > 0 ? '${hours}h ${minutes}m' : '${hours}h';
    }
    return '${minutes}m';
  }
}
