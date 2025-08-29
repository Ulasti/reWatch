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

  Future<Future<List<Movies>>> getPopularTv() async {
    return _fetchMovies('/tv/popular?api_key=$apiKey');
  }

  Future<Future<List<Movies>>> getOnTheAirTv() async {
    return _fetchMovies('/tv/on_the_air?api_key=$apiKey');
  }

  Future<Future<List<Movies>>> getTopRatedTv() async {
    return _fetchMovies('/tv/top_rated?api_key=$apiKey');
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

  Future<Movies> getMovieDetails(int movieId) async {
    final params = {'api_key': apiKey};
    return api.getMovieDetails(movieId, queryParameters: params);
  }

  Future<Tv> getTvDetails(int tvId) async {
    final uri = Uri.parse('${api.baseUrl}/tv/$tvId?api_key=$apiKey');
    final response = await http.get(uri);
    if (response.statusCode == 200) {
      final Map<String, dynamic> data = jsonDecode(response.body);
      return Tv.fromMap(data);
    } else {
      throw Exception('Failed to load TV details: ${response.statusCode}');
    }
  }
}
