import 'package:flutter/material.dart';
import '../model/contato.dart';
import '../util/databaseHelper.dart';
import './adicionarContato.dart';

class Contatos extends StatefulWidget {
  @override
  _ContatosState createState() => _ContatosState();
}

class _ContatosState extends State<Contatos> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  DataBaseHelper db = DataBaseHelper();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text('Contatos'),
        centerTitle: true,
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () async {
          await Navigator.push(context,
              MaterialPageRoute(builder: (context) => AdicionarContato()));

          setState(() {});
        },
      ),
      body: FutureBuilder(
        future: db.getContatos(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text(snapshot.error));
          }

          List<Map> data = snapshot.data;

          return data != null
              ? ListView.builder(
                  itemCount: data.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      onLongPress: () {
                        _showMyDialog({
                          'id': data[index]['id'],
                          'nome': data[index]['nome'],
                          'latlong': data[index]['latlong'],
                          'endereco': data[index]['endereco']
                        });
                      },
                      leading: CircleAvatar(
                        child: Text(data[index]['nome'].toString()[0]),
                      ),
                      title: Text(data[index]['nome']),
                      subtitle: Column(
                        children: [
                          Text(data[index]['endereco']),
                          Text('LatLong: ${data[index]['latlong']}')
                        ],
                      ),
                    );
                  })
              : Container(
                  child: Center(
                    child: Text(
                        'Sua lista está vazia, adicione contatos para vê-los aqui'),
                  ),
                );
        },
      ),
    );
  }

  Future<void> _showMyDialog(Map<String, dynamic> mapa) async {
    TextEditingController _controllerNome = TextEditingController();
    TextEditingController _controllerLatLong = TextEditingController();
    TextEditingController _controllerEndereco = TextEditingController();

    _controllerNome.text = mapa['nome'];
    _controllerLatLong.text = mapa['latlong'];
    _controllerEndereco.text = mapa['endereco'];

    return showDialog<void>(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return AlertDialog(
            title: Text("Atualizar Contato"),
            content: SingleChildScrollView(
              child: ListBody(
                children: [
                  TextField(
                    decoration: InputDecoration(labelText: 'Nome'),
                    controller: _controllerNome,
                  ),
                  TextField(
                    decoration: InputDecoration(labelText: 'LatLong'),
                    controller: _controllerLatLong,
                  ),
                  TextField(
                    decoration: InputDecoration(labelText: 'Valor'),
                    controller: _controllerEndereco,
                  )
                ],
              ),
            ),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('Cancelar')),
              FlatButton(
                  onPressed: () async {
                    Contato contato = Contato(
                        id: mapa['id'],
                        nome: _controllerNome.text,
                        latlong: _controllerLatLong.text,
                        endereco: _controllerEndereco.text);
                    await db.updateContato(contato);
                    Navigator.of(context).pop();

                    setState(() {});
                    _scaffoldKey.currentState.showSnackBar(SnackBar(
                        content: Text('Contato Atualizado com sucesso!')));
                  },
                  child: Text('Enviar'))
            ],
          );
        });
  }
}
