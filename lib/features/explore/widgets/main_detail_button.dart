import 'package:flutter/material.dart';
import 'package:rewatch/core/constants/app_colors.dart';

class MainDetailButton extends StatelessWidget {
  final String title;
  const MainDetailButton({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {},
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.White,
        foregroundColor: AppColors.Black,
        textStyle: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
        elevation: 3,
        padding: const EdgeInsets.symmetric(horizontal: 17, vertical: 13),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        shadowColor: AppColors.Primary,
      ),
      child: Text(title),
    );
  }
}
