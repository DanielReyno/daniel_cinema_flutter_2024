import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:moviedb_app/presentation/providers/providers.dart';
import 'package:moviedb_app/presentation/widgets/widgets.dart';

class HomeView extends ConsumerStatefulWidget {
  const HomeView({
    super.key,
  });

  @override
  // ignore: library_private_types_in_public_api
  _HomeViewState createState() => _HomeViewState();
}

class _HomeViewState extends ConsumerState<HomeView> {

  @override
  void initState() {
  
    super.initState();

    ref.read(nowPlayingMoviesProvider.notifier).loadNextPage();
    ref.read(getTopRatedMoviesProvider.notifier).loadNextPage();
    ref.read(getUpcomingMoviesProvider.notifier).loadNextPage();
  }

  @override
  Widget build(BuildContext context) {

    final initialLoading = ref.watch(initialLoadingProvider);

    if(initialLoading) return const FullScreenLoader();

    final nowPlayingMovies = ref.watch(nowPlayingMoviesProvider);
    final slideShowMovies = ref.watch(movieSlideshowProvider);
    final upcomingMovies = ref.watch(getUpcomingMoviesProvider);
    final topRatedMovies = ref.watch(getTopRatedMoviesProvider);

    return CustomScrollView(
      slivers: [
        const SliverAppBar(
          elevation: 0,
          scrolledUnderElevation: 0,
          floating: true,
          flexibleSpace: FlexibleSpaceBar(
            title: CustomAppbar(),
          ),
        ),

        SliverList(delegate: SliverChildBuilderDelegate(
          (context,index) {
            return Column(
            children: [
              CustomCardSwiper(movies: slideShowMovies),
              MovieHorizontalListview(
                movies: nowPlayingMovies,
                title: "Ver ahora",
                subtitle: "Jueves 22",
                loadNextPage:
                    ref.read(nowPlayingMoviesProvider.notifier).loadNextPage,
              ),
              MovieHorizontalListview(
                movies: upcomingMovies,
                title: "Proximamente",
                subtitle: "Este mes",
                loadNextPage:
                    ref.read(getUpcomingMoviesProvider.notifier).loadNextPage,
              ),
              MovieHorizontalListview(
                movies: topRatedMovies,
                title: "Favoritas",
                subtitle: "Este mes",
                loadNextPage:
                    ref.read(getTopRatedMoviesProvider.notifier).loadNextPage,
              )
            ],
          );
          },
          childCount: 1
        ))
      ],
    );
  }
}