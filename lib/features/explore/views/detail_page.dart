import 'package:flutter/material.dart';
import 'package:rewatch/core/constants/app_colors.dart';
import 'package:rewatch/core/repositories/movie_repo.dart';
import 'package:rewatch/core/utilities/palette_generator.dart';
import 'package:rewatch/features/explore/models/tv_model.dart';
import 'package:rewatch/features/explore/viewmodels/quickfilters.dart';
import 'package:rewatch/features/explore/widgets/available_chip.dart';
import 'package:rewatch/features/explore/widgets/detail_background.dart';
import 'package:rewatch/features/explore/widgets/detail_poster.dart';
import 'package:rewatch/features/explore/widgets/dynamic_appbar.dart';
import 'package:rewatch/features/explore/widgets/genres.dart';
import 'package:rewatch/features/explore/widgets/add_tolist_button.dart';
import 'package:rewatch/features/explore/widgets/media_info.dart';
import 'package:rewatch/features/explore/models/media_model.dart';
import 'package:rewatch/features/explore/widgets/related_movies.dart';

class DetailPage extends StatefulWidget {
  final dynamic media;
  final Category category;

  const DetailPage({super.key, required this.media, required this.category});

  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  late Future<List<dynamic>> upComingMovies;
  final MovieRepository repo = MovieRepository();

  bool _showTitle = false;
  bool _overviewExpanded = false;
  bool _showProviders = false;
  MediaDetails? _mediaDetails;

  final ScrollController _scrollController = ScrollController();
  static const double posterHeight = 210;
  static const double toolbarShowOffsetBuffer = 100;

  @override
  void initState() {
    super.initState();
    _loadDetails();
    _scrollController.addListener(_onScroll);
    // Set initial MediaDetails from widget.media
    _mediaDetails = (widget.media is Tv)
        ? MediaDetails.fromTv(widget.media)
        : MediaDetails.fromMovie(widget.media);
    // Set upcoming based on category (no cast needed)
    if (widget.category == Category.movies) {
      upComingMovies = repo.getUpcomingMovies();
    } else {
      upComingMovies = repo.getOnTheAirTv(); // Remove 'as Future<List<Movies>>'
    }
  }

  Future<void> _loadDetails() async {
    try {
      final repo = MovieRepository();
      if (widget.category == Category.movies) {
        final details = await repo.getMovieDetails(widget.media.id);
        _mediaDetails = MediaDetails.fromMovie(details);
      } else {
        final details = await repo.getTvDetails(widget.media.id);
        _mediaDetails = MediaDetails.fromTv(details);
      }
      if (!mounted) return;
      setState(() {});
    } catch (e) {
      // handle error
    }
  }

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

  @override
  Widget build(BuildContext context) {
    final title = _mediaDetails?.title ?? '';
    final posterUrl =
        _mediaDetails?.posterPath != null &&
            _mediaDetails!.posterPath.isNotEmpty
        ? 'https://image.tmdb.org/t/p/w500${_mediaDetails!.posterPath}'
        : null;
    final backdropUrl =
        _mediaDetails?.backdropPath != null &&
            _mediaDetails!.backdropPath.isNotEmpty
        ? 'https://image.tmdb.org/t/p/w500${_mediaDetails!.backdropPath}'
        : null;
    const double posterFadeHeight = 80;

    return FutureBuilder<PaletteColors>(
      future: ColorPicker.instance.fromUrl(posterUrl!),
      builder: (context, snap) {
        final palette = snap.data;
        final Color start = palette?.darkest ?? Colors.black;
        final Color end =
            palette?.darkMuted ?? Colors.white.withValues(alpha: 0.06);

        return Scaffold(
          backgroundColor: Colors.black,
          appBar: DynamicAppBar(
            start: start,
            showTitle: _showTitle,
            title: title,
          ),
          body: SingleChildScrollView(
            physics: ClampingScrollPhysics(),
            controller: _scrollController,
            child: Stack(
              children: [
                DetailBackground(
                  posterHeight: posterHeight,
                  start: start,
                  end: end,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    DetailPoster(
                      posterHeight: posterHeight,
                      backdropUrl: backdropUrl,
                      posterFadeHeight: posterFadeHeight,
                      start: start,
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
                            MediaInfo(mediaDetails: _mediaDetails),
                            SizedBox(height: 16),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                AddToListButton(title: 'Add to Watchlist'),
                                SizedBox(width: 8),
                                AddToListButton(title: 'Mark as Watched'),
                              ],
                            ),
                            SizedBox(height: 8),
                            AvailableButton(),
                            Genres(mediaDetails: _mediaDetails),
                            Overview(),
                            SizedBox(height: 20),
                            RelatedMovies(
                              upComingMovies: upComingMovies,
                              widget: widget,
                            ),
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

  Overview() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
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
                widget.media.overview,
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
          const SizedBox(height: 0),
          GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () => setState(() => _overviewExpanded = !_overviewExpanded),
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: _overviewExpanded ? 160.0 : 0,
              ),
              child: Text(
                _overviewExpanded ? '⌃' : 'Show more',
                style: TextStyle(
                  color: AppColors.textOnDark90,
                  fontSize: _overviewExpanded ? 20 : 15,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  AvailableButton() {
    return Column(
      children: [
        ElevatedButton(
          onPressed: () => setState(() => _showProviders = !_showProviders),
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.White,
            foregroundColor: AppColors.Black,
            textStyle: const TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.bold,
            ),
            elevation: 3,
            padding: const EdgeInsets.symmetric(horizontal: 100, vertical: 12),
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
                child: const Icon(Icons.expand_more, size: 20),
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
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
              child: Column(
                children: [
                  Wrap(
                    alignment: WrapAlignment.start,
                    children: [
                      providerChip('Prime Video', icon: Icons.video_library),
                      providerChip('HBO Max', icon: Icons.tv),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
