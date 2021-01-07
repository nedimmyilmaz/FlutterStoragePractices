import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_storage_practices/sharedPreferences.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:fluttertoast/fluttertoast.dart';

class SharedPreferencesExample extends StatefulWidget {
  @override
  _SharedPreferencesExampleState createState() =>
      _SharedPreferencesExampleState();
}

class _SharedPreferencesExampleState extends State<SharedPreferencesExample> {
  String isim;
  int id;
  bool cinsiyet;
  var formKey = GlobalKey<FormState>();
  SharedPreferences mySharedPref;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    SharedPreferences.getInstance().then((value) => mySharedPref = value);
    // shared pref nesnesi verecek
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Shared Preferences Example")),
      body: SingleChildScrollView(
        child: Form(
          key: formKey,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(15.0),
                child: TextFormField(
                  onSaved: (deger) {
                    isim = deger;
                  },
                  decoration: InputDecoration(
                      labelText: "Enter name",
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20))),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(15.0),
                child: TextFormField(
                  onSaved: (deger) {
                    id = int.parse(deger);
                  },
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                      labelText: "Enter ID",
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20))),
                ),
              ),
              Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: RadioListTile(
                    value: false,
                    groupValue: cinsiyet,
                    onChanged: (secilen) {
                      setState(() {
                        cinsiyet = secilen;
                      });
                    },
                    title: Text("XX"),
                  )),
              Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: RadioListTile(
                    value: true,
                    groupValue: cinsiyet,
                    onChanged: (secilen) {
                      setState(() {
                        cinsiyet = secilen;
                      });
                    },
                    title: Text("XY"),
                  )),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  RaisedButton(
                    onPressed: _ekle,
                    child: Text("Ekle"),
                    color: Colors.deepPurple,
                  ),
                  RaisedButton(
                    onPressed: _goster,
                    child: Text("Göster"),
                    color: Colors.yellow,
                  ),
                  RaisedButton(
                    onPressed: _sil,
                    child: Text("Sil"),
                    color: Colors.pink,
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  void _ekle()  async{
    formKey.currentState.save();
    await mySharedPref.setString("name", isim);
    await mySharedPref.setInt("id", id);
    await mySharedPref.setBool("cinsiyet", cinsiyet);
  }

  void _goster() {
   var nameSP=  mySharedPref.getString("name").toString() ?? "bulunamadı";
  var idSP = mySharedPref.getInt("id").toString() ?? "bulunamadı";
  var sexSP = mySharedPref.getBool("sex") ?? "bulunamadı";

debugPrint(idSP + " " + nameSP + " " + sexSP);
Fluttertoast.showToast(msg: idSP + " " + nameSP + " " + sexSP );
  }

  void _sil() {
    mySharedPref.remove("name");
    mySharedPref.remove("id");
    mySharedPref.remove("sex");
  }
}
