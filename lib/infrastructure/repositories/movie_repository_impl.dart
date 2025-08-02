import 'package:moviedb_app/domain/datasources/movies_datasource.dart';
import 'package:moviedb_app/domain/entities/movie.dart';
import 'package:moviedb_app/domain/repositories/movies_repositories.dart';

class MovieRepositoryImpl extends MoviesRepositories {

  final MoviesDatasource datasource;

  MovieRepositoryImpl(this.datasource);

  @override
  Future<List<Movie>> getNowPlaying({int page = 1}) {
    
    return datasource.getNowPlaying(page: page);
  }
  
  @override
  Future<List<Movie>> getTopRated({int page = 1}) {
    
    return datasource.getTopRated(page: page);
  }
  
  @override
  Future<List<Movie>> getUpcoming({int page = 1}) {
    
    return datasource.getUpcoming(page: page);
  }
  
  @override
  Future<Movie> getMovieDetails(String movieId) {
    
    return datasource.getMovieDetails(movieId);
  }
  
  @override
  Future<List<Movie>> searchMovie(String query) {
    
    return datasource.searchMovie(query);
  }

}