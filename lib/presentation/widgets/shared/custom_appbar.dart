import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:moviedb_app/domain/entities/movie.dart';
import 'package:moviedb_app/presentation/delegates/search_movie_delegate.dart';
import 'package:moviedb_app/presentation/providers/providers.dart';

class CustomAppbar extends ConsumerWidget {
  const CustomAppbar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appTheme = Theme.of(context).colorScheme;
    final textStyle = Theme.of(context).textTheme.titleMedium;
    final searchedMoviesProvider = ref.read(getSearchedMoviesProvider.notifier).checkCachedQuerys;
    final initialMovies = ref.watch(getSearchedMoviesProvider);
    final getSearchQuery = ref.watch(getSearchQueryProvider);
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: SizedBox(
          width: double.infinity,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              
              Icon(Icons.movie_outlined, color: appTheme.primary,),
              const SizedBox(width: 5,),
              Text("Daniel Cinema", style: textStyle,),
              const Spacer(),
              IconButton(
                padding: const EdgeInsets.only(top: 15),
                onPressed: () {
                showSearch<Movie?>(
                  query: getSearchQuery,
                  context: context, 
                  delegate: SearchMovieDelegate(
                    initialData: initialMovies,
                    callback: searchedMoviesProvider
                    )).then((movie){
                      if(movie == null) return;
                    // ignore: use_build_context_synchronously
                    context.push("/movie/${movie.id}");
                  });
                  
              }, icon: const Icon(Icons.search_outlined))
            ],
          ),
        ),
      )
      );
  }
}