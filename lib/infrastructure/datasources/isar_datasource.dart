import 'package:isar/isar.dart';
import 'package:moviedb_app/domain/datasources/local_storage_datasource.dart';
import 'package:moviedb_app/domain/entities/movie.dart';
import 'package:path_provider/path_provider.dart';

class IsarDatasource extends LocalStorageDatasource {

  late Future<Isar> db;

  IsarDatasource(){
    db = openDB();
  }


  Future<Isar> openDB() async {
    final dir = await getApplicationDocumentsDirectory();
    final isar = await Isar.open([MovieSchema], directory: dir.path);

    if(Isar.instanceNames.isEmpty){
      return isar;
    }
    return Future.value(Isar.getInstance());
  }

  //Este metodo buscara si la pelicula favorita esta almacenada en la base de datos local
  @override
  Future<bool> isMovieFavorite(int movieId) async {
    final isar = await db;

    final Movie? isFavoriteMovie = await isar.movies
      .filter()
      .idEqualTo(movieId)
      .findFirst();

    print(isFavoriteMovie != null);
    return isFavoriteMovie != null;
  }

  //Regresara un listado con todos los datos en la base de datos local
  @override
  Future<List<Movie>> loadMovies({int limit = 10, int offset = 0}) async {
    final isar = await db;

    return isar.movies.where()
            .offset(offset)
            .limit(limit)
            .findAll();
  }


  //Se encargara de realizar la logica correspondiente al agregado de favoritos..
  @override
  Future<void> toggleFavorites(Movie movie) async {
    final isar = await db;

    final Movie? favoriteMovie = await isar.movies
      .filter()
      .idEqualTo(movie.id)
      .findFirst();

    if(favoriteMovie != null){
      isar.writeTxnSync(() => isar.movies.deleteSync(favoriteMovie.isarId!));
      return;
    }
    isar.writeTxnSync(() => isar.movies.putSync(movie));
  }


}