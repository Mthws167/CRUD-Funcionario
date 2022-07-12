import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

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

    Navigator.pushNamed(context, '/');
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