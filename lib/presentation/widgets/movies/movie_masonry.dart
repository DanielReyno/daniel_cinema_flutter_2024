import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:go_router/go_router.dart';
import 'package:moviedb_app/config/router/app_router.dart';
import 'package:moviedb_app/domain/entities/movie.dart';
import 'package:moviedb_app/presentation/widgets/widgets.dart';

class MovieMasonry extends StatefulWidget {

  final List<Movie> movies;
  final VoidCallback? loadNextPage;
  const MovieMasonry({super.key, required this.movies, this.loadNextPage});

  @override
  State<MovieMasonry> createState() => _MovieMasonryState();
}

class _MovieMasonryState extends State<MovieMasonry> {
  final infiniteScroll = ScrollController();

  @override
  void initState() {
    super.initState();
    infiniteScroll.addListener((){

      if(widget.loadNextPage == null) return;

      if(infiniteScroll.position.pixels >= infiniteScroll.position.maxScrollExtent - 200){
        
        widget.loadNextPage!();
    }
    });
  }

  @override
  void dispose() {
    super.dispose();
    infiniteScroll.dispose();
  }


  @override
  Widget build(BuildContext context) {

    final appColorTheme = Theme.of(context).colorScheme.primary;

    if(widget.movies.isEmpty){
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.favorite_border_outlined, size: 100, color: appColorTheme,),
            const Text("No tienes peliculas favoritas", style: TextStyle(fontSize: 20, ),),
            FilledButton.tonal(onPressed: (){
              context.go('/home/0');
            }, child: const Text("Buscar peliculas"))
          ],
        ),
      );
    }

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: MasonryGridView.count(
          itemCount: widget.movies.length,
          controller: infiniteScroll,
          mainAxisSpacing: 10,
          crossAxisSpacing: 10,
          crossAxisCount: 3, 
          itemBuilder: (context,index){
            if(index == 1){
              return Padding(
                padding: const EdgeInsets.only(top: 30),
                child: MoviePosterLink(movie: widget.movies[index]),);
            }
          return MoviePosterLink(movie: widget.movies[index]);
          }),
      ),
    );
  }
}