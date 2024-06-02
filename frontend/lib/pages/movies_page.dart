import 'package:flutter/material.dart';
import 'package:frontend/models.dart';
import 'package:frontend/services.dart';
import 'package:frontend/components/movie_card.dart';
import 'dart:math';

class MoviesPage extends StatefulWidget {
  const MoviesPage({super.key, required this.title});
  final String title;

  @override
  State<MoviesPage> createState() => _MoviesPageState();
}

class _MoviesPageState extends State<MoviesPage> {
  Future<List<Movie>> movies = fetchMovies();

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
          child: FutureBuilder<List<Movie>>(
            future: movies,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const CircularProgressIndicator();
              } else if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              } else {
                return GridView.count(
                  crossAxisSpacing: 64,
                  mainAxisSpacing: 64,
                  crossAxisCount: 3,
                  childAspectRatio: 0.8,
                  children: snapshot.data!.map((movie) {
                    return MovieCard(
                      movie: movie,
                      color: Colors
                          .primaries[Random().nextInt(Colors.primaries.length)],
                    );
                  }).toList(),
                );
              }
            },
          ),
        ),
      ),
    );
  }
}
