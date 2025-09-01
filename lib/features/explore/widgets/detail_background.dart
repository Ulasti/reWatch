import 'package:flutter/material.dart';

class DetailBackground extends StatelessWidget {
  const DetailBackground({
    super.key,
    required this.posterHeight,
    required this.start,
    required this.end,
  });

  final double posterHeight;
  final Color start;
  final Color end;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: posterHeight,
      left: 0,
      right: 0,
      bottom: 0,
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [start, end.withValues(alpha: 0.1)],
          ),
        ),
      ),
    );
  }
}
