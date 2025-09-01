import 'package:flutter/material.dart';
import 'package:rewatch/core/constants/app_colors.dart';

class DetailPoster extends StatelessWidget {
  const DetailPoster({
    super.key,
    required this.posterHeight,
    required this.backdropUrl,
    required this.posterFadeHeight,
    required this.start,
  });

  final double posterHeight;
  final String? backdropUrl;
  final double posterFadeHeight;
  final Color start;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: posterHeight,
      width: double.infinity,
      child: Stack(
        fit: StackFit.expand,
        children: [
          Image.network(
            backdropUrl!,
            fit: BoxFit.cover,
            errorBuilder: (_, __, ___) => Container(color: AppColors.Grey),
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
                    start.withValues(alpha: 1),
                    start.withValues(alpha: 0.7),
                    start.withValues(alpha: 0.3),
                    start.withValues(alpha: 0.1),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
