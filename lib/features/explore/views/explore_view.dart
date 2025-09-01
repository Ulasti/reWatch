import 'package:flutter/material.dart';
import 'package:rewatch/core/constants/app_colors.dart';
import 'package:rewatch/core/repositories/movie_repo.dart';
import 'package:rewatch/features/explore/widgets/custom_appbar.dart';
import 'package:rewatch/features/explore/widgets/featured_movie.dart';
import 'package:rewatch/features/explore/widgets/movie_carousel.dart';
import 'package:rewatch/features/explore/viewmodels/quickfilters.dart';

class ExploreView extends StatefulWidget {
  const ExploreView({super.key});

  @override
  State<ExploreView> createState() => _ExploreViewState();
}

class _ExploreViewState extends State<ExploreView> {
  final MovieRepository repo = MovieRepository();
  Category _activeCategory = Category.movies;

  Future<List<dynamic>>? _popularFuture;
  Future<List<dynamic>>? _topRatedFuture;
  Future<List<dynamic>>? _upcomingFuture;

  String get titlem =>
      _activeCategory == Category.movies ? 'Top Rated Movies' : 'Top Rated TV';
  String get titlep =>
      _activeCategory == Category.movies ? 'Popular Movies' : 'Popular TV';

  @override
  void initState() {
    super.initState();
    _loadLists();
  }

  void _onFilterChanged(Category category, Set<String> _) {
    if (category == _activeCategory) return;
    setState(() {
      _activeCategory = category;
      _loadLists();
    });
  }

  Future<void> _loadLists() async {
    if (_activeCategory == Category.movies) {
      _popularFuture = repo.getPopularMovies();
      _topRatedFuture = repo.getTopRatedMovies();
      _upcomingFuture = repo.getUpcomingMovies();
    } else {
      _popularFuture = repo.getPopularTv();
      _topRatedFuture = repo.getTopRatedTv();
      _upcomingFuture = repo.getOnTheAirTv();
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.Black,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomAppBar(onFilterChanged: _onFilterChanged),
                    TopMovieCarousel(
                      upComingMovies: _upcomingFuture ?? Future.value([]),
                    ),
                    const SizedBox(height: 15),
                    Text(
                      titlep,
                      style: TextStyle(
                        color: AppColors.White,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    MovieCarousel(
                      popularMovies: _popularFuture ?? Future.value([]),
                      title: _activeCategory == Category.movies
                          ? 'Popular Movies'
                          : 'Popular TV',
                      category: _activeCategory,
                    ),
                    Text(
                      titlem,
                      style: TextStyle(
                        color: AppColors.White,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    MovieCarousel(
                      popularMovies: _topRatedFuture ?? Future.value([]),
                      title: _activeCategory == Category.movies
                          ? 'Top Rated Movies'
                          : 'Top Rated TV',
                      category: _activeCategory,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
