import 'dart:async';
import 'dart:io';

import 'package:flutter_storage_practices/models/ogrenciler.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static DatabaseHelper _databaseHelper;
  static Database _database;
  String _ogrenciTablo = "ogrenci";
  String _sutunID = "id";
  String _sutunIsim = "isim";
  String _sutunAktif = "aktif";

  factory DatabaseHelper() {
    if (_databaseHelper == null) {
      _databaseHelper = DatabaseHelper._internal();
      print("DBHelper null olduğu için oluşturuldu");
      return _databaseHelper;
    } else {
      return _databaseHelper;
    }
  }

  DatabaseHelper._internal();

  Future<Database> _getDatabase() async {
    if (_database == null) {
      _database = await _initializeDatabase();
      return _database;
    } else {
      return _database;
    }
  }

  _initializeDatabase() async {
    Directory klasor = await getApplicationDocumentsDirectory();
    String dbPath = join(klasor.path, "db");

    var mainDB = openDatabase(dbPath, version: 1, onCreate: _createDB);

    return mainDB;
  }

  FutureOr<void> _createDB(Database db, int version) async {
    print("createdb çalışıp tablo oluşturacak");
    var sonuc = await db.execute(
        "CREATE TABLE $_ogrenciTablo ($_sutunID INTEGER PRIMARY KEY AUTOINCREMENT, $_sutunIsim TEXT, $_sutunAktif INTEGER)");
  }

  Future<int> ogrenciEkle(Ogrenciler ogrenci) async {
    var db = await _getDatabase();
    var sonuc = await db.insert(_ogrenciTablo, ogrenci.toMap(),
        nullColumnHack: "$_sutunID");
    print("ogrenci dbye eklendi"+sonuc.toString());
      return sonuc;
  }

  Future<List<Map<String, dynamic>>> tumOgrenciler() async {
    var db = await _getDatabase();
    var sonuc = await db.query(_ogrenciTablo, orderBy: "$_sutunID DESC");
    return sonuc;
  }

  Future<int> ogrenciGuncelle(Ogrenciler ogrenci) async {
    var db = await _getDatabase();
    var sonuc = await db.update(_ogrenciTablo, ogrenci.toMap(),
        where: "$_sutunID = ?", whereArgs: [ogrenci.id]);
    return sonuc;
  }

  Future<int> ogrenciSil(int id) async {
    var db = await _getDatabase();
    var sonuc =
        await db.delete(_ogrenciTablo, where: "$_sutunID= ? ", whereArgs: [id]);
    return sonuc;
  }

  Future<int> tumTabloyuSil() async {
    var db = await _getDatabase();
    var sonuc = await db.delete(_ogrenciTablo);
    return sonuc;
  }
}
