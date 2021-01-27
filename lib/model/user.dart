class User {
  int id;
  String nome;
  String email;
  String password;

  User({this.id, this.nome, this.email, this.password});
  User.fromMap(Map<String, dynamic> map) {
    id = map['id'];
    nome = map['nome'];
    email = map['email'];
    password = map['password'];
  }

  Map<String, dynamic> toMap() {
    Map<String, dynamic> data = Map<String, dynamic>();
    data['nome'] = nome;
    data['email'] = email;
    data['password'] = password;

    return data;
  }
}
