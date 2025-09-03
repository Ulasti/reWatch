import 'package:flutter/material.dart' hide BoxDecoration, BoxShadow;
import 'package:flutter_inset_box_shadow_update/flutter_inset_box_shadow_update.dart';
import 'package:provider/provider.dart';
import 'package:rewatch/core/utilities/user_storage.dart';
import 'package:rewatch/core/repositories/movie_repo.dart';
import 'package:rewatch/features/explore/viewmodels/quickfilters.dart';
import 'package:rewatch/features/explore/views/detail_page.dart';
import 'package:rewatch/features/watchlist/widgets/nbackground.dart';

class WatchlistGrid extends StatelessWidget {
  final String listType;
  final Category category;

  const WatchlistGrid({
    super.key,
    required this.listType,
    required this.category,
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
              padding: EdgeInsets.all(8),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 0.6, // Poster aspect
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
                      return const Center(child: CircularProgressIndicator());
                    }
                    if (detailSnapshot.hasError || !detailSnapshot.hasData) {
                      return const Center(child: Text('Error'));
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
                      child: Stack(
                        children: [
                          Column(
                            children: [
                              Expanded(
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8),
                                    image: posterUrl != null
                                        ? DecorationImage(
                                            image: NetworkImage(posterUrl),
                                            fit: BoxFit.cover,
                                          )
                                        : null,
                                    color: posterUrl == null
                                        ? Colors.grey
                                        : null,
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black26,
                                        blurRadius: 4,
                                        offset: Offset(2, 2),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
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
