import 'package:flutter/material.dart';
import '../../util/databaseHelper.dart';
import '../../model/user.dart';
import '../../model/session.dart';
import 'dart:convert';
import 'package:crypto/crypto.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final _formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  DataBaseHelper db = DataBaseHelper();
  TextEditingController _controllerEmail = TextEditingController();
  TextEditingController _controllerPassword = TextEditingController();
  bool isObscure = true;
  bool isLogged = false;

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
                Image.asset(
                  'images/logo_ifpi.png',
                  width: 180,
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    decoration: InputDecoration(
                        prefixIcon: Icon(Icons.person),
                        labelText: 'Email',
                        hintText: 'joao@gmail.com'),
                    controller: _controllerEmail,
                    validator: (text) {
                      if (text.isEmpty) {
                        return 'Digite seu email';
                      }
                      return null;
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    decoration: InputDecoration(
                        prefixIcon: Icon(Icons.lock),
                        suffixIcon: IconButton(
                          icon: Icon(Icons.remove_red_eye),
                          onPressed: () {
                            setState(() {
                              isObscure = !isObscure;
                            });
                          },
                        ),
                        labelText: 'Senha',
                        hintText: isObscure ? '*****' : 'senha'),
                    obscureText: isObscure,
                    controller: _controllerPassword,
                    validator: (text) {
                      if (text.isEmpty) {
                        return 'Digite sua senha';
                      }
                      return null;
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8),
                  child: Container(
                    height: 50,
                    width: double.infinity,
                    child: FlatButton(
                      color: Colors.green,
                      onPressed: () async {
                        String message;
                        if (_formKey.currentState.validate()) {
                          String password = md5
                              .convert(utf8.encode(_controllerPassword.text))
                              .toString();
                          User user =
                              await db.getUser(_controllerEmail.text, password);
                          if (user != null) {
                            Session session = Session(
                              userId: user.id,
                              autenticado: 1,
                              data: DateTime.now().toString(),
                            );

                            db.setSession(session);
                            message = 'Login efetuado com sucesso';
                            Navigator.pushNamed(context, '/home',
                                arguments: {'session': session});
                          } else {
                            message = 'Erro! Login ou senha inválidos';
                          }

                          setState(() {
                            _controllerEmail.text = '';
                            _controllerPassword.text = '';
                            FocusScope.of(context).requestFocus(FocusNode());
                          });

                          _scaffoldKey.currentState
                              .showSnackBar(SnackBar(content: Text(message)));
                        }
                      },
                      child: Text(
                        'Login',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                )
              ],
            )),
      ),
    );
  }
}
