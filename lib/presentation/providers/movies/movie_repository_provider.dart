

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:moviedb_app/infrastructure/datasources/moviedb_datasource.dart';
import 'package:moviedb_app/infrastructure/repositories/movie_repository_impl.dart';


//Repositorio inmutable
final movieRepositoyProvider = Provider((ref) {
  return MovieRepositoryImpl(MoviedbDatasource());
});