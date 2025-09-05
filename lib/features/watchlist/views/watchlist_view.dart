import 'dart:ui';
import 'package:oc_liquid_glass/oc_liquid_glass.dart';
import 'package:flutter/material.dart';
import 'package:rewatch/features/explore/viewmodels/quickfilters.dart';
import 'package:rewatch/features/watchlist/widgets/watchlist_grid.dart';
import 'package:rewatch/features/watchlist/widgets/small_filter.dart';

class WatchlistView extends StatefulWidget {
  const WatchlistView({super.key});

  @override
  State<WatchlistView> createState() => _WatchlistViewState();
}

class _WatchlistViewState extends State<WatchlistView>
    with TickerProviderStateMixin {
  late TabController _tabController;
  ListType _listType = ListType.watched;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(_onTabChanged);
  }

  @override
  void dispose() {
    _tabController.removeListener(_onTabChanged);
    _tabController.dispose();
    super.dispose();
  }

  _onTabChanged() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Theme.of(context).colorScheme.tertiary,
            Theme.of(context).colorScheme.primary,
            Theme.of(context).colorScheme.onPrimaryFixedVariant,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          tileMode: TileMode.mirror,
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Padding(
          padding: const EdgeInsets.only(left: 8.0, right: 8.0, bottom: 8),
          child: Stack(
            fit: StackFit.expand,
            children: [
              Column(
                children: [
                  Expanded(
                    child: TabBarView(
                      controller: _tabController,
                      children: [
                        WatchlistGrid(
                          listType: _listType == ListType.watched
                              ? 'movie_watchlist'
                              : 'movie_watched',
                          category: Category.movies,
                        ),
                        WatchlistGrid(
                          listType: _listType == ListType.watched
                              ? 'series_watchlist'
                              : 'series_watched',
                          category: Category.tv,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              Stack(
                children: [
                  OCLiquidGlassGroup(
                    settings: OCLiquidGlassSettings(
                      blendPx: 10,
                      blurRadiusPx: 1,
                      refractStrength: -0.03,
                      specStrength: 0,
                      lightbandColor: Colors.white,
                      lightbandWidthPx: 40,
                    ),
                    child: Stack(
                      children: [
                        Positioned(
                          top: 50,
                          left: 16,
                          child: OCLiquidGlass(
                            color: Colors.white.withValues(alpha: 0.0),
                            width: 50,
                            height: 50,
                            borderRadius: 40,
                            child: IconButton(
                              onPressed: () {
                                if (_listType == ListType.watched) {
                                  _listType = ListType.watchlist;
                                } else if (_listType == ListType.watchlist) {
                                  _listType = ListType.watched;
                                }
                                setState(() {});
                              },
                              icon: Icon(Icons.tv, color: Colors.white),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Positioned(
                    top: 45,
                    right: 12,
                    child: OCLiquidGlassGroup(
                      settings: OCLiquidGlassSettings(
                        blendPx: 10,
                        blurRadiusPx: 1,
                        refractStrength: -0.03,
                        specStrength: 0,
                        lightbandColor: Colors.white,
                        lightbandWidthPx: 30,
                      ),
                      child: Stack(
                        children: [
                          OCLiquidGlass(
                            color: Colors.white.withValues(alpha: 0.2),
                            width: 270,
                            height: 60,
                            borderRadius: 40,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Text(
                                  'Movies',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18,
                                  ),
                                ),
                                Text(
                                  'Tv Series',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Positioned(
                    top: 50,
                    right: 16,
                    child: LiquidGlassToggle(
                      options: const ['Movies', 'TV Shows'],
                      initialValue: _tabController.index,
                      onChanged: (index) {
                        setState(() {
                          _tabController.animateTo(index);
                        });
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class LiquidGlassToggle extends StatefulWidget {
  final List<String> options;
  final Function(int) onChanged;
  final int initialValue;
  final double width;
  final double height;
  final double borderRadius;

  const LiquidGlassToggle({
    super.key,
    required this.options,
    required this.onChanged,
    this.initialValue = 0,
    this.width = 270,
    this.height = 60,
    this.borderRadius = 40,
  });

  @override
  State<LiquidGlassToggle> createState() => _LiquidGlassToggleState();
}

class _LiquidGlassToggleState extends State<LiquidGlassToggle>
    with SingleTickerProviderStateMixin {
  late int selectedIndex;
  late AnimationController _animationController;
  double _dragPosition = 0.0;
  bool _isDragging = false;
  double _indicatorWidth = 170;
  double _indicatorHeight = 60;
  double _indicatorOpacity = 0.1;

  @override
  void initState() {
    super.initState();
    selectedIndex = widget.initialValue;
    _dragPosition = selectedIndex * (widget.width / widget.options.length);
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final optionWidth = widget.width / widget.options.length;

    return OCLiquidGlassGroup(
      settings: OCLiquidGlassSettings(
        blendPx: 10,
        blurRadiusPx: 0,
        refractStrength: _isDragging ? -0.03 : 0,
        specStrength: 0,
        lightbandColor: _isDragging
            ? Colors.white.withValues(alpha: 0.3) // White when dragging
            : Colors.grey.withValues(alpha: 0.3), // Grey when settled
        lightbandWidthPx: _isDragging ? 40 : 1000,
      ),
      child: SizedBox(
        width: 275,
        height: 120,
        child: GestureDetector(
          onHorizontalDragStart: (details) {
            setState(() {
              _isDragging = true;
              _indicatorWidth = 100;
              _indicatorHeight = 80;
              _indicatorOpacity = 0.2;
            });
          },
          onHorizontalDragUpdate: (details) {
            setState(() {
              _dragPosition = (_dragPosition + details.delta.dx).clamp(
                0,
                widget.width - optionWidth,
              );
            });
          },
          onHorizontalDragEnd: (details) {
            final nearestOption = (_dragPosition / optionWidth).round();

            setState(() {
              selectedIndex = nearestOption.clamp(0, widget.options.length - 1);
              _dragPosition = selectedIndex * optionWidth;
              _isDragging = false;
              _animationController.forward(from: 0.0);
              Future.delayed(const Duration(milliseconds: 500), () {
                if (mounted) {
                  setState(() {
                    _indicatorWidth = 100; // Smaller
                    _indicatorHeight = 50; // Smaller
                    _indicatorOpacity = 0.4; // More opaque
                  });
                }
              });
            });

            widget.onChanged(selectedIndex);
          },
          child: Stack(
            children: [
              AnimatedPositioned(
                duration: _isDragging
                    ? Duration.zero
                    : const Duration(milliseconds: 700),
                curve: Curves.elasticOut,
                left: _isDragging
                    ? _dragPosition
                    : selectedIndex * optionWidth + 15,
                // Calculate top to center the expanded element vertically
                top:
                    (25 -
                    _indicatorHeight /
                        2), // Center at 50px (middle of original height)
                child: AnimatedContainer(
                  alignment: Alignment.center,
                  duration: const Duration(milliseconds: 900),
                  curve: Curves.easeOut,
                  width: _indicatorWidth,
                  height: _indicatorHeight,
                  child: OCLiquidGlass(
                    color: Colors.white.withValues(alpha: _indicatorOpacity),
                    width: _indicatorWidth,
                    height: _indicatorHeight,
                    borderRadius: widget.borderRadius,
                    child: Container(
                      alignment: Alignment.center,
                      color: Colors.transparent,
                      width: _indicatorWidth,
                      height: _indicatorHeight,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
