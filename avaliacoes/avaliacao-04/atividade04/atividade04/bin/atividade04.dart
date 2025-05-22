import 'dart:io';
import 'package:sqlite3/sqlite3.dart';

void main() {
  final db = sqlite3.open('alunos.db');

  // Criar tabela TB_ALUNO se não existir
  db.execute('''
    CREATE TABLE IF NOT EXISTS TB_ALUNO (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      nome VARCHAR(50) NOT NULL
    );
  ''');

  print('=== Sistema gestão de alunos ===');

  while (true) {
    print('\nEscolha uma opção:');
    print('1 - Inserir aluno');
    print('2 - Listar alunos');
    print('3 - Sair');
    stdout.write('> ');
    String? escolha = stdin.readLineSync();

    if (escolha == '1') {
      inserirAluno(db);
    } else if (escolha == '2') {
      listarAlunos(db);
    } else if (escolha == '3') {
      print('Saindo...');
      break;
    } else {
      print('Opção inválida. Tente novamente.');
    }
  }

  db.dispose();
}

void inserirAluno(Database db) {
  stdout.write('Digite o nome do aluno (máx 50 caracteres): ');
  String? nome = stdin.readLineSync();

  if (nome == null || nome.trim().isEmpty) {
    print('Nome inválido, não pode ser vazio.');
    return;
  }

  if (nome.length > 50) {
    print('Nome muito longo. Máximo 50 caracteres.');
    return;
  }

  final stmt = db.prepare('INSERT INTO TB_ALUNO (nome) VALUES (?)');
  stmt.execute([nome.trim()]);
  stmt.dispose();

  print('Aluno "$nome" inserido com sucesso.');
}

void listarAlunos(Database db) {
  final ResultSet resultSet = db.select(
    'SELECT id, nome FROM TB_ALUNO ORDER BY id',
  );

  if (resultSet.isEmpty) {
    print('Nenhum aluno cadastrado.');
    return;
  }

  print('\nLista de alunos:');
  for (final row in resultSet) {
    print('ID: ${row['id']} - Nome: ${row['nome']}');
  }
}
