import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../util/databaseHelper.dart';
import '../model/session.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  DataBaseHelper db = DataBaseHelper();
  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic> args = ModalRoute.of(context).settings.arguments;
    Session session = args['session'];
    void selecao(escolha) async {
      if (escolha == 'logout') {
        session.autenticado = 0;
        await db.updateSession(session.userId, session);
        Navigator.popAndPushNamed(context, '/');
      }
    }

    return WillPopScope(
      onWillPop: _onBackPressed,
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          actions: [
            PopupMenuButton(
              onSelected: selecao,
              itemBuilder: (context) {
                return [
                  PopupMenuItem(
                    child: Text('Sair'),
                    value: 'logout',
                  )
                ];
              },
            )
          ],
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              ListTile(
                leading: Icon(Icons.contacts),
                title: Text('Contatos'),
                onTap: () {
                  Navigator.pushNamed(context, '/home/contatos');
                },
              ),
              ListTile(
                  leading: Icon(Icons.map),
                  title: Text('Mapa'),
                  onTap: () {
                    Navigator.pushNamed(context, '/home/mapa');
                  })
            ],
          ),
        ),
      ),
    );
  }

  Future<bool> _onBackPressed() {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Deseja sair do app?'),
            actions: [
              FlatButton(
                child: Text('Sim'),
                onPressed: () {
                  SystemChannels.platform.invokeMethod('SystemNavigator.pop');
                },
              ),
              FlatButton(
                child: Text('Não'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              )
            ],
          );
        });
  }
}
