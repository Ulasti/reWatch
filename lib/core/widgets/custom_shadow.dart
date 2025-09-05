import 'package:flutter/material.dart' hide BoxDecoration, BoxShadow;
import 'package:rewatch/core/constants/app_colors.dart';
import 'package:flutter_inset_shadow/flutter_inset_shadow.dart';

class CustomShadow extends StatelessWidget {
  final Widget child;

  final double blurRadius;
  final double spreadRadius;
  final double offset1;
  final double offset2;
  final BorderRadius? borderRadius;
  final EdgeInsetsGeometry padding;
  final bool inset;

  const CustomShadow({
    Key? key,
    required this.child,
    required this.blurRadius,
    required this.spreadRadius,
    required this.offset1,
    required this.offset2,
    this.borderRadius,
    this.padding = EdgeInsets.zero,
    this.inset = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding,
      decoration: BoxDecoration(
        color: AppColors.Primary,
        borderRadius: borderRadius ?? BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            offset: Offset(-offset1.toDouble(), -offset1.toDouble()),
            blurRadius: blurRadius,
            spreadRadius: spreadRadius,
            color: AppColors.Shadow1,
            inset: inset,
          ),
          BoxShadow(
            offset: Offset(offset1.toDouble(), offset1.toDouble()),
            blurRadius: blurRadius,
            spreadRadius: spreadRadius,
            color: AppColors.Shadow3,
            inset: inset,
          ),
          BoxShadow(
            offset: Offset(offset1.toDouble(), offset1.toDouble()),
            blurRadius: blurRadius,
            spreadRadius: spreadRadius,
            color: AppColors.Shadow3,
            inset: inset,
          ),
          BoxShadow(
            offset: Offset(-offset1.toDouble(), -offset1.toDouble()),
            blurRadius: blurRadius,
            spreadRadius: spreadRadius,
            color: AppColors.Shadow1,
            inset: inset,
          ),
        ],
      ),
      child: child,
    );
  }
}
