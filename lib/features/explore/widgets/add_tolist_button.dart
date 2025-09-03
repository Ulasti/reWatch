import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rewatch/core/constants/app_colors.dart';
import 'package:rewatch/core/utilities/user_storage.dart';
import 'package:rewatch/features/explore/viewmodels/quickfilters.dart';

class AddToListButton extends StatelessWidget {
  final String title;
  final dynamic media;
  final Category category;
  const AddToListButton({
    super.key,
    required this.title,
    required this.media,
    required this.category,
  });

  @override
  Widget build(BuildContext context) {
    final userStorage = context.read<UserStorage>();
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.white.withValues(alpha: 0.2),
            spreadRadius: 3,
            blurRadius: 7,
            offset: Offset(0, 1),
          ),
        ],
      ),
      child: ElevatedButton(
        onPressed: () async => await _handleAction(userStorage),
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.White,
          foregroundColor: AppColors.Black,
          textStyle: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 17, vertical: 8),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
        child: Text(title),
      ),
    );
  }

  Future<void> _handleAction(UserStorage userStorage) async {
    if (title == 'Add to Watchlist') {
      if (category == Category.movies) {
        await userStorage.addToMovieWatchlist(media.id);
      } else {
        await userStorage.addToSeriesWatchlist(media.id);
      }
    } else if (title == 'Mark as Watched') {
      if (category == Category.movies) {
        await userStorage.addToMovieWatched(media.id);
      } else {
        await userStorage.addToSeriesWatched(media.id);
      }
    }
  }
}
