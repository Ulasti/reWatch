import 'package:flutter/material.dart' hide BoxDecoration, BoxShadow;
import 'package:rewatch/core/constants/app_colors.dart';
import 'package:flutter_inset_shadow/flutter_inset_shadow.dart';

class NBackground extends StatefulWidget {
  final String title;
  final String bgheight;
  final String bgwidth;
  final bool inset;
  final double borderRadius;
  const NBackground({
    super.key,
    required this.title,
    required this.bgheight,
    required this.bgwidth,
    required this.borderRadius,
    this.inset = true,
  });

  @override
  State<NBackground> createState() => _NBackgroundState();
}

class _NBackgroundState extends State<NBackground> {
  _NBackgroundState();
  @override
  Widget build(BuildContext context) {
    return Container(
      height: double.parse(widget.bgheight),
      width: double.parse(widget.bgwidth),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(widget.borderRadius),
        boxShadow: [
          BoxShadow(
            offset: const Offset(-1, -1),
            blurRadius: 5,
            color: AppColors.Shadow3,
            inset: widget.inset,
          ),
          BoxShadow(
            offset: const Offset(1, 1),
            blurRadius: 5,
            color: AppColors.Shadow1,
            inset: widget.inset,
          ),
        ],
      ),
      child: Center(child: Text(widget.title)),
    );
  }
}
