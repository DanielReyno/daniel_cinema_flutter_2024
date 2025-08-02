import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:moviedb_app/config/helpers/human_formatter.dart';
import 'package:moviedb_app/domain/entities/movie.dart';

class MovieHorizontalListview extends StatefulWidget {
  final List<Movie> movies;
  final String? title;
  final String? subtitle;
  final VoidCallback? loadNextPage;

  const MovieHorizontalListview(
      {super.key,
      required this.movies,
      this.title,
      this.subtitle,
      this.loadNextPage});

  @override
  State<MovieHorizontalListview> createState() => _MovieHorizontalListviewState();
}

class _MovieHorizontalListviewState extends State<MovieHorizontalListview> {
  final scrollController = ScrollController();

  @override
  void initState() {
    super.initState();

    scrollController.addListener((){

      if(widget.loadNextPage == null){
        return;
      }
      if(scrollController.position.pixels + 200 >= scrollController.position.maxScrollExtent){
        widget.loadNextPage!();
      }
    });

  }

  @override
  void dispose() {
    super.dispose();
    scrollController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 359,
      width: double.infinity,
      child: Column(
        children: [

          if(widget.title != null || widget.subtitle != null)
            _Title(widget.title, widget.subtitle),
          
          Expanded(
            child: ListView.builder(
              controller: scrollController,
              itemCount: widget.movies.length,
              scrollDirection: Axis.horizontal,
              physics: const BouncingScrollPhysics(),
              itemBuilder: (context, index) {
                return FadeInRight(child: _Slide(movie: widget.movies[index]));
              })
            )
        
        ],
      ),
    );
  }
}

class _Title extends StatelessWidget {
  final String? label;
  final String? subLabel;

  const _Title(this.label, this.subLabel);

  @override
  Widget build(BuildContext context) {

    final textStyle = Theme.of(context).textTheme.titleLarge;

    return Container(
      padding: const EdgeInsets.only(top: 20),
      margin: const EdgeInsets.symmetric(horizontal: 10),
      child: Row(
        children: [
          if(label != null)
            Text(label!, style: textStyle,),

          const Spacer(),

          if(subLabel != null)
            FilledButton.tonal(
              style: const ButtonStyle(
                visualDensity: VisualDensity.compact
              ),
              onPressed: (){}, 
              child: Text(subLabel!))
        ],
      ),
      );
  }
}

class _Slide extends StatelessWidget {

  final Movie movie;
  const _Slide({required this.movie});

  @override
  Widget build(BuildContext context) {

    final textStyle = Theme.of(context).textTheme;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 150,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Image.network(
                movie.posterPath,
                width: 150,
                fit: BoxFit.cover,
                loadingBuilder: (context, child, loadingProgress) {
                 if(loadingProgress != null){
                    return const Center(heightFactor: 2 ,child: CircularProgressIndicator(),);
                 }
                  return GestureDetector(
                    onTap: () => context.push('/movie/${movie.id}'),
                    child: child
                    );
                },
                ),
            ),),
          const SizedBox(height: 5,),
          SizedBox(
            width: 150,
            child: Text(
              movie.title,
              maxLines: 2,
              style: textStyle.titleSmall,
            ),
          ),
        Row(
          children: [
            Icon(Icons.star_half_outlined, color: Colors.yellow.shade800,),
            Text(movie.voteAverage.toStringAsFixed(1), style: textStyle.bodyMedium?.copyWith(color: Colors.yellow.shade800),),
            const SizedBox(width: 20,),
            Text(HumanFormatter.number(movie.popularity ,0), style: textStyle.bodySmall,)
          ],
        ),
        ],
      )
    );
  }
}