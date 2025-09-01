import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:rewatch/core/constants/app_colors.dart';
import 'package:rewatch/features/explore/models/tv_model.dart';

class TopMovieCarousel extends StatelessWidget {
  const TopMovieCarousel({super.key, required this.upComingMovies});

  final Future<List<dynamic>> upComingMovies;

  @override
  Widget build(BuildContext context) {
    final screenW = MediaQuery.of(context).size.width;
    final double aspectRatio = 16 / 9;
    final double carouselHeight = screenW / aspectRatio;

    return FutureBuilder<List<dynamic>>(
      future: upComingMovies,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return SizedBox(
            height: carouselHeight,
            child: Center(child: CircularProgressIndicator()),
          );
        }
        if (snapshot.hasError) {
          return SizedBox(
            height: carouselHeight,
            child: Center(child: Text('Error: ${snapshot.error}')),
          );
        }
        final items = snapshot.data ?? [];
        if (items.isEmpty) return SizedBox(height: carouselHeight);

        return CarouselSlider.builder(
          itemCount: items.length,
          itemBuilder: (context, index, movieIndex) {
            final item = items[index];
            // Safely access title (Movies use title, TV shows use name)
            final title = (item is Tv) ? (item.name) : (item.title ?? '');
            final backdrop = item.backdrop_path;
            final imageUrl = 'https://image.tmdb.org/t/p/w1280$backdrop';

            return Padding(
              padding: const EdgeInsets.all(3.0),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.Primary,
                      spreadRadius: 0.3,
                      blurRadius: 1,
                      offset: Offset(0, 0),
                    ),
                  ],
                  color: Colors.transparent,
                ),
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(5),
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
                          padding: const EdgeInsets.all(16.0),
                          child: Text(
                            title, // Now uses the safe title variable
                            maxLines: 2,
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w800,
                              fontSize: 30,
                            ),
                          ),
                        ),
                        SizedBox(height: 5),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
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
                                    backgroundColor: AppColors.Black.withAlpha(
                                      230,
                                    ), // Fixed withValues to withAlpha
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
            height: carouselHeight,
            viewportFraction: 0.9,
            autoPlay: true,
            enlargeCenterPage: true,
            aspectRatio: 1,
            autoPlayInterval: const Duration(seconds: 7),
          ),
        );
      },
    );
  }
}
