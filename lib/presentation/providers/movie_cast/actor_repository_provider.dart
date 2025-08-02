

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:moviedb_app/infrastructure/datasources/movie_cast_datasource.dart';
import 'package:moviedb_app/infrastructure/repositories/movie_cast_repositoy_impl.dart';

final actorRepositoryProvider = Provider((ref) {
  return MovieCastRepositoyImpl(datasource: MovieCastDatasource());
});