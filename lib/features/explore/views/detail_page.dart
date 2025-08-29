import 'package:flutter/material.dart';
import 'package:rewatch/core/constants/app_colors.dart';
import 'package:rewatch/core/repositories/movie_repo.dart';
import 'package:rewatch/core/utilities/palette_generator.dart';
import 'package:rewatch/features/explore/models/movie_model.dart';
import 'package:rewatch/features/explore/models/tv_model.dart';
import 'package:rewatch/features/explore/widgets/movie_carousel.dart';

class DetailPage extends StatefulWidget {
  final Movies movie;
  final bool isTv;

  const DetailPage({super.key, required this.movie, this.isTv = false});

  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  late Future<List<Movies>> upComingMovies;

  final MovieRepository repo = MovieRepository();

  bool _showTitle = false;
  bool _overviewExpanded = false;
  bool _showProviders = false;

  final ScrollController _scrollController = ScrollController();
  static const double posterHeight = 210;
  static const double toolbarShowOffsetBuffer = 100;

  Movies? _details;
  final MovieRepository _repo = MovieRepository();

  Widget _providerChip(String label, {IconData? icon}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      margin: const EdgeInsets.symmetric(horizontal: 6, vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.textOnDark10,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, size: 20, color: AppColors.textOnDark50),
            const SizedBox(width: 8),
          ],
          Text(
            label,
            style: const TextStyle(
              color: AppColors.textOnDark50,
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    // _loadDetails();
    _scrollController.addListener(_onScroll);
    upComingMovies = repo.getUpcomingMovies();
  }

  // Future<void> _loadDetails() async {
  //   try {
  //     if (widget.isTv) {
  //       final tv = await repo.getTvDetails(widget.movie.id);
  //       if (!mounted) return;
  //       setState(() => _tvDetails = tv);
  //     } else {
  //       final movie = await repo.getMovieDetails(widget.movie.id);
  //       if (!mounted) return;
  //       setState(() => _movieDetails = movie);
  //     }
  //   } catch (e) {
  //     // handle/log error if needed
  //   }
  // }

  void _onScroll() {
    final threshold = posterHeight - kToolbarHeight + toolbarShowOffsetBuffer;
    final shouldShow =
        _scrollController.hasClients && _scrollController.offset > threshold;
    if (shouldShow != _showTitle) setState(() => _showTitle = shouldShow);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  // String get displayTitle {
  //   if (widget.isTv) return _tvDetails?.name ?? widget.movie.title ?? '';
  //   return _movieDetails?.title ?? widget.movie.title ?? '';
  // }

  // String get displayOverview {
  //   return _movieDetails?.overview ??
  //       _tvDetails?.overview ??
  //       widget.movie.overview ??
  //       '';
  // }

  // String get displayReleaseDate {
  //   if (widget.isTv)
  //     return _tvDetails?.first_air_date ?? widget.movie.release_date ?? '';
  //   return _movieDetails?.release_date ?? widget.movie.release_date ?? '';
  // }

  // String get displayYear {
  //   final date = displayReleaseDate;
  //   if (date.isEmpty) return '';
  //   try {
  //     return DateTime.parse(date).year.toString();
  //   } catch (_) {
  //     return date.length >= 4 ? date.substring(0, 4) : date;
  //   }
  // }

  // List<String> get displayGenres {
  //   if (widget.isTv) return _tvDetails?.genres ?? [];
  //   return _movieDetails?.genres ?? [];
  // }

  // String get displayVote {
  //   final v = widget.isTv
  //       ? (_tvDetails?.vote_average ?? widget.movie.vote_average)
  //       : (_movieDetails?.vote_average ?? widget.movie.vote_average);
  //   final parsed = double.tryParse(v ?? '') ?? 0.0;
  //   return parsed.toStringAsFixed(1);
  // }

  Widget build(BuildContext context) {
    final title = widget.movie.title;
    final poster = widget.movie.poster_path;
    final posterUrl = 'https://image.tmdb.org/t/p/w500$poster';
    final backdrop = widget.movie.backdrop_path;
    final backdropUrl = 'https://image.tmdb.org/t/p/w500$backdrop';
    final runtime = widget.movie.runtime;
    const double posterFadeHeight = 80;

    return FutureBuilder<PaletteColors>(
      future: ColorPicker.instance.fromUrl(posterUrl),
      builder: (context, snap) {
        final palette = snap.data;
        final Color start = palette?.darkest ?? Colors.black;
        final Color end = palette?.darkMuted ?? Colors.white.withOpacity(0.06);

        return Scaffold(
          backgroundColor: Colors.black,
          appBar: AppBar(
            backgroundColor: start,
            elevation: 10,
            toolbarHeight: 50,
            leading: const BackButton(color: Colors.white),
            actions: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: IconButton(
                  icon: const Icon(Icons.favorite_border, color: Colors.white),
                  onPressed: () {},
                ),
              ),
            ],
            title: _showTitle
                ? Text(
                    title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  )
                : const SizedBox.shrink(),
          ),
          body: SingleChildScrollView(
            physics: ClampingScrollPhysics(),
            controller: _scrollController,
            child: Stack(
              children: [
                Positioned(
                  top: posterHeight,
                  left: 0,
                  right: 0,
                  bottom: 0,
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [start, end.withValues(alpha: 0.1)],
                      ),
                    ),
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    SizedBox(
                      height: posterHeight,
                      width: double.infinity,
                      child: Stack(
                        fit: StackFit.expand,
                        children: [
                          Image.network(
                            backdropUrl,
                            fit: BoxFit.cover,
                            errorBuilder: (_, __, ___) =>
                                Container(color: AppColors.Grey),
                          ),
                          Positioned(
                            left: 0,
                            right: 0,
                            bottom: 0,
                            height: posterFadeHeight,
                            child: Container(
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  begin: Alignment.bottomCenter,
                                  end: Alignment.topCenter,
                                  colors: [
                                    start.withOpacity(1),
                                    start.withOpacity(0.7),
                                    start.withOpacity(0.3),
                                    start.withOpacity(0.1),
                                    Colors.transparent,
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Text(
                        title,
                        style: const TextStyle(
                          color: AppColors.textOnDark90,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16.0,
                        vertical: 8,
                      ),
                      child: SizedBox(
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8.0,
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Text(
                                    '${_details?.runtimeFormatted}',
                                    style: TextStyle(
                                      color: AppColors.textOnDark50,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                  Text(
                                    '  |  ',
                                    style: TextStyle(
                                      color: AppColors.textOnDark70,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                  Text(
                                    '${widget.movie.releaseYear}',
                                    style: TextStyle(
                                      color: AppColors.textOnDark50,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                  Text(
                                    '  |  ',
                                    style: TextStyle(
                                      color: AppColors.textOnDark70,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                  Text(
                                    'IMDb ${widget.movie.voteAverageFormatted}',
                                    style: TextStyle(
                                      color: AppColors.textOnDark50,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: 16),
                            ElevatedButton(
                              onPressed: () => setState(
                                () => _showProviders = !_showProviders,
                              ),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.White,
                                foregroundColor: AppColors.Black,
                                textStyle: const TextStyle(
                                  fontSize: 17,
                                  fontWeight: FontWeight.bold,
                                ),
                                elevation: 3,
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 100,
                                  vertical: 12,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                shadowColor: AppColors.Primary,
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Text('Available on'),
                                  const SizedBox(width: 8),
                                  AnimatedRotation(
                                    turns: _showProviders ? 0.5 : 0.0,
                                    duration: const Duration(milliseconds: 200),
                                    child: const Icon(
                                      Icons.expand_more,
                                      size: 20,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            AnimatedSize(
                              duration: const Duration(milliseconds: 200),
                              curve: Curves.easeInOut,
                              child: ConstrainedBox(
                                constraints: _showProviders
                                    ? const BoxConstraints()
                                    : const BoxConstraints(maxHeight: 0),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 12,
                                  ),
                                  child: Column(
                                    children: [
                                      Wrap(
                                        alignment: WrapAlignment.start,
                                        children: [
                                          _providerChip(
                                            'Prime Video',
                                            icon: Icons.video_library,
                                          ),
                                          _providerChip(
                                            'HBO Max',
                                            icon: Icons.tv,
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(height: 12),
                            ElevatedButton(
                              onPressed: () {},
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.White,
                                foregroundColor: AppColors.Black,
                                textStyle: const TextStyle(
                                  fontSize: 17,
                                  fontWeight: FontWeight.bold,
                                ),
                                elevation: 3,
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 94,
                                  vertical: 13,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                shadowColor: AppColors.Primary,
                              ),
                              child: Text('Add to Watchlist'),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: Text(
                                _details?.genres.join(' • ') ?? '',
                                style: TextStyle(
                                  color: AppColors.textOnDark50,
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),

                            Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 4,
                                vertical: 4,
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  AnimatedSize(
                                    duration: const Duration(milliseconds: 220),
                                    curve: Curves.easeInOut,
                                    child: ConstrainedBox(
                                      constraints: _overviewExpanded
                                          ? const BoxConstraints()
                                          : const BoxConstraints(maxHeight: 48),
                                      child: Text(
                                        widget.movie.overview,
                                        softWrap: true,
                                        overflow: TextOverflow.fade,
                                        style: TextStyle(
                                          color: AppColors.textOnDark70,
                                          fontSize: 16,
                                          fontWeight: FontWeight.w400,
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  GestureDetector(
                                    behavior: HitTestBehavior.opaque,
                                    onTap: () => setState(
                                      () => _overviewExpanded =
                                          !_overviewExpanded,
                                    ),
                                    child: Text(
                                      _overviewExpanded
                                          ? 'Show less'
                                          : 'Show more',
                                      style: TextStyle(
                                        color: AppColors.Primary,
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: 20),
                            Row(
                              children: [
                                SizedBox(width: 8),
                                Text(
                                  'Related Movies',
                                  style: TextStyle(
                                    color: AppColors.textOnDark90,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                            MovieCarousel(popularMovies: upComingMovies),
                            SizedBox(height: 200),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
