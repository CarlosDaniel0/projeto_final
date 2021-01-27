class Contato {
  int id;
  String nome;
  String latlong;
  String endereco;

  Contato({this.id, this.nome, this.latlong, this.endereco});
  Contato.fromMap(Map<String, dynamic> map) {
    id = map['id'];
    nome = map['nome'];
    latlong = map['latlong'];
    endereco = map['endereco'];
  }

  Map<String, dynamic> toMap() {
    Map<String, dynamic> data = Map<String, dynamic>();
    data['id'] = id;
    data['nome'] = nome;
    data['latlong'] = latlong;
    data['endereco'] = endereco;
    return data;
  }
}
