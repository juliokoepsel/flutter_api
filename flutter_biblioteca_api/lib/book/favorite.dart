class Favorite {
  final int? id;
  final String idLivro;
  final String? titulo;
  final String? dataHora;
  final String? smallThumbnail;

  const Favorite({
    this.id,
    required this.idLivro,
    this.titulo,
    this.dataHora,
    this.smallThumbnail,
  });

  Favorite.fromMap(Map<String, dynamic> res)
      : id = res["id"],
        idLivro = res["id_livro"],
        titulo = res["titulo"],
        dataHora = res["data_hora"],
        smallThumbnail = res["small_thumbnail"];

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'id_livro': idLivro,
      'titulo': titulo,
      'data_hora': dataHora,
      'small_thumbnail': smallThumbnail,
    };
  }

  @override
  String toString() {
    return 'author{id: $id, idLivro: $idLivro}';
  }
}
