import 'package:flutter/material.dart';
import 'package:frontend/models/movie.dart';
import 'package:frontend/components/movie_card.dart';
import 'dart:math';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<Movie> movies = getMovies();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.only(top: 64.0, left: 256.0, right: 256.0),
          child: GridView.count(
            crossAxisSpacing: 64,
            mainAxisSpacing: 64,
            crossAxisCount: 3,
            childAspectRatio: 0.8,
            children: movies.map((movie) {
              return MovieCard(
                movie: movie,
                color:
                    Colors.primaries[Random().nextInt(Colors.primaries.length)],
              );
            }).toList(),
          ),
        ),
      ),
    );
  }
}
