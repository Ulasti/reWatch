import 'package:flutter/material.dart';
import 'package:rewatch/core/constants/app_colors.dart';
import 'package:rewatch/features/explore/viewmodels/quickfilters.dart';

class CustomAppBar extends StatelessWidget {
  final void Function(Category category, Set<String> selectedFilters)?
  onFilterChanged;
  const CustomAppBar({super.key, this.onFilterChanged});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: 45),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            children: [
              QuickFilter(onChanged: onFilterChanged),
              SizedBox(width: 10),
              Text(
                'Explore',
                style: TextStyle(
                  color: AppColors.textOnDark90,
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(width: 144),
              IconButton(
                onPressed: () {},
                icon: Icon(Icons.search_rounded, color: AppColors.textOnDark90),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
