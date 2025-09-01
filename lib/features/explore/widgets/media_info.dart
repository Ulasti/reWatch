import 'package:flutter/material.dart';
import 'package:rewatch/core/constants/app_colors.dart';
import 'package:rewatch/features/explore/models/media_model.dart';

class MediaInfo extends StatelessWidget {
  const MediaInfo({super.key, required MediaDetails? mediaDetails})
    : _mediaDetails = mediaDetails;

  final MediaDetails? _mediaDetails;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Text(
            '${_mediaDetails?.runtimeFormatted}',
            style: TextStyle(
              color: AppColors.textOnDark60,
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
          Text(
            '|',
            style: TextStyle(
              color: AppColors.textOnDark60,
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
          Text(
            _mediaDetails?.releaseYear ?? '',
            style: TextStyle(
              color: AppColors.textOnDark60,
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
          Text(
            '|',
            style: TextStyle(
              color: AppColors.textOnDark60,
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
          Text(
            'IMDb ${_mediaDetails?.voteAverageFormatted ?? '0.0'}',
            style: TextStyle(
              color: AppColors.textOnDark60,
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
