import 'package:dio/dio.dart';
import 'package:moviedb_app/config/constants/environment.dart';
import 'package:moviedb_app/domain/datasources/movies_datasource.dart';
import 'package:moviedb_app/domain/entities/movie.dart';
import 'package:moviedb_app/infrastructure/mappers/movie_mapper.dart';
import 'package:moviedb_app/infrastructure/models/moviedb/moviedb_details.dart';
import 'package:moviedb_app/infrastructure/models/moviedb/moviedb_response.dart';

class MoviedbDatasource extends MoviesDatasource{
  final dio = Dio(BaseOptions(
    baseUrl: "https://api.themoviedb.org/3",
    queryParameters: {
      'api_key':Environment.theMovieDbKey,
      'language':'es-MX'
    }));

    
  List<Movie> getMovies(Response response){
    final moviedbResponse = MovieDbResponse.fromJson(response.data);

    final List<Movie> movie = moviedbResponse.results
    .where((moviedb) => moviedb.posterPath != 'no-poster')
    .map(
      (moviedb) => MovieMapper.mapToMovieEntity(moviedb)
    ).toList();

    return movie;
  }

  @override
  Future<List<Movie>> getNowPlaying({int page = 1}) async {

    final response = await dio.get(
      "/movie/now_playing",
      queryParameters: {
        'page':page
      }
      );

    return getMovies(response);
  }
  
  @override
  Future<List<Movie>> getTopRated({int page = 1}) async {
    final response = await dio.get(
      "/movie/top_rated",
      queryParameters: {
        'page':page
      }
    );

    return getMovies(response);
  }
  
  @override
  Future<List<Movie>> getUpcoming({int page = 1}) async {
    final response = await dio.get(
      "/movie/upcoming",
      queryParameters: {
        'page':page
      }
    );
    return getMovies(response);
  }
  
  @override
  Future<Movie> getMovieDetails(String movieId) async {
    final response = await dio.get(
      "/movie/$movieId",
    );
    final moviedbDetails = MovieDbDetails.fromJson(response.data);
    return MovieMapper.movieDetailsToEntity(moviedbDetails);
  }
  
  @override
  Future<List<Movie>> searchMovie(String query) async {

    if(query == '') return [];

    final response = await dio.get("/search/movie?query=$query");

    return getMovies(response);
  }

}