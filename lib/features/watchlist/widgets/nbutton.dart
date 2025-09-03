import 'package:flutter/material.dart' hide BoxDecoration, BoxShadow;
import 'package:rewatch/core/constants/app_colors.dart';
import 'package:flutter_inset_box_shadow_update/flutter_inset_box_shadow_update.dart';

class NButton extends StatefulWidget {
  final String title;
  const NButton({super.key, required this.title});

  @override
  State<NButton> createState() => _NButtonState();
}

class _NButtonState extends State<NButton> {
  _NButtonState();
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40,
      decoration: BoxDecoration(
        color: Colors.deepPurple,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            offset: const Offset(-3, -3),
            blurRadius: 3,
            color: AppColors.Shadow1,
            inset: true,
          ),
          BoxShadow(
            offset: const Offset(3, 3),
            blurRadius: 3,
            color: AppColors.Shadow3,
            inset: true,
          ),
          BoxShadow(
            offset: const Offset(-3, -3),
            blurRadius: 3,
            color: AppColors.Shadow3,
            inset: false,
          ),
          BoxShadow(
            offset: const Offset(3, 3),
            blurRadius: 3,
            color: AppColors.Shadow1,
            inset: false,
          ),
        ],
      ),
      child: Center(
        child: Text(
          widget.title,
          style: TextStyle(
            color: AppColors.Primary,
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
      ),
    );
  }
}
