import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:moviedb_app/domain/entities/actor.dart';
import 'package:moviedb_app/domain/entities/movie.dart';
import 'package:moviedb_app/presentation/providers/movie_cast/movie_cast_provider.dart';
import 'package:moviedb_app/presentation/providers/providers.dart';

class MovieScreen extends ConsumerStatefulWidget {
  final String movieId;
  const MovieScreen({super.key, required this.movieId});

  static const name = "/movie-screen";

  @override
  MovieScreenState createState() => MovieScreenState();
}

class MovieScreenState extends ConsumerState<MovieScreen> {
  @override
  void initState() {
    super.initState();
    ref.read(getMovieDetailsProvider.notifier).getMoviesDetails(widget.movieId);
    ref.read(movieCastProvider.notifier).getMovieCast(widget.movieId);
  }

  @override
  Widget build(BuildContext context) {
    final movieDetails = ref.watch(getMovieDetailsProvider)[widget.movieId];
    final movieActors = ref.watch(movieCastProvider)[widget.movieId];

    if (movieDetails == null) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return Scaffold(
      body: CustomScrollView(
        physics: const RangeMaintainingScrollPhysics(),
        slivers: [
          _CustoSliverAppBar(movie: movieDetails),
          SliverList(
              delegate: SliverChildBuilderDelegate(
                  childCount: 1,
                  (context, index) => _MovieDescription(
                        movie: movieDetails,
                        movieActors: movieActors ?? [],
                      )))
        ],
      ),
    );
  }
}

class _MovieDescription extends StatelessWidget {
  final Movie movie;
  final List<Actor> movieActors;
  const _MovieDescription({required this.movie, required this.movieActors});

  @override
  Widget build(BuildContext context) {
    final appSize = MediaQuery.of(context).size;
    final appTextTheme = Theme.of(context).textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(8),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: appSize.width * 0.3,
                child: ClipRRect(
                  borderRadius: const BorderRadius.all(Radius.circular(20)),
                  child: Image.network(movie.posterPath),
                ),
              ),
              const SizedBox(
                width: 10,
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      movie.title,
                      style: appTextTheme.titleLarge,
                    ),
                    Text(movie.overview)
                  ],
                ),
              )
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8),
          child: Wrap(
            children: [
              ...movie.genreIds.map((genreId) => Container(
                    margin: const EdgeInsets.symmetric(horizontal: 5),
                    child: Chip(label: Text(genreId)),
                  ))
            ],
          ),
        ),
        Container(
          margin: const EdgeInsets.only(top: 20),
          height: 260,
          child: ListView.builder(
              itemExtent: 130,
              itemCount: movieActors.length,
              scrollDirection: Axis.horizontal,
              itemBuilder: (context, index) {
                return FadeInRight(
                  child: Container(
                    child: Column(
                      children: [
                        SizedBox(
                          width: appSize.width * 0.3,
                          child: ClipRRect(
                            borderRadius:
                                const BorderRadius.all(Radius.circular(20)),
                            child: Image.network(
                              movieActors[index].profileImage!,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        Text(
                          movieActors[index].name,
                          style: appTextTheme.bodySmall
                              ?.copyWith(fontWeight: FontWeight.bold),
                          textAlign: TextAlign.center,
                        ),
                        Text(
                          movieActors[index].character!,
                          style: appTextTheme.bodySmall,
                          textAlign: TextAlign.center,
                        )
                      ],
                    ),
                  ),
                );
              }),
        )
      ],
    );
  }
}

//Provider que solo sera utilizado por este srceen
final isFavoriteProvider = FutureProvider.family.autoDispose((ref, int movieId){
  final localStorageRepository = ref.watch(localRepositoryProvider);
  return localStorageRepository.isMovieFavorite(movieId);
});

class _CustoSliverAppBar extends ConsumerWidget {
  final Movie movie;
  const _CustoSliverAppBar({required this.movie});

  @override
  Widget build(BuildContext context, WidgetRef ref) {

    final isFavoriteFuture = ref.watch(isFavoriteProvider(movie.id));

    final appSize = MediaQuery.of(context).size;

    return SliverAppBar(
      backgroundColor: Colors.black,
      expandedHeight: appSize.height * 0.7,
      foregroundColor: Colors.white,
      actions: [
        IconButton(
            onPressed: () {
              ref.watch(localRepositoryProvider).toggleFavorites(movie).then((_){
                //Tenemos que invalidar nuevamente el isFavoriteProvider para actualizar
                //el icono una vez realizada la transaccion a la base de datos.
                //como estamos trabajando con funciones asincronas debemos forzar a que una
                //de estas funciones se ejecute despues de la otra, para no provocar bugs
                //en la interfaz de usuario.

                //de no ser asi es posible que la validacion ocurra/termine primero que la
                //funcion para añadir las peliculas favoritas a la base de datos (toggleFavorites)

                //Esto lo solucionamos con el metodo .then de una funcion Future.
                ref.invalidate(isFavoriteProvider(movie.id));
                ref.read(favoritesMoviesProvider.notifier).refreshFavoritesMovies(movie);
              });

              // ref.invalidate(isFavoriteProvider(movie.id));
            }, 
            icon: isFavoriteFuture.when(
              data: (isFavorite) => isFavorite
              ? const Icon(Icons.favorite_rounded, color: Colors.red,)
              : const Icon(Icons.favorite_border_outlined),
              error: (_,__) => throw UnimplementedError(), 
              loading: () => const CircularProgressIndicator())),
            
            // const Icon(Icons.favorite_border_outlined))
      ],
      flexibleSpace: FlexibleSpaceBar(
        centerTitle: false,
        titlePadding: const EdgeInsets.only(left: 10, bottom: 10),
        expandedTitleScale: 1,
        title: Text(
          movie.title,
          style: const TextStyle(color: Colors.white),
        ),
        background: Stack(
          children: [
            SizedBox.expand(
              child: Image.network(
                movie.posterPath,
                fit: BoxFit.cover,
              ),
            ),
            const _CustomGradient(
                begin: Alignment.topCenter, 
                end: Alignment.bottomCenter, 
                stops: [0.7,1], 
                colors: [Colors.transparent, Colors.black87]),
            const _CustomGradient(
              begin: Alignment.topLeft, 
              end: Alignment.bottomRight, 
              stops: [0,0.2], 
              colors: [Colors.black45,Colors.transparent, ]),
            const _CustomGradient(
              begin: Alignment.topRight, 
              end: Alignment.bottomLeft, 
              stops: [0,0.2], 
              colors: [Colors.black45, Colors.transparent])
              
          ],
        ),
      ),
    );
  }
}

class _CustomGradient extends StatelessWidget {
  final AlignmentGeometry begin;
  final AlignmentGeometry end;
  final List<double> stops;
  final List<Color> colors;
  const _CustomGradient(
      {required this.begin,
      required this.end,
      required this.stops,
      required this.colors});

  @override
  Widget build(BuildContext context) {
    return SizedBox.expand(
      child: DecoratedBox(
          decoration: BoxDecoration(
              gradient: LinearGradient(
                  begin: begin, end: end, stops: stops, colors: colors))),
    );
  }
}
