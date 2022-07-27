import 'package:cpf_cnpj_validator/cpf_validator.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import '../main.dart';

class EditFuncionarioDinamico extends StatefulWidget {
  const EditFuncionarioDinamico({Key? key}) : super(key: key);

  @override
  State<EditFuncionarioDinamico> createState() => _EditFuncionarioDinamicoState();
}

class _EditFuncionarioDinamicoState extends State<EditFuncionarioDinamico> {
  dynamic id;
  String? nome;
  String? funcao;
  String? cpf;
  String? email;
  String? telefone;
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
      sql = 'INSERT INTO funcionario (nome, funcao,cpf,email, telefone) VALUES (?,?,?,?,?)';
      linhasAfetadas = database.rawInsert(sql, [nome, funcao, CPFValidator.format(cpf!),email, telefone]);
    }  else {
      sql = 'UPDATE funcionario SET nome = ?, funcao =? , cpf=?, email=?,telefone=? WHERE id = ?';
      linhasAfetadas = database.rawUpdate(sql, [nome, funcao, CPFValidator.format(cpf!),email,telefone, id]);
    }

    Navigator.push(
        context, new MaterialPageRoute(builder: (context) => MyApp()));

    return linhasAfetadas;
  }

  Widget _criarCampo(String rotulo, String? dica,
      ValueChanged<String>? vincularValor, String? valorInicial) {
    return TextFormField(
      decoration: InputDecoration(label: Text(rotulo), hintText: dica),
      onChanged: vincularValor,
      initialValue: valorInicial ??= '',
    );
  }


  @override
  Widget build(BuildContext context) {
    var argumento = ModalRoute.of(context)?.settings.arguments;
    if (argumento != null) {
      Map<String, Object?> funcionario = argumento as Map<String, Object?>;
      id = funcionario['id'] as int;
      nome = funcionario['nome'] as String;
      funcao = funcionario['funcao'] as String;
      cpf = funcionario['cpf'] as String;
      email = funcionario['email'] as String;
      telefone = funcionario['telefone'] as String;
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Editar Funcionário'),
        actions: [
          IconButton(
              icon: const Icon(Icons.check_box_outlined),
              onPressed: () {
                salvar(context, id, nome, funcao, cpf,email,telefone);
                setState(() {

                });
                Navigator.pop(context);
              }),
        ],
      ),
      body: new SingleChildScrollView(
        child: new Container(
          margin: new EdgeInsets.all(15.0),
          child: new Form(
            child: Column(children: [
              _criarCampo('Função:', 'Digite sua função',
                      (valorDigitado) => funcao = valorDigitado, funcao),
              _criarCampo('Telefone:', 'Digite seu telefone',
                      (valorDigitado) => telefone = valorDigitado, telefone),
              _criarCampo('E-mail:', 'Digite seu e-mail',
                      (valorDigitado) => email = valorDigitado, email),
            ]),
          ),
        ),
      ),
    );
  }
}
