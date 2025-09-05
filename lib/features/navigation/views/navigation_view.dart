import 'package:flutter/material.dart';
import 'package:rewatch/features/explore/views/explore_view.dart';
import 'package:rewatch/features/profile/views/profile_view.dart';
import 'package:rewatch/features/watchlist/views/watchlist_view.dart';

class NavigationView extends StatefulWidget {
  const NavigationView({super.key});

  @override
  State<NavigationView> createState() => _NavigationViewState();
}

class _NavigationViewState extends State<NavigationView> {
  int navIndex = 1;
  List<Widget> pages = [
    const WatchlistView(),
    const ExploreView(),
    const ProfileView(),
  ];
  @override
  Widget build(BuildContext context) {
    final bottomPadding = MediaQuery.of(context).padding.bottom;
    const double visualNavHeight = 60.0;
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.onSurface,
      body: pages[navIndex],
      bottomNavigationBar: SizedBox(
        height: visualNavHeight + bottomPadding,
        child: BottomNavigationBar(
          backgroundColor: Colors.transparent,
          type: BottomNavigationBarType.fixed,
          showSelectedLabels: false,
          showUnselectedLabels: false,
          onTap: (index) => setState(() => navIndex = index),
          selectedIconTheme: IconThemeData(
            color: Theme.of(context).colorScheme.primary,
            size: 22,
          ),
          unselectedIconTheme: IconThemeData(
            color: Theme.of(context).colorScheme.secondary,
            size: 20,
          ),
          currentIndex: navIndex,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.bookmark_outline, size: 24),
              activeIcon: Icon(Icons.bookmark, size: 24),
              label: '',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.explore_outlined, size: 24),
              activeIcon: Icon(Icons.explore, size: 24),
              label: '',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person_outline, size: 24),
              activeIcon: Icon(Icons.person, size: 24),
              label: '',
            ),
          ],
        ),
      ),
    );
  }
}
