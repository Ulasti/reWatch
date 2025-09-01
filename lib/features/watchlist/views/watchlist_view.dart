import 'package:flutter/material.dart';
import 'package:rewatch/features/watchlist/widgets/collections.dart';
import 'package:rewatch/features/watchlist/widgets/search.dart';

class WatchlistView extends StatefulWidget {
  const WatchlistView({super.key});

  @override
  State<WatchlistView> createState() => _WatchlistViewState();
}

class _WatchlistViewState extends State<WatchlistView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(height: 44),
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(
              'reWatch.',
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
          Search(),
          Collection(title: 'Movies.'),
          Collection(title: 'TV Series.'),
        ],
      ),
    );
  }
}
