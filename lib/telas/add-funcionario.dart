import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import '../main.dart';

// ignore: must_be_immutable
class AddFuncionario extends StatelessWidget{
  dynamic id;
  String? nome;
  String? funcao;
  String? cpf;

  AddFuncionario({Key? key}) : super(key: key);

  Future<int> salvar(BuildContext context, int? id, String? nome, String? funcao, String? cpf) async {
    String path = join(await getDatabasesPath(), 'banco1.db');
    //deleteDatabase(path);
    Database database = await openDatabase(path,version: 1);
    String sql;
    Future<int> linhasAfetadas;
    if(id == null){
      sql = 'INSERT INTO funcionario (nome, funcao,cpf) VALUES (?,?,?)';
      linhasAfetadas = database.rawInsert(sql,[nome,funcao,cpf]);
    }else if(nome == null || cpf == null){
      sql = 'INSERT INTO funcionario (nome, funcao,cpf) VALUES (?,?,?)';
      linhasAfetadas = database.rawInsert(sql,[nome,funcao,cpf]);
    }else{
      sql = 'UPDATE funcionario SET nome = ?, funcao =? , cpf=? WHERE id = ?';
      linhasAfetadas = database.rawUpdate(sql,[nome, funcao, cpf,id]);
    }

    Navigator.push(context, new MaterialPageRoute(
        builder:(context)=> MyApp()
    )
    );

    return linhasAfetadas;


  }

  Future<int> excluir(int id) async {
    String caminho = join(await getDatabasesPath(), 'banco1.db');
    Database banco1 = await openDatabase(caminho, version: 1);
    String sql = "DELETE FROM funcionario WHERE id = ?";
    Future<int> linhaAfetada;
    linhaAfetada = banco1.rawDelete(sql, [id]);
    return linhaAfetada;
  }

  Widget _criarCampo(String rotulo, String? dica, ValueChanged<String>? vincularValor, String? valorInicial){
    return TextFormField(
      decoration: InputDecoration(
          label: Text(rotulo),
          hintText: dica
      ),
      onChanged: vincularValor,
      initialValue: valorInicial ??='',
    );
  }

  @override
  Widget build(BuildContext context){
    var argumento = ModalRoute.of(context)?.settings.arguments;
    if(argumento != null){
      Map<String,Object?> funcionario =  argumento as Map<String,Object?>;
      id = funcionario['id'] as int;
      nome = funcionario['nome'] as String;
      funcao = funcionario['funcao'] as String;
      cpf = funcionario['cpf'] as String;
    }

    return Scaffold(
        appBar: AppBar(
          title: const Text('Cadastro Funcionário'),
          actions: [
            IconButton(
                icon: const Icon(Icons.check_box_outlined),
                onPressed: (){
                  salvar(context,id,nome,funcao,cpf);
                  Navigator.pop(context);
                }
            ),
          ],
        ),
      body: new SingleChildScrollView(
        child: new Container(
          margin: new EdgeInsets.all(15.0),
          child: new Form(
            child: Column(children: [
              _criarCampo('Nome:', 'Digite seu nome',
                      (valorDigitado) => funcao = valorDigitado, funcao),
              _criarCampo('Função:', 'Digite sua função',
                      (valorDigitado) => funcao = valorDigitado, funcao),
              _criarCampo('CPF:', 'Digite seu CPF',
                      (valorDigitado) => funcao = valorDigitado, funcao),
            ]),
          ),
        ),
      ),
    );
  }
}