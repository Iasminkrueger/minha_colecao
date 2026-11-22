// Modelo que representa um livro da coleção.
class Livro {
  int? id;
  String nome;
  String autor;
  String categoria;
  String descricao;
  String status;

  // Opções de status do tema (livros).
  static const List<String> statusLista = [
    'Quero ler',
    'Lendo',
    'Lido',
  ];

  Livro({
    this.id,
    required this.nome,
    required this.autor,
    required this.categoria,
    required this.descricao,
    required this.status,
  });

  // Converte o objeto Dart em Map para gravar no banco.
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nome': nome,
      'autor': autor,
      'categoria': categoria,
      'descricao': descricao,
      'status': status,
    };
  }

  // Converte o Map lido do banco em objeto Dart.
  factory Livro.fromMap(Map<String, dynamic> map) {
    return Livro(
      id: map['id'] as int?,
      nome: map['nome'] as String,
      autor: map['autor'] as String,
      categoria: map['categoria'] as String,
      descricao: map['descricao'] as String,
      status: map['status'] as String,
    );
  }
}