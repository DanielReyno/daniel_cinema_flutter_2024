

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:moviedb_app/infrastructure/datasources/isar_datasource.dart';
import 'package:moviedb_app/infrastructure/repositories/storage_repository_impl.dart';

final localRepositoryProvider = Provider((ref) {
  return StorageRepositoryImpl(localDatasource: IsarDatasource());
});