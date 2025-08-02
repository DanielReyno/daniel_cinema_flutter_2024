import 'package:moviedb_app/domain/entities/actor.dart';
import 'package:moviedb_app/infrastructure/models/moviedb/movie_cast.dart';

class MovieCastMapper {
  static Actor mapMovieCastToEntity(MovieCast moviedbResponse) => Actor(
      id: moviedbResponse.id, 
      name: moviedbResponse.name, 
      character: moviedbResponse.character, 
      profileImage: (moviedbResponse.profilePath == null)
        ? "https://upload.wikimedia.org/wikipedia/commons/thumb/2/2c/Default_pfp.svg/2048px-Default_pfp.svg.png"
        : "https://image.tmdb.org/t/p/w500${moviedbResponse.profilePath}");
}
