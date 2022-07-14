import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import '../main.dart';

class AddUsuario extends StatelessWidget {
  String? nome;
  String? descricao;


  salvar(BuildContext context, int? id, String? nome, String? descricao) async {
    var caminho = join(await getDatabasesPath(), 'banco.db');
    Database banco = await openDatabase(caminho);

    String sql;

    if (id == null) {
      sql = 'INSERT INTO usuario (nome, descricao) VALUES (?,?)';
      banco.rawInsert(sql, [nome, descricao]);
    } else {
      sql = 'UPDATE usuario SET nome = ?, descricao = ? WHRE id = ?';
      banco.rawUpdate(sql, [nome, descricao, id]);
    }

    Navigator.push(context, new MaterialPageRoute(
        builder:(context)=> MyApp()
    ));
  }

  cadastrar(int? id, String nome, String descricao) async {
    var caminho = join(await getDatabasesPath(), 'banco.db');
    var banco = await openDatabase(caminho);

    String sql;

    if (id == null) {
      sql = 'INSERT INTO usuario (nome, descricao) VALUES (?,?)';
      banco.rawInsert(sql, [nome, descricao]);
    } else {
      sql = 'UPDATE usuario SET nome = ?, descricao = ? WHRE id = ?';
      banco.rawUpdate(sql, [nome, descricao, id]);
    }
  }

  Future<int> excluir(int id) async {
    String caminho = join(await getDatabasesPath(), 'banco.db');
    Database banco = await openDatabase(caminho, version: 1);
    String sql = "DELETE FROM usuario WHERE id = ?";
    Future<int> linhaAfetada;
    linhaAfetada = banco.rawDelete(sql, [id]);
    return linhaAfetada;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Adicionar Usuário'),
        ),
        body: Form(
            child: Column(
              children: [
                TextField(
                  onChanged: (nomeDigitado) {
                    nome = nomeDigitado;
                  },
                  decoration: const InputDecoration(
                      label: Text('Nome'), hintText: 'Digite o nome do usuário'),
                ),
                TextField(
                  onChanged: (descricaoDigitada) {
                    descricao = descricaoDigitada;
                  },
                  decoration: const InputDecoration(
                      label: Text('Descrição'),
                      hintText: 'Digite a descrição do usuário'),
                ),
                ElevatedButton(
                  child: Text('Salvar usuário na lista'),
                  onPressed: () {
                    salvar(context, null, nome, descricao);
                  },
                )
              ],
            )));
  }
}