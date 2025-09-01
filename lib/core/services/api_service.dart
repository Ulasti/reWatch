import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:rewatch/features/explore/models/movie_model.dart';
import 'package:rewatch/features/explore/models/tv_model.dart';

class ApiService {
  final String baseUrl;
  final Map<String, String> defaultHeaders;

  ApiService({required this.baseUrl, this.defaultHeaders = const {}});

  Future<List<Movies>> getMovies(
    String endpoint, {
    Map<String, String>? headers,
  }) async {
    final response = await http.get(
      Uri.parse('$baseUrl$endpoint'),
      headers: {...defaultHeaders, ...?headers},
    );
    return _processListResponse(response);
  }

  Future<Movies> postMovie(
    String endpoint,
    Movies movie, {
    Map<String, String>? headers,
  }) async {
    final response = await http.post(
      Uri.parse('$baseUrl$endpoint'),
      headers: {
        'Content-Type': 'application/json',
        ...defaultHeaders,
        ...?headers,
      },
      body: jsonEncode(movie.toMap()),
    );
    return _processSingleResponse(response);
  }

  Future<Movies> putMovie(
    String endpoint,
    Movies movie, {
    Map<String, String>? headers,
  }) async {
    final response = await http.put(
      Uri.parse('$baseUrl$endpoint'),
      headers: {
        'Content-Type': 'application/json',
        ...defaultHeaders,
        ...?headers,
      },
      body: jsonEncode(movie.toMap()),
    );
    return _processSingleResponse(response);
  }

  Future<Movies> getMovieDetails(
    int movieId, {
    Map<String, String>? headers,
    Map<String, String>? queryParameters,
  }) async {
    final uri = Uri.parse(
      '$baseUrl/movie/$movieId',
    ).replace(queryParameters: queryParameters);
    final response = await http.get(
      uri,
      headers: {...defaultHeaders, ...?headers},
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to load movie details (${response.statusCode})');
    }

    final Map<String, dynamic> data =
        jsonDecode(response.body) as Map<String, dynamic>;
    return Movies.fromMap(data);
  }

  Future<Tv> getTvDetails(
    int tvId, {
    Map<String, String>? headers,
    Map<String, String>? queryParameters,
  }) async {
    final uri = Uri.parse(
      '$baseUrl/tv/$tvId',
    ).replace(queryParameters: queryParameters);
    final response = await http.get(
      uri,
      headers: {...defaultHeaders, ...?headers},
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to load TV details (${response.statusCode})');
    }

    final Map<String, dynamic> data =
        jsonDecode(response.body) as Map<String, dynamic>;
    return Tv.fromMap(data);
  }

  Future<void> delete(String endpoint, {Map<String, String>? headers}) async {
    final response = await http.delete(
      Uri.parse('$baseUrl$endpoint'),
      headers: {...defaultHeaders, ...?headers},
    );

    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw Exception(
        'DELETE failed: ${response.statusCode} ${response.reasonPhrase}',
      );
    }
  }

  Movies _processSingleResponse(http.Response response) {
    final status = response.statusCode;
    final body = response.body.isNotEmpty ? jsonDecode(response.body) : null;

    if (status >= 200 && status < 300 && body != null) {
      return Movies.fromMap(body);
    } else {
      throw Exception(
        'API Error: ${response.statusCode} ${response.reasonPhrase} $body',
      );
    }
  }

  List<Movies> _processListResponse(http.Response response) {
    final status = response.statusCode;
    final body = response.body.isNotEmpty ? jsonDecode(response.body) : null;

    if (status >= 200 && status < 300 && body != null) {
      return (body as List).map((e) => Movies.fromMap(e)).toList();
    } else {
      throw Exception(
        'API Error: ${response.statusCode} ${response.reasonPhrase} $body',
      );
    }
  }
}
