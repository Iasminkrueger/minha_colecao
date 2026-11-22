import 'package:flutter/material.dart';
import '../models/livro.dart';

// Card de um livro: capa colorida + título, autor, etiquetas e descrição.
class LivroCard extends StatelessWidget {
  final Livro livro;
  final VoidCallback aoEditar;
  final VoidCallback aoExcluir;

  const LivroCard({
    super.key,
    required this.livro,
    required this.aoEditar,
    required this.aoExcluir,
  });

  static const List<Color> _coresCapa = [
    Color(0xFF8D6E63),
    Color(0xFF5C6BC0),
    Color(0xFF26A69A),
    Color(0xFFEF5350),
    Color(0xFF7E57C2),
    Color(0xFFFFA726),
  ];

  // A cor depende do tamanho do nome.
  Color _corDaCapa() => _coresCapa[livro.nome.length % _coresCapa.length];

  // Cor da etiqueta de acordo com o status.
  Color _corStatus() {
    switch (livro.status) {
      case 'Lendo':
        return Colors.blue;
      case 'Lido':
        return Colors.green;
      default:
        return Colors.orange;
    }
  }

  Widget _etiqueta(String texto, Color cor) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: cor.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        texto,
        style: TextStyle(
          fontSize: 12,
          color: cor,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: aoEditar,
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // "Capa" do livro
              Container(
                width: 64,
                height: 92,
                decoration: BoxDecoration(
                  color: _corDaCapa(),
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 4,
                      offset: Offset(2, 2),
                    ),
                  ],
                ),
                child: Center(
                  child: Text(
                    livro.nome.isEmpty ? '?' : livro.nome[0].toUpperCase(),
                    style: const TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              // Informações
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      livro.nome,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF4E342E),
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      livro.autor,
                      style: TextStyle(color: Colors.grey[700]),
                    ),
                    const SizedBox(height: 6),
                    Wrap(
                      spacing: 6,
                      runSpacing: 4,
                      children: [
                        _etiqueta(livro.categoria, const Color(0xFF6D4C41)),
                        _etiqueta(livro.status, _corStatus()),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Text(
                      livro.descricao,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(fontSize: 13, color: Colors.grey[600]),
                    ),
                  ],
                ),
              ),
              IconButton(
                icon: const Icon(Icons.delete_outline, color: Colors.red),
                onPressed: aoExcluir,
              ),
            ],
          ),
        ),
      ),
    );
  }
}