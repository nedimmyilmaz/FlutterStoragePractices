import 'package:flutter/material.dart';
import 'package:flutter_storage_practices/file%20operations.dart';
import 'package:flutter_storage_practices/models/ogrenciler.dart';
import 'package:flutter_storage_practices/sharedPreferences.dart';
import 'package:flutter_storage_practices/sqfLite.dart';
import 'utils/database_helper.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  DatabaseHelper dbhelper1 = DatabaseHelper();


  @override
  Widget build(BuildContext context) {
    
    dbhelper1.ogrenciEkle(Ogrenciler("nedim", 2));
    verileriDBdenGetir();
    return MaterialApp(
      home: Scaffold(
        // body: SharedPreferencesExample(),
        body: SQFLiteOrnegi(),
      ),
    );
  }

  void verileriDBdenGetir() async {
    var  sonuc = await dbhelper1.tumOgrenciler();

  }
}
