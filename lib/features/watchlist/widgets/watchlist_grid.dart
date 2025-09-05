import 'package:flutter/material.dart' hide BoxDecoration, BoxShadow;
import 'package:flutter_inset_shadow/flutter_inset_shadow.dart';
import 'package:provider/provider.dart';
import 'package:rewatch/core/utilities/user_storage.dart';
import 'package:rewatch/core/repositories/movie_repo.dart';
import 'package:rewatch/features/explore/viewmodels/quickfilters.dart';
import 'package:rewatch/features/explore/views/detail_page.dart';

class WatchlistGrid extends StatelessWidget {
  final String listType;
  final Category category;
  final double topPadding;

  const WatchlistGrid({
    super.key,
    required this.listType,
    required this.category,
    this.topPadding = 120.0,
  });

  Future<List<int>> _getList(UserStorage userStorage) {
    switch (listType) {
      case 'movie_watchlist':
        return userStorage.getMovieWatchlist();
      case 'movie_watched':
        return userStorage.getMovieWatched();
      case 'series_watchlist':
        return userStorage.getSeriesWatchlist();
      case 'series_watched':
        return userStorage.getSeriesWatched();
      default:
        return Future.value([]);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<UserStorage>(
      builder: (context, userStorage, child) {
        return FutureBuilder<List<int>>(
          future: _getList(userStorage),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            if (snapshot.hasError || !snapshot.hasData) {
              return const Center(child: Text('Error loading list'));
            }
            final ids = snapshot.data!;
            if (ids.isEmpty) {
              return const Center(child: Text('No items in this list'));
            }
            return GridView.builder(
              padding: EdgeInsets.only(
                left: 16,
                right: 16,
                bottom: 16,
                top: topPadding, // Use the topPadding parameter
              ),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 8,
                mainAxisSpacing: 8,
                childAspectRatio: 0.6,
              ),
              itemCount: ids.length > 30 ? 30 : ids.length,
              itemBuilder: (context, index) {
                final id = ids[index];
                return FutureBuilder<dynamic>(
                  future: category == Category.movies
                      ? MovieRepository().getMovieDetails(id)
                      : MovieRepository().getTvDetails(id),
                  builder: (context, detailSnapshot) {
                    if (detailSnapshot.connectionState ==
                        ConnectionState.waiting) {
                      return const Center(child: Text(' '));
                    }
                    if (detailSnapshot.hasError || !detailSnapshot.hasData) {
                      return const Center(child: Text(' '));
                    }
                    final item = detailSnapshot.data!;
                    final posterUrl = item.poster_path != null
                        ? 'https://image.tmdb.org/t/p/w200${item.poster_path}'
                        : null;
                    return GestureDetector(
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) =>
                              DetailPage(media: item, category: category),
                        ),
                      ),

                      child: Column(
                        children: [
                          Expanded(
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(7),
                                image: posterUrl != null
                                    ? DecorationImage(
                                        image: NetworkImage(posterUrl),
                                        fit: BoxFit.cover,
                                      )
                                    : null,
                                color: posterUrl == null ? Colors.grey : null,
                                boxShadow: posterUrl != null
                                    ? [
                                        BoxShadow(
                                          color: Theme.of(
                                            context,
                                          ).colorScheme.surfaceTint,
                                          blurRadius: 5,
                                          offset: Offset(0, 0),
                                        ),
                                      ]
                                    : null,
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                );
              },
            );
          },
        );
      },
    );
  }
}
