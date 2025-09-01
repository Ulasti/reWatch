import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:rewatch/core/constants/apiKey.dart';
import 'package:rewatch/core/services/api_service.dart';
import 'package:rewatch/features/explore/models/movie_model.dart';
import 'package:rewatch/features/explore/models/tv_model.dart';

class MovieRepository {
  final ApiService api = ApiService(baseUrl: 'https://api.themoviedb.org/3');

  Future<List<Movies>> getPopularMovies() async {
    return _fetchMovies('/movie/popular?api_key=$apiKey');
  }

  Future<List<Movies>> getUpcomingMovies() async {
    return _fetchMovies('/movie/upcoming?api_key=$apiKey');
  }

  Future<List<Movies>> getTopRatedMovies() async {
    return _fetchMovies('/movie/top_rated?api_key=$apiKey');
  }

  Future<List<Tv>> getPopularTv() async {
    return _fetchTv('/tv/popular?api_key=$apiKey');
  }

  Future<List<Tv>> getOnTheAirTv() async {
    return _fetchTv('/tv/on_the_air?api_key=$apiKey');
  }

  Future<List<Tv>> getTopRatedTv() async {
    return _fetchTv('/tv/top_rated?api_key=$apiKey');
  }

  Future<List<Movies>> _fetchMovies(String endpoint) async {
    final response = await http.get(Uri.parse('${api.baseUrl}$endpoint'));
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final List<dynamic> results = data['results'];
      return results.map((e) => Movies.fromMap(e)).toList();
    } else {
      throw Exception('Failed to load movies');
    }
  }

  Future<List<Tv>> _fetchTv(String endpoint) async {
    final response = await http.get(Uri.parse('${api.baseUrl}$endpoint'));
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final List<dynamic> results = data['results'];
      return results.map((e) => Tv.fromMap(e)).toList();
    } else {
      throw Exception('Failed to load TV shows');
    }
  }

  Future<Movies> getMovieDetails(int movieId) async {
    final params = {'api_key': apiKey};
    return api.getMovieDetails(movieId, queryParameters: params);
  }

  Future<Tv> getTvDetails(int tvId) async {
    final params = {'api_key': apiKey};
    return api.getTvDetails(tvId, queryParameters: params);
  }
}
