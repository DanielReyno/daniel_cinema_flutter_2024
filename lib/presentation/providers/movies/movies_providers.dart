

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:moviedb_app/domain/entities/movie.dart';
import 'package:moviedb_app/presentation/providers/movies/movie_repository_provider.dart';
//StateNotifierProvider es uno de los provider que dispone Riverpod y se utiliza para
//gestionar estados mas complicacdos, su funcionamiento se basa en relacionarlo con una clase
//quien se encargara de controlar esta misma y al mismo tiempo debemos de especificar cual es el
//estado que se manejara.
final nowPlayingMoviesProvider = StateNotifierProvider<MoviesNotifier, List<Movie>>((ref){
  final fetchMoreMovies = ref.watch(movieRepositoyProvider).getNowPlaying;
  
  return MoviesNotifier(fetchMoreMovies: fetchMoreMovies); 
});

final getUpcomingMoviesProvider = StateNotifierProvider<MoviesNotifier, List<Movie>>((ref){

  final fetchMoreMovies = ref.watch(movieRepositoyProvider).getUpcoming;

  return MoviesNotifier(fetchMoreMovies: fetchMoreMovies);
});

final getTopRatedMoviesProvider = StateNotifierProvider<MoviesNotifier, List<Movie>>((ref){
  final fetchMoreMovies = ref.watch(movieRepositoyProvider).getTopRated;

  return MoviesNotifier(fetchMoreMovies: fetchMoreMovies);
});

typedef MovieCallBack = Future<List<Movie>> Function({int page});

class MoviesNotifier extends StateNotifier<List<Movie>>{

  int currentPage = 0;
  bool isLoading = false;
  MovieCallBack fetchMoreMovies;

  MoviesNotifier(
    {required this.fetchMoreMovies}
  ): super([]);

  Future<void> loadNextPage() async {
    if(isLoading) return;
    print(currentPage);
    isLoading = true;
    currentPage++;
    final List<Movie> movies = await fetchMoreMovies(page: currentPage);
    state = [...state, ...movies];
    await Future.delayed(const Duration(milliseconds: 300));
    isLoading = false;
  }

}