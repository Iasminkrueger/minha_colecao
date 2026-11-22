# Minha Coleção

Aplicativo em Flutter para organizar uma coleção de livros. Os dados ficam salvos em um **banco de dados local (SQLite)**, no próprio dispositivo, e continuam disponíveis depois de fechar e abrir o aplicativo. O app não usa internet, Firebase, Supabase nem qualquer API externa.

Projeto desenvolvido para a atividade **Flutter com Banco de Dados Local**.

## Tema

Coleção de **livros**. Cada livro pode ter um destes status:

- Quero ler
- Lendo
- Lido

## Funcionalidades

- **Listagem:** mostra os livros gravados no banco local, em ordem alfabética.
- **Cadastro:** formulário com validação. Nome, autor, categoria e descrição não podem ficar vazios.
- **Edição:** altera os dados de um livro e grava a alteração no banco.
- **Exclusão:** pede confirmação com `AlertDialog` antes de excluir.
- **Pesquisa por nome** e **filtro por status** (Todos, Quero ler, Lendo, Lido), que podem ser usados juntos.
- **Estados da interface:** carregamento, lista com dados, lista vazia e erro (com botão "Tentar novamente").
- **Tratamento de erros:** as operações de banco usam `try/catch` e mostram uma mensagem ao usuário em caso de falha.

## Tecnologias

- [Flutter](https://flutter.dev) e Dart
- [sqflite](https://pub.dev/packages/sqflite): SQLite para Flutter
- [path](https://pub.dev/packages/path): montagem do caminho do arquivo do banco

### Por que sqflite?

O app precisa de pesquisa por nome e filtro por status. Com SQL, isso é feito de forma direta (`LIKE` e `WHERE`). Os livros também têm campos bem definidos, que se encaixam em uma tabela.

## Estrutura do projeto

```
lib/
├── main.dart
├── models/
│   └── livro.dart
├── pages/
│   ├── home_page.dart
│   └── form_page.dart
├── services/
│   └── database_service.dart
└── widgets/
    └── livro_card.dart
```

O acesso ao banco fica somente em `database_service.dart`. As telas não usam o banco diretamente:

```
Interface (pages e widgets)
        ↓
Service (database_service.dart)
        ↓
Banco de dados local (SQLite)
```

## Banco de dados

Arquivo do banco: `colecao_livros_v2.db`, criado automaticamente na primeira execução.

Tabela `livros`:

| Campo     | Tipo    | Descrição                                       |
|-----------|---------|-------------------------------------------------|
| id        | INTEGER | Chave primária, gerada automaticamente          |
| nome      | TEXT    | Nome do livro (obrigatório)                     |
| autor     | TEXT    | Autor do livro (obrigatório)                    |
| categoria | TEXT    | Categoria, como Romance ou Distopia             |
| descricao | TEXT    | Breve descrição do livro                        |
| status    | TEXT    | Quero ler, Lendo ou Lido                        |

### CRUD

| Operação | Método do sqflite | Método no projeto |
|----------|-------------------|-------------------|
| Create   | `db.insert`       | `inserir`         |
| Read     | `db.query`        | `listar`          |
| Update   | `db.update`       | `atualizar`       |
| Delete   | `db.delete`       | `excluir`         |

Todas as operações são assíncronas (`Future`, `async` e `await`).

## Como executar

### Pré-requisitos

- [Flutter](https://docs.flutter.dev/get-started/install) instalado
- Emulador Android ou celular Android conectado

### Passos

```bash
git clone https://github.com/Iasminkrueger/minha_colecao.git
cd minha_colecao
flutter pub get
flutter run
```

Escolha o dispositivo **Android** quando o Flutter mostrar a lista de dispositivos.

> **Observação:** o sqflite não funciona direto no Chrome nem no Windows, sem configuração extra. Por isso, o app deve ser executado em um emulador ou celular Android.


