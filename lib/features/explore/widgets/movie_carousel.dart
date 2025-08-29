import 'package:flutter/material.dart';
import 'package:rewatch/core/constants/app_colors.dart';
import 'package:rewatch/features/explore/models/movie_model.dart';
import 'package:rewatch/features/explore/views/detail_page.dart';

class MovieCarousel extends StatelessWidget {
  const MovieCarousel({
    super.key,
    required this.popularMovies,
    this.isTv = false,
  });

  final Future<List<Movies>> popularMovies;
  final bool isTv;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Movies>>(
      future: popularMovies,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const SizedBox(
            height: 250,
            child: Center(child: CircularProgressIndicator()),
          );
        }
        if (snapshot.hasError) {
          return SizedBox(
            height: 250,
            child: Center(child: Text('Error: ${snapshot.error}')),
          );
        }
        final movies = snapshot.data ?? [];
        if (movies.isEmpty) return const SizedBox(height: 250);

        return SizedBox(
          height: 270,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: movies.length,
            itemBuilder: (context, index) {
              final movie = movies[index];
              final poster = movie.poster_path;
              final posterUrl = 'https://image.tmdb.org/t/p/w500$poster';

              return GestureDetector(
                onTap: () {
                  Navigator.of(context).push(
                    PageRouteBuilder(
                      pageBuilder: (_, __, ___) =>
                          DetailPage(movie: movie, isTv: isTv),
                      transitionsBuilder: (_, anim, __, child) {
                        final fade = CurvedAnimation(
                          parent: anim,
                          curve: Curves.easeIn,
                        );
                        final scale = Tween(
                          begin: 0.95,
                          end: 1.0,
                        ).animate(anim);
                        return FadeTransition(
                          opacity: fade,
                          child: ScaleTransition(scale: scale, child: child),
                        );
                      },
                    ),
                  );
                },
                child: Container(
                  width: 150,
                  margin: const EdgeInsets.symmetric(horizontal: 8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 15),
                      Expanded(
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.network(
                            posterUrl,
                            fit: BoxFit.fill,
                            width: double.infinity,
                            errorBuilder: (_, __, ___) =>
                                Container(color: AppColors.Grey),
                          ),
                        ),
                      ),
                      SizedBox(height: 15),
                    ],
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }
}
