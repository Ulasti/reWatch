import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:rewatch/core/constants/app_colors.dart';
import 'package:rewatch/features/explore/models/movie_model.dart';

class TopMovieCarousel extends StatelessWidget {
  const TopMovieCarousel({super.key, required this.upComingMovies});

  final Future<List<Movies>> upComingMovies;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Movies>>(
      future: upComingMovies,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const SizedBox(
            height: 180,
            child: Center(child: CircularProgressIndicator()),
          );
        }
        if (snapshot.hasError) {
          return SizedBox(
            height: 180,
            child: Center(child: Text('Error: ${snapshot.error}')),
          );
        }
        final movies = snapshot.data ?? [];
        if (movies.isEmpty) return const SizedBox(height: 180);

        return CarouselSlider.builder(
          itemCount: movies.length,
          itemBuilder: (context, index, movieIndex) {
            final movie = movies[index];
            final title = movie.title;
            final backdrop = movie.backdrop_path;
            final imageUrl = 'https://image.tmdb.org/t/p/w780$backdrop';

            return Padding(
              padding: const EdgeInsets.all(8),
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.Primary,
                      spreadRadius: 1,
                      blurRadius: 2,
                      offset: Offset(0, 0),
                    ),
                  ],
                  color: AppColors.Grey,
                ),

                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.network(
                        imageUrl,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) =>
                            Container(color: AppColors.Grey),
                      ),
                    ),

                    Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Text(
                            title,
                            maxLines: 3,
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w800,
                              fontSize: 45,
                            ),
                          ),
                        ),
                        SizedBox(height: 5),
                        Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Container(
                            height: 35,
                            width: 250,
                            color: Colors.transparent,
                            child: Row(
                              children: [
                                ElevatedButton(
                                  onPressed: () {},
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: AppColors.Black,
                                    foregroundColor: AppColors.White,
                                    textStyle: const TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    elevation: 3,
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 21,
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(5),
                                    ),
                                    shadowColor: AppColors.Primary,
                                  ),
                                  child: Text('Available on'),
                                ),
                                SizedBox(width: 10),
                                ElevatedButton(
                                  onPressed: () {},
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: AppColors.Black.withValues(
                                      alpha: 0.9,
                                    ),
                                    foregroundColor: AppColors.White,
                                    textStyle: const TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    elevation: 3,
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 21,
                                      vertical: 0,
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(5),
                                    ),
                                    shadowColor: AppColors.Primary,
                                  ),
                                  child: Text('+ Watchlist'),
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
          options: CarouselOptions(
            autoPlay: false,
            enlargeCenterPage: true,
            aspectRatio: 1,
            autoPlayInterval: const Duration(seconds: 10),
          ),
        );
      },
    );
  }
}
