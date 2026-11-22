import 'package:flutter/material.dart';
import '../models/livro.dart';
import '../services/database_service.dart';

// Tela de cadastro e edição (a mesma tela serve para os dois).
class FormPage extends StatefulWidget {
  final Livro? livro; // null = novo cadastro, preenchido = edição

  const FormPage({super.key, this.livro});

  @override
  State<FormPage> createState() => _FormPageState();
}

class _FormPageState extends State<FormPage> {
  final _formKey = GlobalKey<FormState>();
  final _nomeController = TextEditingController();
  final _autorController = TextEditingController();
  final _categoriaController = TextEditingController();
  final _descricaoController = TextEditingController();
  String _status = Livro.statusLista.first;

  @override
  void initState() {
    super.initState();
    // Se for edição, preenche os campos com os dados atuais.
    final livro = widget.livro;
    if (livro != null) {
      _nomeController.text = livro.nome;
      _autorController.text = livro.autor;
      _categoriaController.text = livro.categoria;
      _descricaoController.text = livro.descricao;
      _status = livro.status;
    }
  }

  @override
  void dispose() {
    _nomeController.dispose();
    _autorController.dispose();
    _categoriaController.dispose();
    _descricaoController.dispose();
    super.dispose();
  }

  Future<void> _salvar() async {
    // Validação: não deixa salvar com campo obrigatório vazio.
    if (!_formKey.currentState!.validate()) return;

    final novo = Livro(
      id: widget.livro?.id,
      nome: _nomeController.text.trim(),
      autor: _autorController.text.trim(),
      categoria: _categoriaController.text.trim(),
      descricao: _descricaoController.text.trim(),
      status: _status,
    );

    try {
      if (widget.livro == null) {
        await DatabaseService.instance.inserir(novo);
      } else {
        await DatabaseService.instance.atualizar(novo);
      }
      if (!mounted) return;
      Navigator.pop(context, true); // true = houve alteração
    } catch (erro) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Erro ao salvar. Tente novamente.')),
      );
    }
  }

  String? _obrigatorio(String? valor) {
    if (valor == null || valor.trim().isEmpty) {
      return 'Campo obrigatório';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final editando = widget.livro != null;

    return Scaffold(
      appBar: AppBar(title: Text(editando ? 'Editar livro' : 'Novo livro')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _nomeController,
                decoration: const InputDecoration(
                  labelText: 'Nome do livro',
                  border: OutlineInputBorder(),
                ),
                validator: _obrigatorio,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _autorController,
                decoration: const InputDecoration(
                  labelText: 'Autor',
                  border: OutlineInputBorder(),
                ),
                validator: _obrigatorio,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _categoriaController,
                decoration: const InputDecoration(
                  labelText: 'Categoria (ex: Romance, Fantasia)',
                  border: OutlineInputBorder(),
                ),
                validator: _obrigatorio,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _descricaoController,
                maxLines: 3,
                decoration: const InputDecoration(
                  labelText: 'Descrição',
                  border: OutlineInputBorder(),
                ),
                validator: _obrigatorio,
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: _status,
                decoration: const InputDecoration(
                  labelText: 'Status',
                  border: OutlineInputBorder(),
                ),
                items: Livro.statusLista
                    .map((s) => DropdownMenuItem(value: s, child: Text(s)))
                    .toList(),
                onChanged: (valor) {
                  if (valor != null) setState(() => _status = valor);
                },
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _salvar,
                child: const Text('Salvar'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}