

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:moviedb_app/domain/entities/movie.dart';
import 'package:moviedb_app/presentation/providers/providers.dart';


//Como vamos a trabajar con un tipo de dato complejo y que requiere una pequeña logica de negocio
//tienes que utilizar el stateNotifierProvider junto con el Notifier.


final favoritesMoviesProvider = StateNotifierProvider<StorageMoviesNotifier,Map<int,Movie>>((ref){
  final storageMoviesCall = ref.watch(localRepositoryProvider).loadMovies;

  return StorageMoviesNotifier(favoriteMoviesCallback: storageMoviesCall);
});

typedef GetMoviesCallback = Future<List<Movie>> Function({int limit, int offset});

class StorageMoviesNotifier extends StateNotifier<Map<int,Movie>>{

  final GetMoviesCallback favoriteMoviesCallback;
  int page = 0;

  StorageMoviesNotifier({
    required this.favoriteMoviesCallback
  }): super({});


  Future<List<Movie>> loadNextPage() async {

    final movies = await favoriteMoviesCallback(offset: page * 10);
    page++;
    
    final tempMovies = <int,Movie> {};
    for (var movie in movies) {
      tempMovies[movie.id] = movie;
    }

    state = {...state,...tempMovies};

    return movies;
  }

  Future<void> refreshFavoritesMovies(Movie movie) async {
    
    if(state[movie.id] == null) {
      state[movie.id] = movie;
      }

    else {
      state.remove(movie.id);
      }

    state = {...state};
  }

}