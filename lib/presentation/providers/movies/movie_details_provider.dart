

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:moviedb_app/domain/entities/movie.dart';
import 'package:moviedb_app/presentation/providers/providers.dart';

final getMovieDetailsProvider = StateNotifierProvider<MovieMapNotifier, Map<String,Movie>>((ref){
  final movie = ref.watch(movieRepositoyProvider).getMovieDetails;
  return MovieMapNotifier(callback: movie);
});

// {
//   '30495':Movie(),
//   '30495':Movie(),
//   '20049':Movie(),
// }

typedef GetMovieDetailsCallback = Future<Movie> Function(String moviedb);

class MovieMapNotifier extends StateNotifier<Map<String,Movie>>{

  final GetMovieDetailsCallback callback;

  MovieMapNotifier({
    required this.callback
  }): super({});

  Future<void> getMoviesDetails(String movieId) async {
    if(state[movieId] != null){
      return;
    }
    final movie = await callback(movieId);

    //  {...state} significa copiar el estado anterior y actualizarlo con los nuevos datos (movie)
    // Spread Operator: aqui estamos asignando un Map que contiene una copia del state anterior y es
    // estamos agregandole las peliculas nuevas en un formato Map
    state = {...state, movieId : movie};

  }
}