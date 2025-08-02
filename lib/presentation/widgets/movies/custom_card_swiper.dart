import 'package:animate_do/animate_do.dart';
import 'package:card_swiper/card_swiper.dart';
import 'package:flutter/material.dart';
import 'package:moviedb_app/domain/entities/movie.dart';

class CustomCardSwiper extends StatelessWidget {
  final List<Movie> movies;

  const CustomCardSwiper({super.key, required this.movies});

  @override
  Widget build(BuildContext context) {
    
    final colorTheme = Theme.of(context).colorScheme;

    return SizedBox(
      height: 210,
      width: double.infinity,
      child: Swiper(
        viewportFraction: 0.8,
        scale: 0.9,
        autoplay: true,
        itemCount: movies.length,
        itemBuilder: (context, index) {
          return  _CardUnit(movie: movies[index],);
        },
        pagination: SwiperPagination(
          margin: const EdgeInsets.all(0),
          builder: DotSwiperPaginationBuilder(
            activeColor: colorTheme.primary,
            color: colorTheme.secondary
            
          )
        ),
        ),
    );
  }
}

class _CardUnit extends StatelessWidget {
  final Movie movie;

  const _CardUnit({required this.movie});


  final decoration = const BoxDecoration(
    borderRadius: BorderRadius.all(Radius.circular(20)),
    boxShadow: <BoxShadow>[
      BoxShadow(
        color: Colors.black12,
        blurRadius: 10,
        offset: Offset(0, 10)
        )
    ]
  );

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 30),
      child: DecoratedBox(
        decoration: decoration,
        child: ClipRRect(
          borderRadius: const BorderRadius.all(Radius.circular(20)),
          child: Image.network(
            movie.backdropPath,
            fit: BoxFit.cover,
            loadingBuilder: (context, child, loadingProgress) {
              if(loadingProgress != null){
                return const Center(child: CircularProgressIndicator(),);
              }
              return FadeIn(child: child);
            },
            )
          )
        ),
    );
  }
}