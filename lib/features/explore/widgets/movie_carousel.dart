import 'package:flutter/material.dart';
import 'package:rewatch/core/constants/app_colors.dart';
import 'package:rewatch/features/explore/views/detail_page.dart';
import 'package:rewatch/features/explore/viewmodels/quickfilters.dart';

class MovieCarousel extends StatelessWidget {
  const MovieCarousel({
    super.key,
    required this.popularMovies,
    required this.title,
    required this.category,
  });

  final Future<List<dynamic>> popularMovies;
  final String title;
  final Category category;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<dynamic>>(
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
          height: 250,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: movies.length,
            itemBuilder: (context, index) {
              final item = movies[index];
              final posterPath = item.poster_path;
              final posterUrl = 'https://image.tmdb.org/t/p/w500$posterPath';

              return GestureDetector(
                onTap: () {
                  Navigator.of(context).push(
                    PageRouteBuilder(
                      pageBuilder: (_, __, ___) =>
                          DetailPage(media: item, category: category),
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
