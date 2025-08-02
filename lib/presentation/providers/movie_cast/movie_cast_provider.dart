

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:moviedb_app/domain/entities/actor.dart';
import 'package:moviedb_app/presentation/providers/providers.dart';

final movieCastProvider = StateNotifierProvider<MovieCastNotifier, Map<String, List<Actor>>>((ref) {
  final apiCall = ref.watch(actorRepositoryProvider).getMovieCast;

  return MovieCastNotifier(callback: apiCall);
});


typedef MovieCastCallback = Future<List<Actor>> Function(String movieId);


class MovieCastNotifier extends StateNotifier<Map<String,List<Actor>>>{

  MovieCastCallback callback;

  MovieCastNotifier({
    required this.callback
  }): super({});

  Future<void> getMovieCast(String movieId) async {
    if(state[movieId] != null) return;

    final actors = await callback(movieId);

    state = {...state, movieId : actors};

  }

}