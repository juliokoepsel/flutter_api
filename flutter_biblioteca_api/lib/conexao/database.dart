import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '/book/favorite.dart';

class DatabaseHandler {
  Future<Database> initializeDB() async {
    String path = await getDatabasesPath();
    return openDatabase(
      join(path, 'library_api.db'),
      onCreate: (database, version) async {
        await database.execute(
          '''CREATE TABLE book(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            id_livro TINYTEXT NOT NULL,
            titulo TINYTEXT,
            data_hora TINYTEXT,
            small_thumbnail TINYTEXT)''',
        );
      },
      version: 1,
    );
  }

  Future<int> insertFavorite(List<Favorite> objs) async {
    int result = 0;
    final Database db = await initializeDB();
    for (var obj in objs) {
      result = await db.insert('book', obj.toMap());
    }
    return result;
  }

  Future<List<Favorite>> retrieveFavorites() async {
    final Database db = await initializeDB();
    final List<Map<String, Object?>> queryResult = await db.query('book');
    return queryResult.map((e) => Favorite.fromMap(e)).toList();
  }

  Future<void> deleteFavorite(String idLivro) async {
    final db = await initializeDB();
    await db.delete(
      'book',
      where: "id_livro = ?",
      whereArgs: [idLivro],
    );
  }
}
