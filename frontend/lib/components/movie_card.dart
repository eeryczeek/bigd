import 'package:flutter/material.dart';
import 'package:frontend/models/movie.dart';
import 'package:frontend/pages/seats_page.dart';

class MovieCard extends StatefulWidget {
  final Movie movie;
  final Color color;

  const MovieCard({required this.movie, required this.color});

  @override
  _MovieCardState createState() => _MovieCardState();
}

class _MovieCardState extends State<MovieCard> {
  bool showTimetable = false;
  List<String>? showTimes;

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
                      title: Text(showTimes![index]),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => SeatsPage(
                              movieTitle: widget.movie.title,
                              showTime: showTimes![index],
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }
}

List<String> getShowTimes() {
  return [
    '10:00 AM',
    '1:00 PM',
    '4:00 PM',
    '7:00 PM',
    '10:00 PM',
  ];
}
