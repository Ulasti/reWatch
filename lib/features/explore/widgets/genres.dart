import 'package:flutter/material.dart';
import 'package:rewatch/core/constants/app_colors.dart';
import 'package:rewatch/features/explore/models/media_model.dart';

class Genres extends StatelessWidget {
  const Genres({super.key, required MediaDetails? mediaDetails})
    : _mediaDetails = mediaDetails;

  final MediaDetails? _mediaDetails;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Text(
        _mediaDetails?.genres.join(' • ') ?? '',
        style: TextStyle(
          color: AppColors.textOnDark60,
          fontSize: 16,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}
