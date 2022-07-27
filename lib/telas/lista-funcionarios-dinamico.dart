import 'package:flutter/material.dart';
import 'package:untitled/telas/add-funcionario-dinamico.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import '../main.dart';


class ListaFuncionarioDinamico extends StatefulWidget {
  const ListaFuncionarioDinamico({Key? key}) : super(key: key);

  @override
  State<ListaFuncionarioDinamico> createState() => _ListaFuncionarioDinamicoState();
}

class _ListaFuncionarioDinamicoState extends State<ListaFuncionarioDinamico> {
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
    setState(() {

    });
    return linhaAfetada;
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Lista Funcionários'),
          actions: [
            IconButton(
                icon: const Icon(Icons.add),
                onPressed: () => Navigator.pushNamed(context, '/addFuncionario') )
          ],
        ),
        body: FutureBuilder(
            future:consultar(),
            builder: (context,  AsyncSnapshot<List<Map<String, Object?>>> snapshot){
              if(!snapshot.hasData) return const CircularProgressIndicator();
              var lista = snapshot.data!;
              return ListView.builder(
                  itemCount: lista.length,
                  itemBuilder: (context, contador){
                    var funcionario = lista[contador];
                    return ListTile(
                      title: Text(funcionario["nome"].toString()),
                      subtitle: Text(funcionario["funcao"].toString()),
                      trailing: SizedBox(
                        width: 100,
                        child:Row(
                          children: [
                            IconButton(
                              icon: const Icon(Icons.edit),
                              color: Colors.black38,
                              onPressed: (){
                                Navigator.pushNamed(context, '/editFuncionario', arguments: funcionario).then((value) {setState(() {

                                });
                                });
                              },
                            ),
                            IconButton(
                                icon: const Icon(Icons.delete),
                                color: Colors.black38,
                                onPressed: () {
                                  showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return AlertDialog(
                                          content:
                                          Text("Excluir?"),
                                          actions: [
                                            ElevatedButton(
                                              child: Text("Sim"),
                                              onPressed: () {
                                                AddFuncionarioDinamico form = new AddFuncionarioDinamico();
                                                excluir(int.parse(
                                                    funcionario['id'].toString()));
                                                Navigator.push(
                                                    context, new MaterialPageRoute(
                                                    builder: (context) => MyApp()
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
                                })
                          ],
                        ),
                      ),
                    );
                  }
              );
            }
        )
    );
  }
}
