import 'package:dio/dio.dart';
import 'package:moviedb_app/config/constants/environment.dart';
import 'package:moviedb_app/domain/datasources/actor_datasource.dart';
import 'package:moviedb_app/domain/entities/actor.dart';
import 'package:moviedb_app/infrastructure/mappers/movie_cast_mapper.dart';
import 'package:moviedb_app/infrastructure/models/moviedb/movie_cast_response.dart';

class MovieCastDatasource extends ActorDatasource {

  final dio = Dio(BaseOptions(
    baseUrl: "https://api.themoviedb.org/3",
    queryParameters: {
      'api_key': Environment.theMovieDbKey,
      'language': 'es-MX'
    }
  ));

  @override
  Future<List<Actor>> getMovieCast(String movieId) async {
    final response = await dio.get(
      "/movie/$movieId/credits"
    );
    // Convertimos el formato de la respuesta a nuestro modelo de dato MovieCastResponse
    final parseResponse = MovieCastResponse.fromJson(response.data);

    // Vamos a recorrer la lista para poder mapear cada uno de ellos a nuestra entidad
    final List<Actor> actorList = parseResponse.cast.map((movieCast){
      return MovieCastMapper.mapMovieCastToEntity(movieCast);
    }).toList();

    return actorList;
  }
}