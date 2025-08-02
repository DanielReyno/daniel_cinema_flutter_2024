import 'package:moviedb_app/domain/datasources/local_storage_datasource.dart';
import 'package:moviedb_app/domain/entities/movie.dart';
import 'package:moviedb_app/domain/repositories/local_storage_repositories.dart';

class StorageRepositoryImpl extends LocalStorageRepositories {
  final LocalStorageDatasource localDatasource;

  StorageRepositoryImpl({required this.localDatasource});

  @override
  Future<bool> isMovieFavorite(int movieId) {
    return localDatasource.isMovieFavorite(movieId);
  }

  @override
  Future<List<Movie>> loadMovies({int limit = 15, int offset = 0}) {
    return localDatasource.loadMovies(limit: limit, offset: offset);
  }

  @override
  Future<void> toggleFavorites(Movie movie) {
    return localDatasource.toggleFavorites(movie);
  }
}