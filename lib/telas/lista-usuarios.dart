import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import '../main.dart';
import 'add-usuario.dart';

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
    });

    List<Map<String, Object?>> usuario =
        await banco.rawQuery('SELECT * FROM usuario');
    return usuario;
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
                  child: ListTile(
                    title: Text(usuarios['nome'].toString()),
                    subtitle: Text(usuarios['descricao'].toString()),
                    trailing: FlatButton(
                        child: Icon(Icons.delete,color: Colors.black38,),
                        onPressed: () {
                          showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  content:
                                      Text("Deseja excluir?"),
                                  actions: [
                                    ElevatedButton(
                                      child: Text("Sim"),
                                      onPressed: () {
                                        AddUsuario form = new AddUsuario();
                                        form.excluir(int.parse(
                                            usuarios['id'].toString()));
                                        Navigator.push(context, new MaterialPageRoute(
                                            builder:(context)=> MyApp()
                                        ));
                                      },
                                    ),
                                    ElevatedButton(
                                      child: Text("Não"),
                                      onPressed: () {
                                        Navigator.pop(context
                                        );
                                      },
                                    ),
                                  ],
                                );
                              });
                        }),
                  ));
            },
          );
        },
      ),
    );
  }
}
