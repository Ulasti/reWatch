import 'package:flutter/material.dart';
import 'package:rewatch/core/constants/app_colors.dart';

class Collection extends StatelessWidget {
  final String title;
  const Collection({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: GestureDetector(
        onTap: () {},
        child: Container(
          height: 150,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15.0),
            color: AppColors.Black,
            border: Border.all(color: AppColors.White, width: 0.5),
            boxShadow: [
              BoxShadow(
                color: AppColors.White.withValues(alpha: 0.5),
                blurRadius: 17.0,
                spreadRadius: 3.0,
                offset: Offset(0, 5),
              ),
            ],
          ),
          child: Center(
            child: Center(
              child: Text(
                title,
                style: TextStyle(
                  fontSize: 50,
                  fontWeight: FontWeight.bold,
                  color: AppColors.White,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
