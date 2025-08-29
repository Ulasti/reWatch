import 'package:flutter/material.dart';
import 'package:rewatch/core/constants/app_colors.dart';
import 'package:rewatch/core/repositories/movie_repo.dart';
import 'package:rewatch/features/explore/models/media_model.dart';
import 'package:rewatch/features/explore/models/movie_model.dart';
import 'package:rewatch/features/explore/widgets/custom_appbar.dart';
import 'package:rewatch/features/explore/widgets/featured_movie.dart';
import 'package:rewatch/features/explore/widgets/movie_carousel.dart';
import 'package:rewatch/features/explore/viewmodels/quickfilters.dart';

class ExploreView extends StatefulWidget {
  final Movies? movie;
  final bool isTv;
  const ExploreView({super.key, this.movie, this.isTv = false});

  @override
  State<ExploreView> createState() => _ExploreViewState();
}

class _ExploreViewState extends State<ExploreView> {
  final MovieRepository repo = MovieRepository();
  MediaDetails? _details;

  Category _activeCategory = Category.movies;

  Future<List<Movies>>? _popularFuture;
  Future<List<Movies>>? _topRatedFuture;
  Future<List<Movies>>? _upcomingFuture;

  String get titlem =>
      _activeCategory == Category.movies ? 'Top Rated Movies' : 'Top Rated TV';

  String get titlep =>
      _activeCategory == Category.movies ? 'Popular Movies' : 'Popular TV';

  @override
  void initState() {
    super.initState();
    _loadLists();
    _loadDetails();
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
      _popularFuture = await repo.getPopularTv();
      _topRatedFuture = await repo.getTopRatedTv();
      _upcomingFuture = await repo.getOnTheAirTv();
    }

    setState(() {});
  }

  Future<void> _loadDetails() async {
    try {
      if (widget.isTv) {
        final tv = await repo.getTvDetails(widget.movie!.id);
        if (!mounted) return;
        setState(() => _details = MediaDetails.fromTv(tv));
      } else {
        final movie = await repo.getMovieDetails(widget.movie!.id);
        if (!mounted) return;
        setState(() => _details = MediaDetails.fromMovie(movie));
      }
    } catch (e) {
      // handle error
    }
  }

  @override
  Widget build(BuildContext context) {
    final displayTitle = _details?.title ?? widget.movie?.title;
    final displayRuntime =
        _details?.runtimeFormatted ?? widget.movie?.runtimeFormatted;
    final displayYear = _details?.releaseYear ?? widget.movie?.releaseYear;
    final displayVote =
        _details?.voteAverageFormatted ?? widget.movie?.voteAverageFormatted;
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
                    SizedBox(height: 15),
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
                      isTv: _activeCategory == Category.tv,
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
                      isTv: _activeCategory == Category.tv,
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
