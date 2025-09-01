import 'package:flutter/material.dart';
import 'package:rewatch/core/constants/app_colors.dart';

Widget providerChip(String label, {IconData? icon}) {
  return Container(
    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
    margin: const EdgeInsets.symmetric(horizontal: 6, vertical: 6),
    decoration: BoxDecoration(
      color: AppColors.textOnDark10,
      borderRadius: BorderRadius.circular(20),
    ),
    child: Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (icon != null) ...[
          Icon(icon, size: 20, color: AppColors.textOnDark50),
          const SizedBox(width: 8),
        ],
        Text(
          label,
          style: const TextStyle(
            color: AppColors.textOnDark50,
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    ),
  );
}
