
import 'package:flutter/cupertino.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';


class DaoList extends StatelessWidget {
  const DaoList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}

Future<List<Map<String,Object?>>> consultar2() async {
  String caminho = join(await getDatabasesPath(), 'banco0.db');
  Database bd = await openDatabase(
    caminho,
    onCreate: (db, version) {
      db.execute('');
    },
  );

  List<Map<String,Object?>> dados = await bd.rawQuery('SELECT * FROM funcionario');
  return dados;
}

Future<List<Map<String, Object?>>> consultar() async {
  await Future.delayed(const Duration(seconds: 1));
  String path = join(await getDatabasesPath(), 'banco0.db');
  //deleteDatabase(path);
  Database database = await openDatabase(
    path,
    version: 1,
    onCreate: (db, v){
      db.execute('CREATE TABLE funcionario(id INTEGER PRIMARY KEY, nome TEXT, funcao TEXT, cpf TEXT, email TEXT,telefone TEXT)');
    },
  );
  List<Map<String, Object?>> list = await database.rawQuery('SELECT * FROM funcionario');
  return list;
}



Future<int> excluir(int id) async {
  String caminho = join(await getDatabasesPath(), 'banco0.db');
  Database banco2 = await openDatabase(caminho, version: 1);
  String sql = "DELETE FROM funcionario WHERE id = ?";
  Future<int> linhaAfetada;
  linhaAfetada = banco2.rawDelete(sql, [id]);
  return linhaAfetada;
}

