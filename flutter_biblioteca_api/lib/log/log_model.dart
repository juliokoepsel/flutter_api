class LogModel {
  String? dataHora;
  String? acao;
  String? idLivro;
  String? titulo;

  LogModel({this.acao, this.idLivro, this.titulo, this.dataHora});

  LogModel.fromJson(Map<String, dynamic> json) {
    idLivro = json['id_livro'];
    acao = json['acao'];
    titulo = json['titulo'];
    dataHora = json['data_hora'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id_livro'] = idLivro;
    data['acao'] = acao;
    data['titulo'] = titulo;
    data['data_hora'] = dataHora;
    return data;
  }
}
