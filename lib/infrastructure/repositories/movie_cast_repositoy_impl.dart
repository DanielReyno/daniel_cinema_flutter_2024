import 'package:moviedb_app/domain/datasources/actor_datasource.dart';
import 'package:moviedb_app/domain/entities/actor.dart';
import 'package:moviedb_app/domain/repositories/actor_repositories.dart';

class MovieCastRepositoyImpl extends ActorRepositories{
  final ActorDatasource datasource;

  MovieCastRepositoyImpl({required this.datasource});

  @override
  Future<List<Actor>> getMovieCast(String movieId) {
    return datasource.getMovieCast(movieId);
  }

}