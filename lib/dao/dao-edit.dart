import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:cpf_cnpj_validator/cpf_validator.dart';

import '../main.dart';



class DaoEdit extends StatelessWidget {
  DaoEdit({Key? key}) : super(key: key);
  dynamic validarEmail = r"[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\.[a-z0-9!#$%&'*+/=?^_`{|}~-]+)*@(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?";
  dynamic validarTelefone = r"^[+]*[(]{0,1}[0-9]{1,4}[)]{0,1}[-\s\./0-9]*$";

  Future<int> salvar(BuildContext context, int? id, String? nome,
      String? funcao, String? cpf, String? email, String? telefone) async {
    String path = join(await getDatabasesPath(), 'banco0.db');
    //deleteDatabase(path);
    Database database = await openDatabase(path, version: 1);
    String sql;
    Future<int> linhasAfetadas;
    if (id == null &&
        CPFValidator.isValid(cpf) &&
        RegExp(validarEmail).hasMatch(email!) &&
        RegExp(validarTelefone).hasMatch(telefone!)) {
      sql =
      'INSERT INTO funcionario (nome, funcao,cpf,email, telefone) VALUES (?,?,?,?,?)';
      linhasAfetadas = database.rawInsert(
          sql, [nome, funcao, CPFValidator.format(cpf!), email, telefone]);
    } else {
      sql =
      'UPDATE funcionario SET nome = ?, funcao =? , cpf=?, email=?,telefone=? WHERE id = ?';
      linhasAfetadas = database.rawUpdate(
          sql, [nome, funcao, CPFValidator.format(cpf!), email, telefone, id]);
    }

    Navigator.push(
        context, new MaterialPageRoute(builder: (context) => MyApp()));

    return linhasAfetadas;
  }

  Widget criarCampo(String rotulo, String? dica,
      ValueChanged<String>? vincularValor, String? valorInicial) {
    return TextFormField(
      decoration: InputDecoration(label: Text(rotulo), hintText: dica),
      onChanged: vincularValor,
      initialValue: valorInicial ??= '',
    );
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    throw UnimplementedError();
  }
}
