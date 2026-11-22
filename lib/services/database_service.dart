import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import '../models/livro.dart';

// Classe responsável por TODO o acesso ao banco local.
// A interface nunca fala direto com o banco, só com esta classe.
class DatabaseService {
  // Singleton: existe só uma instância do serviço no app.
  static final DatabaseService instance = DatabaseService._();
  DatabaseService._();

  Database? _db;

  // Inicialização do banco: abre se já existe, cria se não existe.
  Future<Database> get database async {
    _db ??= await _iniciarBanco();
    return _db!;
  }

  Future<Database> _iniciarBanco() async {
    // Pasta de bancos do dispositivo + nome do arquivo.
    final caminho = join(await getDatabasesPath(), 'colecao_livros_v2.db');

    return openDatabase(
      caminho,
      version: 1,
      // Criação da estrutura (tabela). Só roda na primeira vez.
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE livros (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            nome TEXT NOT NULL,
            autor TEXT NOT NULL,
            categoria TEXT NOT NULL,
            descricao TEXT NOT NULL,
            status TEXT NOT NULL
          )
        ''');

        // Livros de exemplo gravados no banco na primeira vez.
        final exemplos = [
          Livro(
            nome: 'Dom Casmurro',
            autor: 'Machado de Assis',
            categoria: 'Romance',
            descricao: 'Bentinho conta a dúvida sobre a traição de Capitu.',
            status: 'Lido',
          ),
          Livro(
            nome: 'O Pequeno Príncipe',
            autor: 'Antoine de Saint-Exupéry',
            categoria: 'Fábula',
            descricao: 'Um príncipe viaja por planetas e aprende sobre amizade.',
            status: 'Lendo',
          ),
          Livro(
            nome: 'Harry Potter e a Pedra Filosofal',
            autor: 'J.K. Rowling',
            categoria: 'Fantasia',
            descricao: 'Um garoto descobre que é bruxo e vai estudar em Hogwarts.',
            status: 'Quero ler',
          ),
        ];
        for (final livro in exemplos) {
          await db.insert('livros', livro.toMap());
        }
      },
    );
  }

  // CREATE: insere um novo registro e devolve o id gerado.
  Future<int> inserir(Livro livro) async {
    final db = await database;
    return db.insert('livros', livro.toMap());
  }

  // READ: consulta registros, com pesquisa por nome e filtro por status.
  Future<List<Livro>> listar({
    String busca = '',
    String status = 'Todos',
  }) async {
    final db = await database;

    final condicoes = <String>[];
    final argumentos = <Object>[];

    if (busca.isNotEmpty) {
      condicoes.add('nome LIKE ?');
      argumentos.add('%$busca%');
    }
    if (status != 'Todos') {
      condicoes.add('status = ?');
      argumentos.add(status);
    }

    final linhas = await db.query(
      'livros',
      where: condicoes.isEmpty ? null : condicoes.join(' AND '),
      whereArgs: argumentos.isEmpty ? null : argumentos,
      orderBy: 'nome ASC',
    );

    // Converte cada linha (Map) em objeto Livro.
    return linhas.map((linha) => Livro.fromMap(linha)).toList();
  }

  // UPDATE: altera o registro que tem o id informado.
  Future<int> atualizar(Livro livro) async {
    final db = await database;
    return db.update(
      'livros',
      livro.toMap(),
      where: 'id = ?',
      whereArgs: [livro.id],
    );
  }

  // DELETE: remove o registro com o id informado.
  Future<int> excluir(int id) async {
    final db = await database;
    return db.delete('livros', where: 'id = ?', whereArgs: [id]);
  }
}