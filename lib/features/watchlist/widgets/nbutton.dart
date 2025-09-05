import 'package:flutter/material.dart';
import 'package:oc_liquid_glass/oc_liquid_glass.dart';

class NButton extends StatefulWidget {
  final bool isMoving; // Add property to track movement state
  final double idleOpacity; // Opacity when not moving
  final double movingOpacity; // Opacity when moving

  const NButton({
    super.key,
    this.isMoving = false,
    this.idleOpacity = 0.7,
    this.movingOpacity = 0.4,
  });

  @override
  State<NButton> createState() => _NButtonState();
}

class _NButtonState extends State<NButton> with SingleTickerProviderStateMixin {
  late AnimationController _opacityController;
  late Animation<double> _opacityAnimation;

  @override
  void initState() {
    super.initState();
    _opacityController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _opacityAnimation = Tween<double>(
      begin: widget.idleOpacity,
      end: widget.movingOpacity,
    ).animate(_opacityController);
  }

  @override
  void didUpdateWidget(NButton oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isMoving != oldWidget.isMoving) {
      if (widget.isMoving) {
        _opacityController.forward();
      } else {
        _opacityController.reverse();
      }
    }
  }

  @override
  void dispose() {
    _opacityController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _opacityAnimation,
      builder: (context, child) {
        return OCLiquidGlassGroup(
          settings: OCLiquidGlassSettings(
            distortFalloffPx: 10,
            distortExponent: 5,
            specPower: 2000,
            lightbandOffsetPx: 10,
            lightbandColor: Theme.of(context).colorScheme.onTertiaryContainer,
          ),
          child: Stack(
            children: [
              OCLiquidGlass(
                width: 150,
                height: 40,
                color: Colors.grey.withValues(alpha: _opacityAnimation.value),
                borderRadius: 30,
              ),
            ],
          ),
        );
      },
    );
  }
}
