
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class Conexao {
  static Database? _db;
  static String criarFuncionario = '''
    CREATE TABLE funcionario (
    id INTEGER PRIMARY KEY,
    nome TEXT NOT NULL,
    funcao TEXT NOT NULL, 
    cpf TEXT NOT NULL, 
    )''';

  static Future<Database> getDatabase() async {
    if (_db == null) {
      var path = join(await getDatabasesPath(), 'banco1.db');
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
}