class Movie {
  final String posterUrl;
  final String title;

  Movie({required this.posterUrl, required this.title});
}

List<Movie> getMovies() {
  return [
    Movie(posterUrl: 'https://example.com/poster1.jpg', title: 'Movie 1'),
    Movie(posterUrl: 'https://example.com/poster2.jpg', title: 'Movie 2'),
    Movie(posterUrl: 'https://example.com/poster3.jpg', title: 'Movie 3'),
    Movie(posterUrl: 'https://example.com/poster4.jpg', title: 'Movie 4'),
    Movie(posterUrl: 'https://example.com/poster5.jpg', title: 'Movie 5'),
    Movie(posterUrl: 'https://example.com/poster6.jpg', title: 'Movie 6'),
  ];
}
