import 'dart:async';

import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:moviedb_app/config/helpers/human_formatter.dart';
import 'package:moviedb_app/domain/entities/movie.dart';

typedef SearchMovieCallback = Future<Map<String,List<Movie>>> Function(String query);


class SearchMovieDelegate extends SearchDelegate<Movie?>{
  final SearchMovieCallback callback;
  Map<String, List<Movie>> initialData;
  StreamController<List<Movie>> debouncedMovies = StreamController.broadcast();
  StreamController<bool> isLoadingScreen = StreamController.broadcast();
  Timer? _debounceTimer;

  SearchMovieDelegate({required this.callback, required this.initialData });

  void _clearStreams(){
    debouncedMovies.close();
  }


  void _onQueryChanged(String query){
    isLoadingScreen.add(true);
    if(_debounceTimer?.isActive ?? false) _debounceTimer!.cancel(); 
    isLoadingScreen.add(true);
    _debounceTimer = Timer(const Duration(milliseconds: 500), () async {
      

      final movies = await callback(query);
    
      initialData = movies;
      isLoadingScreen.add(false);
      return debouncedMovies.add(movies[query]!);
    });
  }

  Widget moviesBuilder() {
    return StreamBuilder(
      initialData: initialData[query],
      stream: debouncedMovies.stream,
      builder: (context,snapshot) {
        if(!snapshot.hasData){
          return const SizedBox();
        }

        return ListView.builder(
          itemCount: snapshot.data?.length,
          itemBuilder: (context, index){
            final movie = snapshot.data?[index];
            return _MoviesCards(
              movie: movie!,
              closeCallback: (context,movies){
                _clearStreams();
                close(context, movies);
              });
        });
      });
  }


  @override
  String get searchFieldLabel => "Buscar pelicula";

  @override
  List<Widget>? buildActions(BuildContext context,) {
    return [

        StreamBuilder(
          initialData: false,
          stream: isLoadingScreen.stream, 
          builder: (context, snapshot){
            if(snapshot.data ?? false){
              return SpinPerfect(
                spins: 10,
                infinite: true,
                child: IconButton(
                  onPressed: (){

                  }, 
                  icon: const Icon(Icons.refresh_rounded)),
              );
            }
            return FadeIn(
                animate: query.isNotEmpty,
                child: IconButton(
                  onPressed: (){
                    query = "";
                    }, 
                  icon: const Icon(Icons.close)),
              );
          })
      
      // SpinPerfect(
      //   infinite: true,
      //   child: const IconButton(
      //     onPressed: null, 
      //     icon: Icon(Icons.refresh_rounded)),
      // ),


      // FadeIn(
      //   animate: query.isNotEmpty,
      //   child: IconButton(
      //     onPressed: (){
      //       query = "";
      //       }, 
      //     icon: const Icon(Icons.close)),
      // )

    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      onPressed: (){
        _clearStreams();
        close(context, null);
    },icon: const Icon(Icons.arrow_back));
  }

  @override
  Widget buildResults(BuildContext context) {
    
    
    return moviesBuilder();
  }

  @override
  Widget buildSuggestions(BuildContext context) {

    _onQueryChanged(query);

    return moviesBuilder();
  }
}

class _MoviesCards extends StatelessWidget {
  final Movie movie;
  final Function closeCallback;
  const _MoviesCards({required this.movie, required this.closeCallback});

  @override
  Widget build(BuildContext context) {

    final appSize = MediaQuery.of(context).size;
    final appTheme = Theme.of(context).textTheme;

    return InkWell(
      onTap: () {
        closeCallback(context,movie);
      },
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: appSize.width * 0.2,
              child: ClipRRect(
                borderRadius: const BorderRadius.all(Radius.circular(20)),
                child: Image.network(movie.posterPath),
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              width: appSize.width * 0.7,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(movie.title, style: appTheme.titleMedium,),
                  (movie.overview.length > 100)
                  ?Text('${movie.overview.substring(0,100)}...')
                  :Text(movie.overview),
                  Row(
                    children: [
                      Icon(Icons.star_half_outlined, color: Colors.yellow.shade800,),
                      Text(HumanFormatter.number(movie.voteAverage, 1), style: TextStyle(color: Colors.yellow.shade900),)
                    ],
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}