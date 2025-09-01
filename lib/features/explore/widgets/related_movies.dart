import 'package:flutter/material.dart';
import 'package:rewatch/core/constants/app_colors.dart';
import 'package:rewatch/features/explore/views/detail_page.dart';
import 'package:rewatch/features/explore/widgets/movie_carousel.dart';

class RelatedMovies extends StatelessWidget {
  const RelatedMovies({
    super.key,
    required this.upComingMovies,
    required this.widget,
  });

  final Future<List> upComingMovies;
  final DetailPage widget;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
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
        MovieCarousel(
          popularMovies: upComingMovies,
          title: '',
          category: widget.category,
        ),
        SizedBox(height: 200),
      ],
    );
  }
}
