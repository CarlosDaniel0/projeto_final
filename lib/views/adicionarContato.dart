import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../util/databaseHelper.dart';
import '../model/contato.dart';

class AdicionarContato extends StatefulWidget {
  @override
  _AdicionarContatoState createState() => _AdicionarContatoState();
}

class _AdicionarContatoState extends State<AdicionarContato> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  DataBaseHelper db = DataBaseHelper();
  TextEditingController _controllerNome = TextEditingController();
  TextEditingController _controllerLatLong = TextEditingController();
  TextEditingController _controllerEndereco = TextEditingController();
  Position position = Position();

  @override
  Widget build(BuildContext context) {
    if (position.latitude != null) {
      LatLng localizacao = LatLng(position.latitude, position.longitude);

      _controllerLatLong.text =
          '${localizacao.latitude},${localizacao.longitude}';
    }

    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text('Adicionar Contato'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  controller: _controllerNome,
                  decoration: InputDecoration(
                    hintText: 'João da Silva',
                    labelText: 'Nome',
                    prefixIcon: Icon(Icons.person),
                  ),
                  validator: (text) {
                    if (text.isEmpty) {
                      return 'Digite o Nome';
                    }
                    return null;
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  controller: _controllerLatLong,
                  decoration: InputDecoration(
                      labelText: 'Latitude e longitude',
                      prefixIcon: Icon(Icons.location_on),
                      suffixIcon: IconButton(
                        icon: Icon(Icons.my_location),
                        tooltip: 'Localização atual',
                        onPressed: () async {
                          Position myLocation = await _determinePosition();
                          setState(() {
                            position = myLocation;
                          });
                        },
                      )),
                  validator: (text) {
                    if (text.isEmpty) {
                      return 'Digite a localização';
                    }
                    return null;
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  controller: _controllerEndereco,
                  decoration: InputDecoration(
                    hintText:
                        'Rua José da Silva, 70, bairro Centro, Cidade das Pedras - PI',
                    labelText: 'Endereço',
                    prefixIcon: Icon(Icons.person),
                  ),
                  validator: (text) {
                    if (text.isEmpty) {
                      return 'Digite o Endereço';
                    }
                    return null;
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8),
                child: Container(
                  child: FlatButton(
                    color: Colors.green,
                    child: Text('Adicionar'),
                    onPressed: () async {
                      if (_formKey.currentState.validate()) {
                        Contato contato = Contato(
                            nome: _controllerNome.text,
                            latlong: _controllerLatLong.text,
                            endereco: _controllerEndereco.text);
                        await db.insertContato(contato);

                        setState(() {
                          _controllerNome.text = '';
                          _controllerLatLong.text = '';
                          _controllerEndereco.text = '';
                          FocusScope.of(context).requestFocus(FocusNode());
                        });

                        _scaffoldKey.currentState.showSnackBar(SnackBar(
                            content: Text('Contato Adicionado com sucesso!')));
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

  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Location permissions are permantly denied, we cannot request permissions.');
    }

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission != LocationPermission.whileInUse &&
          permission != LocationPermission.always) {
        return Future.error(
            'Location permissions are denied (actual value: $permission).');
      }
    }

    return await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
  }
}
