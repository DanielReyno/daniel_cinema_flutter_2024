import 'package:moviedb_app/domain/entities/actor.dart';

abstract class ActorRepositories {

  Future<List<Actor>> getMovieCast(String movieId);
}