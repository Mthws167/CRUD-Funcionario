import 'package:flutter_test/flutter_test.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';


void main() {
   Database? _db;
   String criarFuncionario = '''
    CREATE TABLE funcionario (
    id INTEGER PRIMARY KEY,
    nome TEXT NOT NULL,
    funcao TEXT NOT NULL, 
    cpf TEXT NOT NULL, 
    email TEXT NOT NULL,
    telefone TEXT NOT NULL,
    )''';

   Future<Database> getDatabase() async {
    if (_db == null) {
      var path = join(await getDatabasesPath(), 'banco0.db');
      _db = await openDatabase(
        path,
        version: 1,
        onCreate: (db, version) {
          db.execute(criarFuncionario);
        },
      );
    }
    return _db!;
  }

  tearDown((){ //executa o que foi definido após cada teste
  });

  tearDownAll((){ //executa o que foi definido após todos os testes
    _db?.close();
  });

  group('teste conexao',(){ // definindo um grupo de testes
    test('conexão nula', () async{
      expect(_db?.isOpen, null);
    });

  });
}