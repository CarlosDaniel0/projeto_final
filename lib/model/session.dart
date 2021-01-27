class Session {
  int id;
  int userId;
  String data;
  int autenticado;

  Session({this.id, this.userId, this.data, this.autenticado});

  bool isAuth() {
    if (this.autenticado == 1) {
      return true;
    } else {
      return false;
    }
  }

  Session.fromMap(Map<String, dynamic> mapa) {
    id = mapa['id'];
    userId = mapa['userId'];
    data = mapa['data'];
    autenticado = mapa['autenticado'];
  }

  Map<String, dynamic> toMap() {
    Map<String, dynamic> mapa = Map<String, dynamic>();
    mapa['userId'] = userId;
    mapa['data'] = data;
    mapa['autenticado'] = autenticado;
    return mapa;
  }
}
