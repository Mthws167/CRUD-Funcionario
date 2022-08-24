import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../dao/dao-add.dart';

import '../main.dart';


class AddFuncionarioDinamico extends StatefulWidget {
  const AddFuncionarioDinamico({Key? key}) : super(key: key);

  @override
  State<AddFuncionarioDinamico> createState() => _AddFuncionarioDinamicoState();
}

class _AddFuncionarioDinamicoState extends State<AddFuncionarioDinamico> {
  dynamic id;
  DAO dao = new DAO();
  String? nome;
  String? funcao;
  String? cpf;
  String? email;
  String? telefone;


  @override
  Widget build(BuildContext context){
    var argumento = ModalRoute.of(context)?.settings.arguments;
    if(argumento != null){
      Map<String,Object?> funcionario =  argumento as Map<String,Object?>;
      id = funcionario['id'] as int;
      nome = funcionario['nome'] as String;
      funcao = funcionario['funcao'] as String;
      cpf = funcionario['cpf'] as String;
      email = funcionario['email'] as String;
      telefone = funcionario['telefone'] as String;
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Cadastro Funcionário'),
        actions: [
          IconButton(
              icon: const Icon(Icons.check_box_outlined),
              onPressed: (){
                dao.salvar(context,id,nome,funcao,cpf,email,telefone);
                setState((){});
                Navigator.push(context, new MaterialPageRoute(
                    builder:(context)=> MyApp()
                )
                );
              }
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.all(15.0),
          child: Form(
            child: Column(children: [
              dao.criarCampo('Nome:', 'Digite seu nome',
                      (valorDigitado) => nome = valorDigitado, nome),
              dao.criarCampo('Função:', 'Digite sua função',
                      (valorDigitado) => funcao = valorDigitado, funcao),
              dao.criarCampo('CPF:', 'Apenas números',
                      (valorDigitado) => cpf = valorDigitado, cpf),
              dao.criarCampo('Telefone:', 'Apenas números e sem dígito',
                      (valorDigitado) => telefone = valorDigitado, telefone),
              dao.criarCampo('E-mail:', 'Digite seu e-mail',
                      (valorDigitado) => email = valorDigitado, email),
            ]),
          ),
        ),
      ),
    );
  }
}
