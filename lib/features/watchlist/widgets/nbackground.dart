import 'package:flutter/material.dart' hide BoxDecoration, BoxShadow;
import 'package:rewatch/core/constants/app_colors.dart';
import 'package:flutter_inset_box_shadow_update/flutter_inset_box_shadow_update.dart';

class NBackground extends StatefulWidget {
  final String title;
  final String bgheight;
  const NBackground({super.key, required this.title, required this.bgheight});

  @override
  State<NBackground> createState() => _NBackgroundState();
}

class _NBackgroundState extends State<NBackground> {
  _NBackgroundState();
  @override
  Widget build(BuildContext context) {
    return Container(
      height: double.parse(widget.bgheight),
      decoration: BoxDecoration(
        color: AppColors.Primary,
        borderRadius: BorderRadius.circular(25),
        boxShadow: [
          BoxShadow(
            offset: const Offset(-5, -5),
            blurRadius: 10,
            color: AppColors.Shadow3,
            inset: true,
          ),
          BoxShadow(
            offset: const Offset(5, 5),
            blurRadius: 10,
            color: AppColors.Shadow1,
            inset: true,
          ),
        ],
      ),
      child: Center(child: Text(widget.title)),
    );
  }
}
