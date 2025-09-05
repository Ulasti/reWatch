import 'package:flutter/material.dart';
import 'package:rewatch/core/constants/app_colors.dart';
import 'package:rewatch/core/widgets/custom_shadow.dart';

enum ListType { watchlist, watched }

class WatchlistFilter extends StatefulWidget {
  final Function(ListType) onChanged;
  const WatchlistFilter({super.key, required this.onChanged});

  @override
  State<WatchlistFilter> createState() => _WatchlistFilterState();
}

class _WatchlistFilterState extends State<WatchlistFilter> {
  ListType _listType = ListType.watched;

  void _toggleListType() {
    setState(() {
      _listType = _listType == ListType.watchlist
          ? ListType.watched
          : ListType.watchlist;
    });
    widget.onChanged(_listType);
  }

  @override
  Widget build(BuildContext context) {
    return CustomShadow(
      blurRadius: 3.0,
      spreadRadius: 0.0,
      borderRadius: BorderRadius.circular(15),
      offset1: 2,
      offset2: 2,
      inset: _listType == ListType.watched,
      child: IconButton(
        highlightColor: Colors.transparent,
        onPressed: _toggleListType,
        icon: AnimatedSwitcher(
          duration: const Duration(milliseconds: 500),
          transitionBuilder: (child, anim) =>
              ScaleTransition(scale: anim, child: child),
          child: Padding(
            padding: EdgeInsets.all(2.0),
            child: Icon(
              _listType == ListType.watched
                  ? Icons.bookmarks_outlined
                  : Icons.check_circle_outline,
              key: ValueKey(_listType),
              size: _listType == ListType.watched ? 15 : 15,
              color: AppColors.Grey,
            ),
          ),
        ),
      ),
    );
  }
}
