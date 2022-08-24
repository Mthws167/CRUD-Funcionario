import 'package:flutter/material.dart';
import 'package:untitled/dao/dao-list.dart';
import 'package:untitled/telas/add-funcionario-dinamico.dart';

import '../main.dart';


class ListaFuncionarioDinamico extends StatefulWidget {
  const ListaFuncionarioDinamico({Key? key}) : super(key: key);

  @override
  State<ListaFuncionarioDinamico> createState() => _ListaFuncionarioDinamicoState();
}

class _ListaFuncionarioDinamicoState extends State<ListaFuncionarioDinamico> {
  DaoList daoList = DaoList();

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
                      leading: Text(funcionario["nome"].toString()),
                      title: Text(funcionario["cpf"].toString()),
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
                                                    context, MaterialPageRoute(
                                                    builder: (context) => MyApp(
                                                    ),

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
