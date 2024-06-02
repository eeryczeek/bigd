import 'package:flutter/material.dart';
import 'package:frontend/models.dart';
import 'package:frontend/pages/seat_selection_page.dart';
import 'package:frontend/services.dart';
import 'package:uuid/uuid.dart';

class MovieCard extends StatefulWidget {
  final Movie movie;
  final Color color;

  const MovieCard({required this.movie, required this.color});

  @override
  _MovieCardState createState() => _MovieCardState();
}

class _MovieCardState extends State<MovieCard> {
  bool showTimetable = false;
  List<MovieShow>? movieShows;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() {
          movieShows ??=
              fetchMovieShows(movieUuid: widget.movie.uuid) as List<MovieShow>?;
          showTimetable = !showTimetable;
        });
      },
      child: Card(
        color: widget.color,
        child: Column(
          children: [
            Text(widget.movie.title, style: const TextStyle(fontSize: 32)),
            if (showTimetable)
              Expanded(
                child: ListView.builder(
                  itemCount: movieShows?.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Text(movieShows![index].showTime.toString()),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => SeatSelectionPage(
                              movieShow: MovieShow(
                                uuid: Uuid().v4(),
                                movie: widget.movie,
                                cinemaRoomUuid: Uuid().v4(),
                                showTime: DateTime.now(),
                              ),
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
              )
            else ...[
              Expanded(
                child: Text('Duration: ${widget.movie.duration}',
                    style: const TextStyle(fontSize: 16)),
              ),
            ],
            Text('Rating: ${widget.movie.rating}',
                style: const TextStyle(fontSize: 16)),
            Text('Genres: ${widget.movie.genres}',
                style: const TextStyle(fontSize: 16)),
          ],
        ),
      ),
    );
  }
}
