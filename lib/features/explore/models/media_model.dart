import 'package:rewatch/features/explore/models/movie_model.dart';
import 'package:rewatch/features/explore/models/tv_model.dart';

class MediaDetails {
  final int id;
  final String title;
  final String overview;
  final String posterPath;
  final String backdropPath;
  final String releaseDate;
  final String voteAverage;
  final List<int> runtime;
  final List<String> genres;

  MediaDetails({
    required this.id,
    required this.title,
    required this.overview,
    required this.posterPath,
    required this.backdropPath,
    required this.releaseDate,
    required this.voteAverage,
    required this.runtime,
    required this.genres,
  });

  factory MediaDetails.fromMovie(Movies m) {
    return MediaDetails(
      id: m.id,
      title: m.title,
      overview: m.overview,
      posterPath: m.poster_path,
      backdropPath: m.backdrop_path,
      releaseDate: m.release_date,
      voteAverage: m.vote_average,
      runtime: [m.runtime],
      genres: m.genres,
    );
  }

  factory MediaDetails.fromTv(Tv t) {
    return MediaDetails(
      id: t.id,
      title: t.name,
      overview: t.overview,
      posterPath: t.poster_path,
      backdropPath: t.backdrop_path,
      releaseDate: t.first_air_date,
      voteAverage: t.vote_average,
      runtime: t.episode_run_time.isNotEmpty ? t.episode_run_time : [37],
      genres: t.genres,
    );
  }

  String get runtimeFormatted {
    if (runtime.isEmpty) return '0';

    if (runtime.length == 1) {
      final r = runtime[0];
      if (r <= 0) return '—';
      final hours = r ~/ 60;
      final minutes = r % 60;
      if (hours > 0) return minutes > 0 ? '${hours}h ${minutes}m' : '${hours}h';
      return '${minutes}m';
    }

    final r = runtime[0];
    if (r <= 0) return '-';
    final hours = r ~/ 60;
    final minutes = r % 60;
    if (hours > 0) return minutes > 0 ? '${hours}h ${minutes}m' : '${hours}h';
    return '${minutes}m';
  }

  String get releaseYear {
    if (releaseDate.isEmpty) return '';
    try {
      return DateTime.parse(releaseDate).year.toString();
    } catch (_) {
      return releaseDate.length >= 4
          ? releaseDate.substring(0, 4)
          : releaseDate;
    }
  }

  String get voteAverageFormatted {
    final v = double.tryParse(voteAverage) ?? 0.0;
    return v.toStringAsFixed(1);
  }
}
