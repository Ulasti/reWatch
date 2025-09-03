import 'package:animated_toggle_switch/animated_toggle_switch.dart';
import 'package:flutter/material.dart';
import 'package:rewatch/core/constants/app_colors.dart';
import 'package:rewatch/features/explore/viewmodels/quickfilters.dart';
import 'package:rewatch/features/watchlist/widgets/nbackground.dart';
import 'package:rewatch/features/watchlist/widgets/nbutton.dart';
import 'package:rewatch/features/watchlist/widgets/watchlist_grid.dart';

class WatchlistView extends StatefulWidget {
  const WatchlistView({super.key});

  @override
  State<WatchlistView> createState() => _WatchlistViewState();
}

class _WatchlistViewState extends State<WatchlistView>
    with TickerProviderStateMixin {
  late TabController _tabController;

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
    return Scaffold(
      backgroundColor: AppColors.Primary,
      body: Padding(
        padding: const EdgeInsets.only(left: 8.0, right: 8.0, top: 35.0),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Center(
                child: Text(
                  'My Collection',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: AppColors.Grey,
                  ),
                ),
              ),
            ),
            Stack(
              alignment: AlignmentDirectional.center,
              children: [
                NBackground(title: '', bgheight: '80'),
                Center(
                  child: CustomAnimatedToggleSwitch<int>(
                    current: _tabController.index,
                    animationDuration: const Duration(milliseconds: 200),
                    spacing: 40,
                    indicatorSize: Size(150, 65),
                    values: [0, 1],
                    onChanged: (value) {
                      setState(() {
                        _tabController.animateTo(value);
                      });
                    },
                    iconBuilder: (context, local, global) {
                      return Center(
                        child: Text(
                          local.value == 0 ? 'Movies' : 'TV Shows',
                          style: TextStyle(color: AppColors.Grey),
                        ),
                      );
                    },
                    foregroundIndicatorBuilder: (context, global) {
                      return NButton(
                        title: global.current == 0 ? 'Movies' : 'TV Shows',
                      );
                    },
                  ),
                ),
              ],
            ),
            SizedBox(height: 12),
            Expanded(
              child: Stack(
                children: [
                  // NBackground(title: '', bgheight: '500'),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TabBarView(
                      physics: NeverScrollableScrollPhysics(),
                      controller: _tabController,
                      children: [
                        WatchlistGrid(
                          listType: 'movie_watchlist',
                          category: Category.movies,
                        ),
                        WatchlistGrid(
                          listType: 'series_watchlist',
                          category: Category.tv,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
