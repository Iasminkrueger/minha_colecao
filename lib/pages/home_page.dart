import 'package:flutter/material.dart';
import '../models/livro.dart';
import '../services/database_service.dart';
import '../widgets/livro_card.dart';
import 'form_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // Variáveis que controlam os estados da interface.
  bool _carregando = true;
  String? _erro;
  List<Livro> _livros = [];

  String _busca = '';
  String _filtroStatus = 'Todos';

  @override
  void initState() {
    super.initState();
    _carregar(); // consulta o banco ao abrir o app
  }

  // Leitura assíncrona do banco, com tratamento de erro.
  Future<void> _carregar() async {
    setState(() {
      _carregando = true;
      _erro = null;
    });

    try {
      final lista = await DatabaseService.instance.listar(
        busca: _busca,
        status: _filtroStatus,
      );
      if (!mounted) return;
      setState(() {
        _livros = lista;
        _carregando = false;
      });
    } catch (erro) {
      if (!mounted) return;
      setState(() {
        _erro = 'Não foi possível carregar os dados.';
        _carregando = false;
      });
    }
  }

  // Abre o formulário e recarrega a lista se algo foi salvo.
  Future<void> _abrirFormulario([Livro? livro]) async {
    final alterou = await Navigator.push<bool>(
      context,
      MaterialPageRoute(builder: (_) => FormPage(livro: livro)),
    );
    if (alterou == true) _carregar();
  }

  // Confirmação com AlertDialog antes de excluir.
  Future<void> _confirmarExclusao(Livro livro) async {
    final confirmou = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Excluir livro'),
        content: Text('Deseja excluir "${livro.nome}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Excluir'),
          ),
        ],
      ),
    );

    if (confirmou != true) return;

    try {
      await DatabaseService.instance.excluir(livro.id!);
      _carregar();
    } catch (erro) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Erro ao excluir o livro.')),
      );
    }
  }

  // Escolhe o que mostrar de acordo com o estado atual.
  Widget _corpo() {
    if (_carregando) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_erro != null) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.error_outline, size: 64, color: Colors.red),
            const SizedBox(height: 8),
            Text(_erro!),
            const SizedBox(height: 8),
            ElevatedButton(
              onPressed: _carregar,
              child: const Text('Tentar novamente'),
            ),
          ],
        ),
      );
    }

    if (_livros.isEmpty) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.menu_book, size: 80, color: Colors.brown[200]),
            const SizedBox(height: 12),
            const Text(
              'Nenhum livro encontrado',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            Text(
              'Toque em "Novo livro" para começar',
              style: TextStyle(color: Colors.grey[600]),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.only(bottom: 90),
      itemCount: _livros.length,
      itemBuilder: (context, index) {
        final livro = _livros[index];
        return LivroCard(
          livro: livro,
          aoEditar: () => _abrirFormulario(livro),
          aoExcluir: () => _confirmarExclusao(livro),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final filtros = ['Todos', ...Livro.statusLista];

    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Cabeçalho
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Minha Biblioteca',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF4E342E),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${_livros.length} livro(s) na lista',
                    style: TextStyle(color: Colors.grey[700]),
                  ),
                ],
              ),
            ),
            // Pesquisa por nome
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
              child: TextField(
                decoration: InputDecoration(
                  hintText: 'Pesquisar livro pelo nome',
                  prefixIcon: const Icon(Icons.search),
                  filled: true,
                  fillColor: Colors.white,
                  contentPadding: const EdgeInsets.symmetric(vertical: 0),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide: BorderSide.none,
                  ),
                ),
                onChanged: (texto) {
                  _busca = texto;
                  _carregar();
                },
              ),
            ),
            // Filtro por status
            SizedBox(
              height: 44,
              child: ListView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                children: filtros
                    .map(
                      (s) => Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: ChoiceChip(
                          label: Text(s),
                          selected: _filtroStatus == s,
                          onSelected: (_) {
                            _filtroStatus = s;
                            _carregar();
                          },
                        ),
                      ),
                    )
                    .toList(),
              ),
            ),
            const SizedBox(height: 4),
            Expanded(child: _corpo()),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _abrirFormulario(),
        icon: const Icon(Icons.add),
        label: const Text('Novo livro'),
      ),
    );
  }
}