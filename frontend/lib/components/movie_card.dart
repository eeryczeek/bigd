import 'package:flutter/material.dart';
import 'package:frontend/models.dart';
import 'package:frontend/pages/seat_selection_page.dart';

class MovieCard extends StatefulWidget {
  final Movie movie;
  final Color color;

  const MovieCard({required this.movie, required this.color});

  @override
  _MovieCardState createState() => _MovieCardState();
}

class _MovieCardState extends State<MovieCard> {
  bool showTimetable = false;
  List<DateTime>? showTimes;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() {
          showTimes ??= getShowTimes();
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
                  itemCount: showTimes?.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Text(showTimes![index].toString()),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => SeatSelectionPage(
                              movieShow: MovieShow(
                                uuid: 'uuid',
                                movie: widget.movie,
                                cinemaRoomUuid: 'uuid',
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

List<DateTime> getShowTimes() {
  return [
    DateTime.now().add(const Duration(hours: 1)),
    DateTime.now().add(const Duration(hours: 2)),
    DateTime.now().add(const Duration(hours: 3)),
  ];
}
