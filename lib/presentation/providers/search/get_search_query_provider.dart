

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:moviedb_app/domain/entities/movie.dart';
import 'package:moviedb_app/presentation/providers/movies/movie_repository_provider.dart';

final getSearchQueryProvider = StateProvider<String>((ref) => '');

// Map<String,List<Movie>> = {
//  "user_quey": List<Movie> movies;
//
//}

final getSearchedMoviesProvider = StateNotifierProvider<SearchedMoviesController, Map<String,List<Movie>>>((ref) {
  final apiCall = ref.read(movieRepositoyProvider).searchMovie;

  return SearchedMoviesController(callback: apiCall, ref: ref);
});


typedef GetSearchedMoviesCallback = Future<List<Movie>> Function(String query);
//Esta clase retornara el estado que maneja en este caso retornara un valor de tipo Map<String, List<Moie>>
class SearchedMoviesController extends StateNotifier<Map<String,List<Movie>>>{
  
  final GetSearchedMoviesCallback callback;
  final Ref ref;

  SearchedMoviesController({
    required this.callback,
    required this.ref
  }): super({});

  Future<Map<String,List<Movie>>> checkCachedQuerys(String query) async {
    // if(state[query] != null) return state;
    print(state[query]);
    
    final movies = await callback(query);

    ref.read(getSearchQueryProvider.notifier).update((state) => query);

    state = {...state, query:movies};

    return state;
  }
}