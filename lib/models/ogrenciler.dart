class Ogrenciler {
  int _id;
  String _isim;
  int _aktif;

  int get id => _id;

  set id(int value) {
    _id = value;
  }

  String get isim => _isim;

  int get aktif => _aktif;

  set aktif(int value) {
    _aktif = value;
  }

  set isim(String value) {
    _isim = value;
  }

  Ogrenciler(this._isim, this._aktif);

  Ogrenciler.ID(this_id,this._isim, this._aktif);

  Map<String, dynamic> toMap() {
    var map = Map<String, dynamic>();
    map["id"] = _id;
    map["isim"] = _isim;
    map["aktif"] = _aktif;
    return map;
  }

  Ogrenciler.fromMap(Map<String, dynamic> map){
    this._id = map["id"];
    this._isim = map["isim"];
    this._aktif = map["aktif"];
  }
}
