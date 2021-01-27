import 'package:flutter/material.dart';
import 'login/login.dart';
import 'login/signin.dart';
import '../model/session.dart';
import '../util/databaseHelper.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  DataBaseHelper db = DataBaseHelper();
  @override
  void initState() {
    super.initState();
    getSession();
  }

  void getSession() async {
    Session session = await db.getSession();
    if (session != null) {
      if (session.isAuth()) {
        Navigator.pushNamed(context, '/home', arguments: {'session': session});
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                height: 20,
              ),
              Image.asset(
                'images/logo_ifpi.png',
                width: 180,
              ),
              SizedBox(
                height: 50,
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  width: double.infinity,
                  height: 50,
                  child: FlatButton(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8)),
                    child: Text(
                      'Entrar',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold),
                    ),
                    color: Colors.green[500],
                    onPressed: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => Login()));
                    },
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  width: double.infinity,
                  height: 50,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.green, width: 1.3)),
                  child: FlatButton(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8)),
                      child: Text(
                        'Criar Conta',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      color: Colors.transparent,
                      onPressed: () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) => Signin()));
                      }),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
