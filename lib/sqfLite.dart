import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_storage_practices/utils/database_helper.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:sqflite/sqflite.dart';

import 'package:flutter/material.dart';
import 'package:flutter_storage_practices/models/ogrenciler.dart';

class SQFLiteOrnegi extends StatefulWidget {
  @override
  _SQFLiteOrnegiState createState() => _SQFLiteOrnegiState();
}

class _SQFLiteOrnegiState extends State<SQFLiteOrnegi> {
  DatabaseHelper _databaseHelper;
  List<Ogrenciler> tumOgrencilerListesi;
  bool aktiflik = false;
  var controller = TextEditingController();
  var _formKey = GlobalKey<FormState>();
  var _scaffoldKey = GlobalKey<ScaffoldState>();
  int tiklananIndexDegeri;
  int tiklananOgrIDsi;

  @override
  void initState() {
    super.initState();
    tumOgrencilerListesi = List<Ogrenciler>();
    _databaseHelper = DatabaseHelper();
    _databaseHelper.tumOgrenciler().then((gelenMap) {
      for (Map okunanOgr in gelenMap) {
        tumOgrencilerListesi.add(Ogrenciler.fromMap(okunanOgr));
      }
      setState(() {

      });
      print("gelen öğrenci sayısı " + tumOgrencilerListesi.length.toString());
    }).catchError((hata) => print("Hata oluştu " + hata));
  }

  @override
  Widget build(BuildContext context) {
    //
    // Ogrenciler ogr1 = Ogrenciler.ID(30, "Nedim", 1);
    // Map newMap = ogr1.toMap();
    //  debugPrint(newMap["isim_soyisim"].toString());
    //
    //  Ogrenciler ogr2 = Ogrenciler.fromMap(newMap);
    //  debugPrint(newMap.toString());

    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(title: Text("SQFLite Kullanımı")),
      body: Container(
        child: Column(
          children: [
            Form(
                key: _formKey,
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: TextFormField(
                        autofocus: false,
                        controller: controller,
                        validator: (kontrol) {
                          if (kontrol.length < 3) {
                            return "en az 3 karakter girin";
                          } else {
                            return null;
                          }
                        },
                        decoration: InputDecoration(
                            hintText: "Öğrenci ismi girin",
                            border: OutlineInputBorder()),
                      ),
                    ),
                    SwitchListTile(
                        title: Text("Aktif"),
                        value: aktiflik,
                        onChanged: (current) {
                          setState(() {
                            aktiflik = current;
                          });
                        })
                  ],
                )),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                RaisedButton(
                  child: Text("Öğrenci ekle"),
                  onPressed: () {
                    try {
                      if (_formKey.currentState.validate()) {
                        _ogrenciEkle(Ogrenciler(
                            controller.text, aktiflik == true ? 1 : 0));
                      }
                    } catch (e) {
                      debugPrint(
                          "------------------------------" + e.toString());
                    }
                    // Fluttertoast.showToast(msg: e.toString());
                  },
                  color: Colors.blue,
                ),
                RaisedButton(
                  child: Text("Öğrenci güncelle"),
                  onPressed: tiklananOgrIDsi  == null ? null : () {

                            if (_formKey.currentState.validate()) {
                              _ogrenciGuncelle(Ogrenciler.ID(tiklananOgrIDsi,
                                  controller.text, aktiflik == true ? 1 : 0));
                              debugPrint("**********");
                            }

                        },
                  color: Colors.yellow,
                ),
                RaisedButton(
                  child: Text("Tüm tabloyu sil"),
                  onPressed: () {
                    _tumTabloyuTemizle();
                  },
                  color: Colors.red,
                ),
              ],
            ),
            SizedBox(
              height: 20,
            ),
            SizedBox(
                child: Text("Toplam Öğrenci Sayısı : " +
                    tumOgrencilerListesi.length.toString()),
                height: 25),
            Expanded(
                child: ListView.builder(
                    itemCount: tumOgrencilerListesi.length,
                    itemBuilder: (context, index) {
                      return Row(
                        children: [
                          Container(
                            margin: EdgeInsets.symmetric(
                                vertical: 5, horizontal: 10),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20)),
                            width: MediaQuery.of(context).size.width - 100,
                            height: MediaQuery.of(context).size.height * .10,
                            child: Card(
                                elevation: 15,
                                color: tumOgrencilerListesi[index].aktif == 1
                                    ? Colors.green
                                    : Colors.orange.shade300,
                                child: ListTile(
                                    // trailing: GestureDetector(
                                    //   onTap: () {
                                    //     _ogrenciSil(
                                    //         tumOgrencilerListesi[index].id, index);
                                    //   },
                                    // ),
                                    onTap: () {
                                      setState(() {
                                        controller.text =
                                            tumOgrencilerListesi[index].isim;
                                        aktiflik =
                                            tumOgrencilerListesi[index].aktif == 1 ? true : false;
                                        tiklananIndexDegeri = index;
                                       tiklananOgrIDsi = tumOgrencilerListesi[index].id;
                                      });
                                    },
                                    title:
                                        Text(tumOgrencilerListesi[index].isim),
                                    subtitle: Text(tumOgrencilerListesi[index]
                                        .id
                                        .toString()))),
                          ),
                          Container(
                            margin: EdgeInsets.symmetric(horizontal: 4),
                            decoration: BoxDecoration(
                                color: Colors.black,
                                borderRadius: BorderRadius.circular(40)),
                            child: IconButton(
                                color: Colors.white,
                                icon: Icon(Icons.delete_forever),
                                onPressed: () {
                                  _ogrenciSil(
                                      tumOgrencilerListesi[index].id, index);
                                }),
                          )
                        ],
                      );
                    }))
          ],
        ),
      ),
    );
  }

  void _ogrenciEkle(Ogrenciler ogrenci) async {
    var yeniOgrID = await _databaseHelper.ogrenciEkle(ogrenci);
    ogrenci.id = yeniOgrID;
    if (yeniOgrID > 0) {
      setState(() {
        tumOgrencilerListesi.insert(0, ogrenci);
      });
      _scaffoldKey.currentState.showSnackBar(SnackBar(
          content: Text(yeniOgrID.toString() + " ID li öğrenci eklendi")));
    }
  }

  void _tumTabloyuTemizle() async {
    var silinenElemanSayisi = await _databaseHelper.tumTabloyuSil();
    if (silinenElemanSayisi > 0) {
      _scaffoldKey.currentState.showSnackBar(SnackBar(
        content: Text(silinenElemanSayisi.toString()),
        duration: Duration(seconds: 2),
      ));

      setState(() {
        tumOgrencilerListesi.clear();
      });
    }
  }

  void _ogrenciSil(int dbIDsi, int listeIndeksi) async {
    var sonuc = await _databaseHelper.ogrenciSil(dbIDsi);
    if (sonuc == 1) {
      _scaffoldKey.currentState.showSnackBar(SnackBar(
        content: Text(" Seçilen öğrenci silindi"),
        duration: Duration(seconds: 2),
      ));

      setState(() {
        tumOgrencilerListesi.removeAt(listeIndeksi);
      });
    } else {
      _scaffoldKey.currentState.showSnackBar(SnackBar(
        content: Text("Silerken hata çıktı"),
        duration: Duration(seconds: 2),
      ));
    }
    tiklananOgrIDsi = null;
  }

  void _ogrenciGuncelle(Ogrenciler ogrenci) async {

    var sonuc = await _databaseHelper.ogrenciGuncelle(ogrenci);
    if (sonuc == 1) {
      _scaffoldKey.currentState.showSnackBar(SnackBar(
        content: Text("Öğrenci güncellendi"),
        duration: Duration(seconds: 2),
      ));

      setState(() {
        tumOgrencilerListesi[tiklananIndexDegeri] = ogrenci;
      });
    }
  }
}
