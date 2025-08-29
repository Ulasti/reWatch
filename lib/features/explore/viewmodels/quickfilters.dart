import 'package:flutter/material.dart';
import 'package:rewatch/core/constants/app_colors.dart';

enum Category { movies, tv }

class QuickFilter extends StatefulWidget {
  final void Function(Category category, Set<String> selectedFilters)?
  onChanged;
  const QuickFilter({super.key, this.onChanged});

  @override
  State<QuickFilter> createState() => _QuickFilterState();
}

class _QuickFilterState extends State<QuickFilter> {
  Category _active = Category.movies;
  final Map<Category, String?> _selected = {
    Category.movies: null,
    Category.tv: null,
  };

  void _toggleCategory() {
    setState(() {
      _active = _active == Category.movies ? Category.tv : Category.movies;
    });
    final sel = _selected[_active] == null ? <String>{} : {_selected[_active]!};
    widget.onChanged?.call(_active, sel);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _toggleCategory,
      child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 2),
        transitionBuilder: (child, anim) =>
            ScaleTransition(scale: anim, child: child),
        child: Icon(
          _active == Category.movies ? Icons.movie_rounded : Icons.tv_rounded,
          key: ValueKey(_active),
          size: 28,
          color: AppColors.textOnDark90,
        ),
      ),
    );
  }
}
