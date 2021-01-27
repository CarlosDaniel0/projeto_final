import 'package:flutter/material.dart';
import '../../util/databaseHelper.dart';
import '../../model/user.dart';
import 'dart:convert';
import 'package:crypto/crypto.dart';

class Signin extends StatefulWidget {
  @override
  _SigninState createState() => _SigninState();
}

class _SigninState extends State<Signin> {
  final _formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  TextEditingController _controllerNome = TextEditingController();
  TextEditingController _controllerEmail = TextEditingController();
  TextEditingController _controllerPassword = TextEditingController();
  bool isObscure = true;
  DataBaseHelper db = DataBaseHelper();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              SizedBox(
                height: 50,
              ),
              Image.asset('images/logo_ifpi.png', width: 180),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  controller: _controllerNome,
                  validator: (text) {
                    if (text.isEmpty) {
                      return 'Digite seu Nome';
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                      prefixIcon: Icon(Icons.person),
                      labelText: 'Nome',
                      hintText: 'João da Silva'),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  controller: _controllerEmail,
                  validator: (text) {
                    if (text.isEmpty) {
                      return 'Digite seu Email';
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                      prefixIcon: Icon(Icons.language),
                      labelText: 'Email',
                      hintText: 'joaosilva@gmail.com'),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  controller: _controllerPassword,
                  validator: (text) {
                    if (text.isEmpty) {
                      return 'Digite sua senha';
                    }
                    return null;
                  },
                  obscureText: isObscure,
                  decoration: InputDecoration(
                      prefixIcon: Icon(Icons.lock),
                      labelText: 'Senha',
                      suffixIcon: IconButton(
                        icon: Icon(Icons.remove_red_eye),
                        onPressed: () {
                          setState(() {
                            isObscure = !isObscure;
                          });
                        },
                      ),
                      hintText: isObscure ? '*****' : 'senha'),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  height: 50,
                  width: double.infinity,
                  child: FlatButton(
                    child: Text('Criar Conta',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold)),
                    color: Colors.green,
                    onPressed: () async {
                      if (_formKey.currentState.validate()) {
                        String password = md5
                            .convert(utf8.encode(_controllerPassword.text))
                            .toString();
                        User user = User(
                            email: _controllerEmail.text,
                            nome: _controllerNome.text,
                            password: password);

                        await db.inserirUser(user);

                        setState(() {
                          _controllerNome.text = '';
                          _controllerEmail.text = '';
                          _controllerPassword.text = '';
                          FocusScope.of(context).requestFocus(FocusNode());
                        });
                        _scaffoldKey.currentState.showSnackBar(SnackBar(
                            content: Text('Cadastro Realizado com sucesso!')));
                      }
                    },
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
