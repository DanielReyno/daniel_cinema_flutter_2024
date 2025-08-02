import 'package:moviedb_app/domain/entities/actor.dart';

abstract class ActorDatasource {

  Future<List<Actor>> getMovieCast(String movieId);
}