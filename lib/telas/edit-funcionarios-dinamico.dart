
import 'package:flutter/material.dart';
import 'package:untitled/dao/dao-edit.dart';


class EditFuncionarioDinamico extends StatefulWidget {
  const EditFuncionarioDinamico({Key? key}) : super(key: key);

  @override
  State<EditFuncionarioDinamico> createState() => _EditFuncionarioDinamicoState();
}

class _EditFuncionarioDinamicoState extends State<EditFuncionarioDinamico> {
  DaoEdit daoEdit =  new DaoEdit();
  dynamic id;
  String? nome;
  String? funcao;
  String? cpf;
  String? email;
  String? telefone;


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
                daoEdit.salvar(context, id, nome, funcao, cpf,email,telefone);
                setState(() {

                });
                Navigator.pop(context);
              }),
        ],
      ),
      body:  SingleChildScrollView(
        child:  Container(
          margin:  EdgeInsets.all(15.0),
          child:  Form(
            child: Column(children: [
              daoEdit.criarCampo('Função:', 'Digite sua função',
                      (valorDigitado) => funcao = valorDigitado, funcao),
              daoEdit.criarCampo('Telefone:', 'Digite seu telefone',
                      (valorDigitado) => telefone = valorDigitado, telefone),
              daoEdit.criarCampo('E-mail:', 'Digite seu e-mail',
                      (valorDigitado) => email = valorDigitado, email),
            ]),
          ),
        ),
      ),
    );
  }
}
