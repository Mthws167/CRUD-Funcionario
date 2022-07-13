import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class ListaUsuarios extends StatelessWidget {
  String? nome;
  String? descricao;

  Future<List<Map<String, Object?>>> buscarDados2() async {
    String caminhBD = join(await getDatabasesPath(), 'banco.db');
    Database banco =
    await openDatabase(caminhBD, version: 1, onCreate: (db, version) {
      db.execute(''' 
        CREATE TABLE usuario(
          id INTEGER PRIMARY KEY,
          nome TEXT NOT NULL,
          descricao TEXT NOT NULL
        )
      ''');
      db.execute(
          'INSERT INTO usuario (nome, email ) VALUES ("Matheus", "mthws.henrique@hotmail.com")');
      db.execute(
          'INSERT INTO usuario (nome, email ) VALUES ("Igor", "igor.email@hotmail.br")');
      db.execute(
          'INSERT INTO usuario (nome, email ) VALUES ("Fulano", "ciclano@@beltrano.com")');
    });

    List<Map<String, Object?>> usuario =
    await banco.rawQuery('SELECT * FROM usuario');
    return usuario;
  }

  excluir(int id)async{

    var caminho = join(await getDatabasesPath(), 'banco.db');
    var banco = await openDatabase(caminho);
    String sql;
    sql = 'DELETE FROM usuario WHERE id=?';
    banco.rawDelete(sql, [id]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Lista de Usuários'),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () => Navigator.pushNamed(context, '/addUsuarios'),
          )
        ],
      ),
      body: FutureBuilder(
        future: buscarDados2(),
        builder:
            (context, AsyncSnapshot<List<Map<String, Object?>>> dadosFuturos) {
          if (!dadosFuturos.hasData) return const CircularProgressIndicator();
          var usuario = dadosFuturos.data!;
          return ListView.builder(
            itemCount: usuario.length,
            itemBuilder: (context, index) {
              var usuarios = usuario[index];

              return Card(
                elevation: 4,
                margin: const EdgeInsets.all(8),
                child:ListTile(
                  title: Text(tarefa['nome'].toString()),
                  subtitle: Text(tarefa['descricao'].toString()),
                  trailing: ElevatedButton(
                    child: Icon(Icons.delete),
                    onPressed: () {
                      showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              content: Text("Tem certeza que deseja excluir?"),
                              actions: [
                                ElevatedButton(
                                  child: Text("Sim"),
                                  onPressed: () {
                                    TarefaForm form = new TarefaForm();
                                    form.excluir(
                                        int.parse(tarefa['id'].toString()));
                                    Navigator.pushNamed(context, '/');
                                  },
                                ),
                                ElevatedButton(
                                  child: Text("Não"),
                                  onPressed: () {
                                    Navigator.pushNamed(context, '/');
                                  },
                                ),
                              ],
                            );
                          });

                ),
              );
            },
          );
        },
      ),
    );
  }
}
