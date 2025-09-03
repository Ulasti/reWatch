import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserStorage extends ChangeNotifier {
  static const String _movieWatchlistKey = 'movie_watchlist';
  static const String _movieWatchedKey = 'movie_watched';
  static const String _seriesWatchlistKey = 'series_watchlist';
  static const String _seriesWatchedKey = 'series_watched';
  static const String _preferencesKey = 'preferences';

  Future<List<int>> _getList(String key) async {
    final prefs = await SharedPreferences.getInstance();
    final json = prefs.getString(key) ?? '[]';
    return List<int>.from(jsonDecode(json));
  }

  Future<void> _setList(String key, List<int> list) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(key, jsonEncode(list));
    notifyListeners();
  }

  Future<void> addToMovieWatchlist(int movieId) async {
    final list = await _getList(_movieWatchlistKey);
    if (!list.contains(movieId)) {
      list.add(movieId);
      await _setList(_movieWatchlistKey, list);
    }
  }

  Future<void> removeFromMovieWatchlist(int movieId) async {
    final list = await _getList(_movieWatchlistKey);
    list.remove(movieId);
    await _setList(_movieWatchlistKey, list);
  }

  Future<List<int>> getMovieWatchlist() => _getList(_movieWatchlistKey);

  Future<bool> isInMovieWatchlist(int movieId) async {
    final list = await _getList(_movieWatchlistKey);
    return list.contains(movieId);
  }

  Future<void> addToMovieWatched(int movieId) async {
    final list = await _getList(_movieWatchedKey);
    if (!list.contains(movieId)) {
      list.add(movieId);
      await _setList(_movieWatchedKey, list);
    }
  }

  Future<void> removeFromMovieWatched(int movieId) async {
    final list = await _getList(_movieWatchedKey);
    list.remove(movieId);
    await _setList(_movieWatchedKey, list);
  }

  Future<List<int>> getMovieWatched() => _getList(_movieWatchedKey);

  Future<bool> isInMovieWatched(int movieId) async {
    final list = await _getList(_movieWatchedKey);
    return list.contains(movieId);
  }

  Future<void> addToSeriesWatchlist(int seriesId) async {
    final list = await _getList(_seriesWatchlistKey);
    if (!list.contains(seriesId)) {
      list.add(seriesId);
      await _setList(_seriesWatchlistKey, list);
    }
  }

  Future<void> removeFromSeriesWatchlist(int seriesId) async {
    final list = await _getList(_seriesWatchlistKey);
    list.remove(seriesId);
    await _setList(_seriesWatchlistKey, list);
  }

  Future<List<int>> getSeriesWatchlist() => _getList(_seriesWatchlistKey);

  Future<bool> isInSeriesWatchlist(int seriesId) async {
    final list = await _getList(_seriesWatchlistKey);
    return list.contains(seriesId);
  }

  Future<void> addToSeriesWatched(int seriesId) async {
    final list = await _getList(_seriesWatchedKey);
    if (!list.contains(seriesId)) {
      list.add(seriesId);
      await _setList(_seriesWatchedKey, list);
    }
  }

  Future<void> removeFromSeriesWatched(int seriesId) async {
    final list = await _getList(_seriesWatchedKey);
    list.remove(seriesId);
    await _setList(_seriesWatchedKey, list);
  }

  Future<List<int>> getSeriesWatched() => _getList(_seriesWatchedKey);

  Future<bool> isInSeriesWatched(int seriesId) async {
    final list = await _getList(_seriesWatchedKey);
    return list.contains(seriesId);
  }

  Future<void> setPreference(String key, String value) async {
    final prefs = await SharedPreferences.getInstance();
    final preferences = await getPreferences();
    preferences[key] = value;
    await prefs.setString(_preferencesKey, jsonEncode(preferences));
    notifyListeners();
  }

  Future<String?> getPreference(String key) async {
    final preferences = await getPreferences();
    return preferences[key];
  }

  Future<Map<String, String>> getPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    final preferencesJson = prefs.getString(_preferencesKey) ?? '{}';
    return Map<String, String>.from(jsonDecode(preferencesJson));
  }
}
