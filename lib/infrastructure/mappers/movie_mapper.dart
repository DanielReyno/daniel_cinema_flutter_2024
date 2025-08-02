import 'package:moviedb_app/domain/entities/movie.dart';
import 'package:moviedb_app/infrastructure/models/moviedb/movie_moviedb.dart';
import 'package:moviedb_app/infrastructure/models/moviedb/moviedb_details.dart';

class MovieMapper {
  static Movie mapToMovieEntity(MovieMovieDB moviedb) => Movie(
      adult: moviedb.adult,
      backdropPath: moviedb.backdropPath.isEmpty
          ? "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQO5kCepNdhZvDKJtmPAIWnloSdTal7N1CQaA&s"
          : "https://image.tmdb.org/t/p/w500${moviedb.backdropPath}",
      genreIds: moviedb.genreIds.map((x) => x.toString()).toList(),
      id: moviedb.id,
      originalLanguage: moviedb.originalLanguage,
      originalTitle: moviedb.originalTitle,
      overview: moviedb.overview,
      popularity: moviedb.popularity,
      posterPath: moviedb.posterPath.isEmpty
          ? "https://www.movienewz.com/img/films/poster-holder.jpg"
          : "https://image.tmdb.org/t/p/w500${moviedb.posterPath}",
      releaseDate: moviedb.releaseDate ?? DateTime.now(),
      title: moviedb.title,
      video: moviedb.video,
      voteAverage: moviedb.voteAverage,
      voteCount: moviedb.voteCount,);

  static Movie movieDetailsToEntity(MovieDbDetails moviedb) => Movie(
      adult: moviedb.adult,
      backdropPath: moviedb.backdropPath.isEmpty
          ? "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQO5kCepNdhZvDKJtmPAIWnloSdTal7N1CQaA&s"
          : "https://image.tmdb.org/t/p/w500${moviedb.backdropPath}",
      genreIds: moviedb.genres.map((genre) => genre.name).toList(),
      id: moviedb.id,
      originalLanguage: moviedb.originalLanguage,
      originalTitle: moviedb.originalTitle,
      overview: moviedb.overview,
      popularity: moviedb.popularity,
      posterPath: moviedb.posterPath.isEmpty
          ? "https://www.movienewz.com/img/films/poster-holder.jpg"
          : "https://image.tmdb.org/t/p/w500${moviedb.posterPath}",
      releaseDate: moviedb.releaseDate ?? DateTime.now(),
      title: moviedb.title,
      video: moviedb.video,
      voteAverage: moviedb.voteAverage,
      voteCount: moviedb.voteCount,);
}
